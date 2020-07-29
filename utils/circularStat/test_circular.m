% suite = munit_testsuite('test_template');
% r = suite.run();
% r.web();

function test = test_circular

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Do not modify the following 20 lines of codes.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Create a structure of constraint objects for assertions
    c = munit_constraint;

    % Subclass the testcase object
    stk = dbstack('-completenames');
    mname = stk(1).file;
    fcn_names = scan(mname, {'setup' ,'teardown', 'test_[A-Za-z0-9_]*'});
    for ffi=1:length(fcn_names)
        fcn_handles{ffi}=eval(['@',fcn_names{ffi}]);
    end
    test_file_info.fcn_names = fcn_names;
    test_file_info.fcn_handles = fcn_handles;
    test = munit_testcase(test_file_info);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your codes below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    tol = 0.000001; % tolerance level for this test suite.
    tol_loose = 0.001; % loose tolerance level for some cases.

    function setup
        tol = 0.000001; % tolerance level for this test suite.
        tol_loose = 0.001; % loose tolerance level for some cases.
    end

    function teardown
    end

    % Create new tests by creating new functions whose name starts with test_ 

    function test_circularMean
        x = [pi/6, pi/3, pi/2];
        y = [0.91068360252296, 1.04719755119660];
        [a,b]=circularMean(x,1);
        z = [a,b];
        test.assert( @() (norm(y-z) < tol) );
        
        x = [pi/6, -pi/6];
        [a,b]=circularMean(x,3);
        test.assert(@() a < tol);
        test.assert(@() isnan(b));
    end

    function test_circularMedian
        x = [pi/6, pi/4, pi/2];
        y = pi/4;
        z = circularMedian(x);
        test.assert(c.eq( y, circularMedian(x)));
        
        x = [pi/6, pi/4, pi/3, pi/2];
        y = (pi/4+pi/3)/2;
        test.assert(@() y == circularMedian(x));
    end

    function test_circularContMean
        myDist = @(th) 1/2/pi;
        [a,b] = circularContMean(myDist);
        test.assert(@() abs(a)<tol);
        test.assert(@() isnan(b));
    end

    function test_circularContMedian
        myDist = @(x) -3/4/pi/pi/pi*((mod(x+pi,2*pi)-pi).^2-pi*pi);
        a = circularContMedian(myDist);
        test.assert(@() abs(a)<tol_loose | abs(a)>2*pi-tol_loose);
        
        b = circularContDiff(myDist,-pi/3);
        test.assert(@() abs(b-1.381723852)<tol);
        
        c = circularContQuantile(myDist,0.75);
        test.assert(@() abs(c-1.091)<tol_loose);
    end

    function test_pdf_Uniform
        fhandle = @circularPdfUniform;
        
        r = circularContMean(fhandle);
        test.assert(@() abs(r)<tol);
        
        r3 = circularContMean(fhandle,3);
        test.assert(@() abs(r3)<tol);
        
        d = circularContDispersion(fhandle);
        test.assert(@() isnan(d));
    end

    function test_pdf_Cardioid
        rho = 0.35; % should be   0 <= rho <= 1/2
        mu = pi/3;
        fhandle = @(th) circularPdfCardioid(th,mu,rho);
        
        [r,t] = circularContMean(fhandle);
        test.assert(@() abs(t-mu)<tol);
        test.assert(@() abs(r-rho)<tol);
        
        p=2;
        rp = circularContMean(fhandle,p);
        test.assert(@() abs(rp)<tol);

        d = circularContDispersion(fhandle);
        test.assert(@() abs(d-1/2/rho/rho)<tol_loose);
    end

    function test_pdf_WrappedCauchy
        mu = pi/3;
        rho = 0.35; % should be   0 <= rho <= 1
        fhandle = @(th) circularPdfWrappedCauchy(th,mu,rho);
        
        [r,t] = circularContMean(fhandle);
        test.assert(@() abs(t-mu)<tol_loose);
        test.assert(@() abs(r-rho)<tol);

        p=2;
        [rp, tp] = circularContMean(fhandle,p);
        test.assert(@() abs(rp-rho^p)<tol_loose);
        test.assert(@() abs(tp-mu*p)<tol);

        d = circularContDispersion(fhandle);
        test.assert(@() abs(d-(1-rho^2)/2/rho/rho)<tol_loose);
    end

    function test_pdf_WrappedNormal
        mu = pi/3;
        rho = 0.35; % should be   0 <= rho <= 1
        fhandle = @(th) circularPdfWrappedNormal(th,mu,rho);
        
        [r,t] = circularContMean(fhandle);
        test.assert(@() abs(t-mu)<tol_loose);
        test.assert(@() abs(r-rho)<tol);

        p=3;
        [rp, tp] = circularContMean(fhandle,p);
        test.assert(@() abs(rp-rho^(p^2))<tol_loose);
        test.assert(@() abs(tp-mu*p)<tol_loose*2);

        d = circularContDispersion(fhandle);
        test.assert(@() abs(d-(1-rho^4)/2/rho/rho)<tol_loose);
    end

    function test_pdf_WrappedPoisson
        m = 8;
        lambda = 4;
        fhandle = @(th) circularPdfWrappedPoisson(r,lambda,m);
        
        s = sum(circularPdfWrappedPoisson([0:7],lambda,m));
        test.assert(@() abs(s-1)<tol);

%        I've not come up with a good idea to test this Poisson pdf.        
%        s = sum([0:7].*circularPdfWrappedPoisson([0:7],lambda,m));
%        test.assert(@() abs(s-1)<tol);
        
    end

    function test_pdf_VonMises
        Ipk = @(p,k) besseli(p,k);
        Apk = @(p,k) besseli(p,k)/besseli(0,k);

        mu = pi/2;
        kappa = 3;
        fhandle = @(th) circularPdfVonMises(th,mu,kappa);
        
        [r,t] = circularContMean(fhandle);
        test.assert(@() abs(t-mu)<tol_loose);
        test.assert(@() abs(r-Apk(1,kappa))<tol);

        p=3;
        [rp, tp] = circularContMean(fhandle,p);
        test.assert(@() abs(rp-Apk(p,kappa))<tol_loose);
        test.assert(@() abs(tp-mu*p)<tol_loose*2);

        d = circularContDispersion(fhandle);
        test.assert(@() abs(d-1/kappa/Apk(1,kappa))<tol_loose);
    end

end




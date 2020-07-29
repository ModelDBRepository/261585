function result = circularQuad(fhandle, a, b, quadtol)
%
%< circularQuad >
%  This is a simple helper function for circular toolbox.
%  You don't have to pay much attention to this function.
%
if isnan(quadtol)
    result = quad(fhandle,a,b);
else
    result = quad(fhandle,a,b,quadtol);
end
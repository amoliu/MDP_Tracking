classdef TestTransform
    %TestTransform
    properties (Constant)
    end
    
    methods (Static)
        function test_1
            M = [cos(pi/4),sin(pi/4);...
                -sin(pi/4),cos(pi/4);];
            src = shiftdim(randn(10,2),-1);
            dst = cv.transform(src,M);
        end
        
        function test_error_1
            try
                cv.transform();
                throw('UnitTest:Fail');
            catch e
                assert(strcmp(e.identifier,'mexopencv:error'));
            end
        end
    end
    
end


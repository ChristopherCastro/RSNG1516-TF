classdef Threads < handler
    properties
        queues = [];
        queueLen = 1;
    end
    
    methods
        % Constructor
        %
        function obj = Threads(nThreads, queueLen)
            for q = 1:nThreads
                obj.queues(end + 1) = eventsQueue();
            end;   
            obj.queueLen = queueLen;
        end;
    end
    
end


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
        
        function [e] = getEvent(obj)
            e = obj.queues(1).first();

            for q = 2:length(obj.queues)
                c = obj.queues(q).first();
                if c.tllegada < e.tllegada
                    e = c;
                end;
            end;
        end;
    end
end


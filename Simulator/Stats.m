classdef Stats < handle
    
    properties
        time = [];
        countClientsInServer = [];
        countClientsWaiting = [];
        countBusyThreads = [];
        tWaitQueue = [];
        tMeanWaitQueue = [];
        tWaitSystem = [];
        tMeanWaitSystem = [];
        countRejected = [];
        ro = [];
    end
    
    methods
        
        function collect(obj, threads,e)
            obj.time(end+1) = e.tllegada;
            obj.countClientsInServer(end+1) = threads.countClientsInServer();
            obj.countClientsWaiting(end+1) = threads.countClientsWaiting();
            obj.countBusyThreads(end+1) = threads.countBusyThreads();
            obj.tWaitQueue(end+1) = e.tServidor - e.tEntradaSistema;
            obj.tWaitSystem(end+1) = e.tllegada - e.tEntradaSistema;
            if isempty(obj.tMeanWaitQueue) %If this is the 1st collect event, tMeanWait=tWait
                obj.tMeanWaitQueue(end+1) = obj.tWaitQueue(end);
                obj.tMeanWaitSystem(end+1) = obj.tWaitSystem(end);
            else
                obj.tMeanWaitQueue(end+1) = mean(obj.tWaitQueue);
                obj.tMeanWaitSystem(end+1) = mean(obj.tWaitSystem);
            end
            obj.countRejected(end+1) = length(threads.unhandled);
            obj.ro(end+1) = (threads.countBusyThreads()+threads.countClientsWaiting())/(threads.nThreads+threads.wqLen);
        end
    end
    
end


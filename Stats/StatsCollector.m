classdef StatsCollector < handle
    
    properties
        time = [];
        countClientsInServer = [];
        countClientsWaiting = [];
        countMeanClientsWaiting = [];
        countBusyThreads = [];
        tWaitQueue = [];
        tMeanWaitQueue = [];
        tWaitSystem = [];
        tMeanWaitSystem = [];
        countRejected = [];
        percentRejected = [];
        lambda = [];
        mu = [];
        rhoMM1 = []; %Empty server based rho
        meanRhoMM1 = [];
        rhoResources = []; %Resources based rho.
        meanRhoResources = [];
    end
    
    methods
        function collect(obj, threads,e)
            obj.time(end + 1) = e.tllegada;
            obj.countClientsInServer(end + 1) = threads.countClientsInServer();
            obj.countClientsWaiting(end + 1) = threads.countClientsWaiting();
            obj.countMeanClientsWaiting(end + 1) = mean(obj.countClientsWaiting);
            obj.countBusyThreads(end + 1) = threads.countBusyThreads();
            obj.tWaitQueue(end + 1) = e.tServidor - e.tEntradaSistema;
            obj.tWaitSystem(end + 1) = e.tllegada - e.tEntradaSistema;
            if isempty(obj.tMeanWaitQueue) %If this is the 1st collect event, tMeanWait=tWait
                obj.tMeanWaitQueue(end+1) = obj.tWaitQueue(end);
                obj.tMeanWaitSystem(end+1) = obj.tWaitSystem(end);
            else
                obj.tMeanWaitQueue(end+1) = mean(obj.tWaitQueue);
                obj.tMeanWaitSystem(end+1) = mean(obj.tWaitSystem);
            end
            obj.countRejected(end+1) = length(threads.unhandled);
            obj.percentRejected(end+1) = length(threads.unhandled)/(length(threads.unhandled)+length(obj.time));

            obj.lambda(end + 1) = e.idllegada / e.tllegada;
            obj.mu(end + 1) = length(obj.time) / e.tllegada;
            obj.rhoMM1(end + 1) = 1-sum(obj.countClientsInServer==0)/length(obj.countClientsInServer);
            obj.meanRhoMM1(end+1) = mean(obj.rhoMM1);
            obj.rhoResources(end+1) = threads.countClientsInServer()/(threads.nThreads+threads.wqLen);
            obj.meanRhoResources(end+1) = mean(obj.rhoResources);
        end
    end
    
end


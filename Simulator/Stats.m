classdef Stats < handle
    
    properties
        time = [];
        countClientsInServer = [];
        countClientsWaiting = [];
        countBusyThreads = [];
        tWait = [];
        tMeanWait = [];
        countRejected = [];
    end
    
    methods
        %Returns the complete matrix with the stats
        function [stats] = getStatsMatrix(obj)
            countServed = (1:length(obj.time));
            stats = [obj.time; obj.countClientsInServer; obj.tWait; obj.tMeanWait; obj.countRejected; countServed];
        end
        
        function collect(obj, threads,e)
            obj.time(end+1) = e.tllegada;
            obj.countClientsInServer(end+1) = threads.countClientsInServer();
            obj.countClientsWaiting(end+1) = threads.countClientsWaiting();
            obj.countBusyThreads(end+1) = threads.countBusyThreads();
            obj.tWait(end+1) = e.tServidor - e.tEntradaSistema;
            if isempty(obj.tMeanWait) %If this is the 1st collect event, tMeanWait=tWait
                obj.tMeanWait(end+1) = obj.tWait(end);
            else
                obj.tMeanWait(end+1) = mean(obj.tWait);
            end
            obj.countRejected(end+1) = length(threads.unhandled);       
        end
    end
    
end


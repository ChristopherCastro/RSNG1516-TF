classdef Stats < handle
    
    properties
        time = [];
        countClientsOnServer = [];
        countClientsOnWait = [];
        countBusyThreads = [];
        tWait = [];
        tMeanWait = [];
        countRejected = [];
    end
    
    methods
        %Returns the complete matrix with the stats
        function [stats] = getStatsMatrix(obj)
            countServed = (1:length(obj.time));
            stats = [obj.time; obj.countClientsOnServer; obj.tWait; obj.tMeanWait; obj.countRejected; countServed];
        end
        
        function collect(obj, threads,e)
            obj.time(end+1) = e.tllegada;
            obj.countClientsOnServer(end+1) = threads.countClientsOnServer();
            obj.countClientsOnWait(end+1) = threads.countClientsOnWait();
            obj.countBusyThreads(end+1) = threads.countBusyThreads();
            obj.tWait(end+1) = e.tServidor - e.tllegada;
            if isempty(obj.tMeanWait) %If this is the 1st collect event, tMeanWait=tWait
                obj.tMeanWait(end+1) = obj.tWait(end);
            else
                obj.tMeanWait(end+1) = (obj.tMeanWait(end) + obj.tWait(end))/length(obj.tWait);
            end
            obj.countRejected(end+1) = length(threads.unhandled);       
        end
    end
    
end


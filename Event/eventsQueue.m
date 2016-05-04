classdef eventsQueue < handle
    properties
        queue = [];
    end

    methods
        function [] = setQueue(obj, q)
            obj.queue = q;
        end;
        
        function [e] = pop(obj)
            e = obj.queue(1);
            obj.queue(1) = [];
        end;
    end
end


classdef eventsQueue < handle
    properties
        queue = [];
    end

    methods
        % Inicializa la cola.
        %
        % # Entradas:
        %
        % {q}: Un listado de eventos resultado de alguno de los generadores
        function [] = setQueue(obj, q)
            obj.queue = q;
        end;
        
        % Extrae y retorna el primer elemento de la cola
        %
        % # Retorno:
        %
        % Un evento de la cola 
        function [e] = pop(obj)
            e = obj.queue(1);
            obj.queue(1) = [];
        end;
        
        % Verifica si la cola esta vacía o no.
        %
        % # Retorno:
        %
        % 1 si la cola está vacia, 0 en otro caso.
        function [e] = isEmpty(obj)
            e = isempty(obj.queue);
        end;
    end
end


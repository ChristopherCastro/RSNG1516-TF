classdef eventsQueue < handle
    properties
        queue = [];
    end

    methods
        % Constructor
        %
        function obj = eventsQueue(q)
            obj.queue = q;
        end;

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
        
        % Verifica si la cola esta vac�a o no.
        %
        % # Retorno:
        %
        % 1 si la cola est� vacia, 0 en otro caso.
        function [e] = isEmpty(obj)
            e = isempty(obj.queue);
        end;

        % Consula el primer elemento de la cola sin quitarlo de la misma.
        %
        % # Retorno:
        %
        % El primer elemento de la cola
        function [h] = first(obj)
            h = obj.queue(1);
        end;
    end
end


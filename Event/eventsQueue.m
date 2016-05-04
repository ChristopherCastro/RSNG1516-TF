classdef eventsQueue < handle
    properties
        queue = [];
    end

    methods
        % Constructor
        %
        function obj = eventsQueue(q)
            if nargin == 1
                obj.queue = q;
            end;
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
        
        % Retorna el número de elementos en la cola.
        %
        % # Retorno
        %
        % Un entero mayor o igual a cero
        function [c] = count(obj)
            c = length(obj.queue);
        end;

        % Verifica si la cola esta vacía o no.
        %
        % # Retorno:
        %
        % 1 si la cola está vacia, 0 en otro caso.
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


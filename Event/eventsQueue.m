% A simple and generic queue manager.
%
% # Usage:
%
% ```matlab
%  queue = new eventsQueue(listOfEvents);
%  while queue.hasNext()
%      event = queue.next();
%      % do nifty things with {event}
%  end;
% ```
classdef eventsQueue < handle
    properties
        queue = [];
        head = 1;
    end

    methods
        % Constructor
        %
        function obj = eventsQueue(q)
            if nargin == 1
                obj.queue = q;
            end;
        end;
        
        % Establece la cabeza de la cola a una posición arbitraria.
        %
        % - {newHead}: Nueva posición de la cabeza.
        function [] = setHead(obj, newHead)
            obj.head = newHead;
        end;
        
        % Retorna el elemento apuntado por la cabeza.
        %
        % # Retorno:
        %
        % Un evento de la cola 
        function [e] = next(obj)
            e = obj.queue(obj.head);
            obj.head = obj.head + 1;
        end;
        
        % Retorna el número de elementos en la cola. Es decir, el número de
        % elementos entre el último elemento extraido y el final de la
        % cola en sí.
        %
        % # Retorno
        %
        % Un entero mayor o igual a cero
        function [c] = count(obj)
            c = length(obj.queue) - obj.head - 1;
        end;

        % Verifica si hay más elementos en la cola o no.
        %
        % # Retorno:
        %
        % - 1: Si la cola NO está vacia.
        % - 0: En otro caso.
        function [e] = hasNext(obj)
            e = obj.head <= length(obj.queue);
        end;

        % Consula el primer elemento de la cola sin quitarlo ni avanzar la
        % cabezade la misma.
        %
        % # Retorno:
        %
        % El primer elemento de la cola
        function [f] = first(obj)
            f = obj.queue(1);
        end;
        
        % Consula el último elemento de la cola sin quitarlo ni alterar la
        % cabeza de la misma.
        %
        % # Retorno:
        %
        % El último elemento de la cola
        function [l] = last(obj)
            l = obj.queue(end);
        end;
        
        % Inserta un nuevo evento al final de la cola.
        %
        % # Argumentos
        %
        % - {event}: Un nuevo evento
        function add(obj, event)
            obj.queue(end + 1) = event;
        end;
    end
end


classdef Threads < handle
    properties
        % List of queues, one for each thread
        queues = {};
        
        % Wait queue length
        wqLen = 1;
    end
    
    methods
        % Constructor
        %
        function obj = Threads(nThreads, wqLen)
            obj.wqLen = wqLen;
            for q = 1:nThreads
                obj.queues{end + 1} = eventsQueue();
            end;   
        end;

        function [e, qIdx] = getEvent(obj)
            e = struct('tllegada', inf);

            for q = 1:length(obj.queues)
                if obj.queues{q}.size() > 0
                    c = obj.queues{q}.first();
                    if c.tllegada < e.tllegada
                        qIdx = q;
                        e = c;
                    end;
                end;
            end;
        end;

        % Si alguno de los hilos a�n tiene trabajo por delante.
        function [h] = hasNext(obj)
            h = 0;

            for q = 1:length(obj.queues)
                if obj.queues{q}.hasNext()
                    h = 1;
                    break;
                end;
            end;
        end;
        
        function [] = handle(obj, lEvent)
            lEvent.tipo = 'S';
            tllegada = lEvent.tllegada;
            qIdx = 1;
            
            for q = 1:length(obj.queues)
                queue = obj.queues{qIdx};

                if queue.size() == 0
                    qIdx = q;
                    break;
                elseif queue.last().tllegada < tllegada
                    tllegada = queue.last().tllegada;
                    qIdx = q;
                end;
            end;

            lEvent.tllegada = lEvent.tservicio + tllegada;
            obj.queues{qIdx}.add(lEvent);
        end;

        function [] = moveHead(obj, qIdx)
            obj.queues{qIdx}.moveHead();
        end;

        % Consulta si el servidor tiene hueco para bien atender una
        % petici�n o encolarla en su cola de servicio.
        %
        % # Retorno
        % 
        % {1}: El server esta lleno, asi que la petici�n rechazada
        % {0}: Cualquier otro caso
        function [i] = isServerFull(obj)
            s = 0;

            for q = 1:length(obj.queues)
                s = s + obj.queues{q}.size();
            end;

            i = (s - length(obj.queues)) >= obj.wqLen;
        end;
    end
end


classdef Threads < handle
    properties
        % List of queues, one for each thread
        queues = {};
        
        % Wait queue length
        wqLen = 1;
        
        % Unhandled events due to overbooking
        unhandled = [];
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

        % Retorna un evento de salida de alguna de las colas (hilos).
        %
        % # Retorno:
        %
        % Un evento, en caso de no haber ninguno disponible retorna un
        % event "nulo" cuyo tiempo de llegada de "inf"
        function [e, qIdx] = getEvent(obj)
            e = struct('tllegada', inf);
            qIdx = -1;

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

        % Si alguno de los hilos aún tiene trabajo por delante.
        %
        % # Retorno:
        %
        % 1 si alguna de las colas tiene algún evento de salida. 0 en otro
        % caso.
        function [h] = hasNext(obj)
            h = 0;

            for q = 1:length(obj.queues)
                if obj.queues{q}.hasNext()
                    h = 1;
                    break;
                end;
            end;
        end;
        
        % Intenta atender una petición.
        %
        % Aquellos eventos que no puedan ser atendidos, porque todos los
        % hilos están ya ocupados y la cola de espera está llena, entonces
        % el evento será movido a la propiedad de esta clase "unhandled".
        %
        % # Retorno:
        %
        % 1 Si ha atendido la petición, 0 si el evento no puedo ser
        % atendido.
        function [success] = handle(obj, lEvent)
            success = 0;

            if ~obj.isServerFull()
                success = 1;
                lEvent.tipo = 'S';
                tllegada = lEvent.tllegada;
                qIdx = 1;

                for q = 1:length(obj.queues)
                    queue = obj.queues{q};

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
            else
                obj.unhandled = [obj.unhandled lEvent];
            end;
        end;

        function [] = moveHead(obj, qIdx)
            obj.queues{qIdx}.moveHead();
        end;

        % Consulta si el servidor tiene hueco para bien atender una
        % petición o encolarla en su cola de servicio.
        %
        % # Retorno
        % 
        % {1}: El server esta lleno, asi que la petición rechazada
        % {0}: Cualquier otro caso
        function [i] = isServerFull(obj)
            s = 0;

            for q = 1:length(obj.queues)
                s = s + obj.queues{q}.size();
            end;

            i = (s - length(obj.queues)) >= obj.wqLen;
        end;
        
        % Retorna una representción tipo texto de los hilos
        function [out] = toString(obj)
            s = 0;
            for q = 1:length(obj.queues)
                s = s + obj.queues{q}.size();
            end;
            
            used = (s - length(obj.queues));
            notUsed = obj.wqLen - (s - length(obj.queues));
            waitQueueUsedSlot = '';
            waitQueueEmptySlot = '';

            if used > 0
                waitQueueUsedSlot = repmat('*', 1, used);
            end;

            if notUsed > 0
                waitQueueEmptySlot = repmat('-', 1, notUsed);
            end;

            out = sprintf('Wait Queue: [%s%s] \n', waitQueueUsedSlot, waitQueueEmptySlot);
        end;
    end
end

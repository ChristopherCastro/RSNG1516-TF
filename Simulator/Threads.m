classdef Threads < handle
    properties
        % List of queues, one for each thread
        queues;
        nThreads = 0;
        
        % Wait queue length
        wqLen = 1;
        
        % Unhandled events due to overbooking
        unhandled = []
    end
    
    methods
        % Constructor
        %
        function obj = Threads(nThreads, wqLen)         
            if isinf(wqLen)
                wqLen = intmax;
            end;

            obj.nThreads = nThreads;
            obj.wqLen = wqLen;

            for q = 1:obj.nThreads
                obj.queues{q} = eventsQueue();
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
        % 1 Si ha atendido la petición, 0 si el evento no puede ser
        % atendido.
        function [success] = handle(obj, lEvent)
            success = 0;

            if obj.isServerFull() == 0
                success = 1;
                lEvent.tipo = 'S';
                tllegada = inf;
                qIdx = 1;

                for q = 1:obj.nThreads
                    queue = obj.queues{q};

                    if queue.size() == 0
                        qIdx = q;
                        tllegada = lEvent.tllegada;
                        break;
                    elseif queue.last().tllegada < tllegada
                        tllegada = queue.last().tllegada;
                        qIdx = q;
                    end;
                end;

                lEvent.tServidor = tllegada;
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
            i = obj.countClientsInServer() == (obj.wqLen + obj.nThreads);
        end;
        
        % Cuenta el número de clientes dentro del servidor, es decir, la
        % suma aquellos que están siendo atendidos por alguno de los hilos
        % y aquellos en la cola de espera.
        %
        % # Retorno:
        %
        % Un entero mayor o igual a cero.
        function [s] = countClientsInServer(obj)
            s = obj.countBusyThreads() + obj.countClientsWaiting();         
        end;

        % Cuenta el número de hilos actualmente ocupados.
        %
        % # Retorno:
        %
        % Un entero mayor o igual a cero.
        function [b] = countBusyThreads(obj)
            b = 0;

            for q = 1:length(obj.queues)
                if obj.queues{q}.size() > 0
                    b = b + 1;
                end;
            end;
        end;

        % Cuenta el número de clientes esperando por alguno hilo para ser
        % atendido. Es decir, en cola.
        %
        % # Retorno:
        %
        % Un entero mayor o igual a cero.
        function [w] = countClientsWaiting(obj)
            w = 0;
            for q = 1:obj.nThreads
                w = w + max(0, (obj.queues{q}.size() - 1));
            end;
        end;
    end
end

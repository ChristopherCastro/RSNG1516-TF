% Representa una maquina (servidor/ordenador) a simular
classdef MachineSimulator < handle
    properties
        nHilos;
        waitQueueLen;
        lQueue;
        threads;
        stats;
    end
    
    methods
        
        % Constructor.
        %
        % nHilos: Número de hilos
        % waitQueueLen: Tamaño de la cola de espera, la cola de espera es
        %               compartida entre todos los hilos.
        % lQueue: Una cola con los eventos de llegada, resultado de uno de
        %         los generadores de eventos.
        function obj = MachineSimulator(nHilos, waitQueueLen, lQueue)
            obj.nHilos = nHilos;
            obj.waitQueueLen = waitQueueLen;
            obj.lQueue = lQueue;
            obj.threads = Threads(nHilos, waitQueueLen);
            obj.stats = StatsCollector();
        end;

        % Lanza la simulación de esta máquina
        %
        function [s] = run(obj)
            while (obj.lQueue.hasNext() || obj.threads.hasNext())
                e = obj.getEvent();
                if e.tipo == 'L'
                    obj.threads.handle(e);
                elseif e.tipo == 'S'
                    % evento de salida
                end;
            end;
            
            s = obj.stats;
        end;
        
        % Retorna el siguiente evento a ser procesado, puede ser uno de
        % salida de uno de los hilos o bien un nunevo cliente que llega a
        % la máquina.
        %
        function [e] = getEvent(obj)
            qIdx = -1;
            l = struct('tllegada', inf);
            t = l;

            if (mod(obj.lQueue.size(), 1000) == 0)
                fprintf('Done 1000, remaining: %d/%d. \n', obj.lQueue.size(), length(obj.lQueue.queue));
            end;

            if obj.lQueue.hasNext() 
                l = obj.lQueue.first();
            end;

            if obj.threads.hasNext()
                [t, qIdx] = obj.threads.getEvent();
            end;

            if (l.tllegada < t.tllegada)
                e = obj.lQueue.next();
            else
                obj.threads.moveHead(qIdx);
                obj.stats.collect(obj.threads, t);
                e = t;
            end;
        end
    end;
end

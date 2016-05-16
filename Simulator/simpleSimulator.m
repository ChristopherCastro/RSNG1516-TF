% Simulador básico con un único servidor y múltiples hilos.
%
function [threads,peticiones_rechazadas] = simpleSimulator(nHilos, waitQueueLen, lQueue)
    peticiones_rechazadas = 0;
    threads = Threads(nHilos, waitQueueLen);
    
    while (lQueue.hasNext() || threads.hasNext())
        [e, qIdx] = getEvent(lQueue, threads);
        
        if e.tipo == 'L'
            if ~threads.isServerFull()
                threads.handle(e);
            else
                % No se puede atender -> rechazar
            % ya cambiaremos el nombre de la variable al ingles
                peticiones_rechazadas = peticiones_rechazadas + 1;
            end;
        elseif e.tipo == 'S'
            threads.moveHead(qIdx);
        end;
    end;
end

function [e, qIdx] = getEvent(lQueue, threads)
    qIdx = -1;
    l = struct('tllegada', inf);
    t = l;    
    
    if lQueue.hasNext() 
        l = lQueue.first();
    end;

    if threads.hasNext()
        [t, qIdx] = threads.getEvent();
    end;

    if (l.tllegada < t.tllegada)
        e = lQueue.next();
    else
        threads.moveHead(qIdx);
        e = t;
    end;
end
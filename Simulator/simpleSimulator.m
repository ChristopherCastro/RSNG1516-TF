% Simulador b�sico con un �nico servidor y m�ltiples hilos.
%
function [threads] = simpleSimulator(nHilos, waitQueueLen, lQueue)
    threads = Threads(nHilos, waitQueueLen);
    
    while (lQueue.hasNext() || threads.hasNext())
        [e, qIdx] = getEvent(lQueue, threads);

        if e.tipo == 'L'
            threads.handle(e);
        elseif e.tipo == 'S'
            %threads.moveHead(qIdx);
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
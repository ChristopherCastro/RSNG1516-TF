% Simulador básico con un único servidor y múltiples hilos.
%
function [threads] = simpleSimulator(nHilos, waitQueueLen, lQueue)
    threads = Threads(nHilos, waitQueueLen);
    stats = Stats();
    
    while (lQueue.hasNext() || threads.hasNext())
        [e, qIdx] = getEvent(lQueue, threads);

        if e.tipo == 'L'
            threads.handle(e);
        elseif e.tipo == 'S'
            stats.collect(threads, e);
        end;
    end;
end

function [e, qIdx] = getEvent(lQueue, threads)
    qIdx = -1;
    l = struct('tllegada', inf);
    t = l;

    if (mod(lQueue.size(), 1000) == 0)
        fprintf('Done 1000, remaining: %d/%d. \n', lQueue.size(), length(lQueue.queue));
    end;

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
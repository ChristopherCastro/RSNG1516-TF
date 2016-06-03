% Simulador básico con un único servidor y múltiples hilos.
%
function [stats] = MachineSimulator(nHilos, waitQueueLen, lQueue)
    threads = Threads(nHilos, waitQueueLen);
    stats = StatsCollector();

    while (lQueue.hasNext() || threads.hasNext())
        e = getEvent(lQueue, threads, stats);
        if e.tipo == 'L'
            threads.handle(e);
        elseif e.tipo == 'S'
        end;
    end;
end

function [e] = getEvent(lQueue, threads, stats)
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
        stats.collect(threads, t);
        e = t;
    end;
end
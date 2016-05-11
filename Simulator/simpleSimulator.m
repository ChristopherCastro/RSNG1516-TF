% Simulador básico con un único servidor y múltiples hilos.
%
function [salidaSimulador] = simpleSimulator(nHilos, Qmax, lQueue)
    % nHilos == N
    % Qmax
    % Suponemos que el video está codificado para una velocidad de datos C y que dura un minuto en ser enviado a velocidad C.
    N = nHilos;
    nmax=length(lQueue);
    sQueue = eventsQueue();
    
    while(~lQuenue.isEmpty() || ~sQuenue.isEmpty())
        e = getEvent(lQueue, sQueue);
        if(e.tipo == 'L')
            if ((sQuenue.last - sQuenue.first)< nHilos)
                e.tllegada =  e.tllegada + sQuenue.last.tllegada;
                sQuenue.push(e);
            end
        else
            % tratar peticion
            % avanzamos la posicion del indice sQuenue.first+1
        end
    end

   
end

function e = getEvent(lQueue, sQueue)
    l = struct('tllegada', inf);
    s = l;    
    
    if(~lQuenue.isEmpty() )
        l = lQuenue.first();
    end
    if(~sQuenue.isEmpty() )
        s = lQuenue.first();
    end
    
    if (l.tllegada < s.tllegada)
        e = lQueue.pop();
        
    else
        e = sQueue.pop();
    end    
end
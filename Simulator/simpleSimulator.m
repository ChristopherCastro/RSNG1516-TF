% Simulador básico con un único servidor y múltiples hilos.
%
function [salidaSimulador] = simpleSimulator(nHilos, Qmax, lQueue)
    % nHilos == N
    % Qmax
    % Suponemos que el video está codificado para una velocidad de datos C y que dura un minuto en ser enviado a velocidad C.
    N = nHilos;
    nmax=length(lQueue);
    queues = [lQueue];
    
    for i = 1:nHilos
        queues(end + 1) = eventsQueue();
    end;
    
    while(lQuenue.isEmpty() || ~sQuenue.isEmpty())
        e = getEvent(lQueue, sQueue);
        
        if(e.tipo == 'L')
            if (sQuenue.size() < nHilos)
                e.tipo = 'S';
                e.tllegada =  sQuenue.last().tServidor;
                sQuenue.add(e);
            else
                wQuenue.add(e);
            end
        else if(e.tipo == 'S')
            % tratar peticion
            % e.fServida = 1; 
            % e.tServidor = e.tllegada + e.tservicio;
            sQuenue.next();
            % avanzamos la posicion del indice sQuenue.first+1
        end
    end

   
end

function [e,Q] = getEvent([lQueue sQueues])
    e = lQueue.first();
    Q = 0;
    
    for q = 1:length(sQueues)
        c = sQueues(q).first();
        if c.tllegada < e.tllegada
            e = c;
            Q = q;
        end;
    end;    
end
function [salidas] = generador_2(lambda, t, nmax, seed, M, type)
    % Genera nmax llegadas con tiempos entre llegadas exponenciales y una
    % tasa de lambda llegadas por segundo y tiempos de servicio constantes t
    
    salidas = {};
    for machine=1:M
        salidas{machine}=[];
    end
        
    
    
    emptyEvent = event('L', 0, 0, t, [], [], []);
    events(1:nmax) = emptyEvent;
    arrivals = exprnd(1/lambda, [1 nmax]);

    events(1).idllegada = 1;
    events(1).tllegada = arrivals(1);
    events(1).tEntradaSistema = arrivals(1);

    for i = 2:nmax
        events(i).idllegada = i;
        events(i).tllegada = events(i - 1).tllegada + arrivals(i);
        events(i).tEntradaSistema = events(i).tllegada;
    end;
    
    for i=1:nmax
        if type==0 %Random
            machineID = randi([1 M]);
        elseif type==1 %RR
            machineID = mod(i,M) + 1;
        else %Invalid
            
        end;
        
        machinesEvents = salidas{machineID};
        machinesEvents = [machinesEvents events(i)];
        salidas{machineID}=machinesEvents;
    end
    
end


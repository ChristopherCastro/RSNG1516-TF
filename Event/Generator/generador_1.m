function [salidas] = generador_1(lambda, tmedio, nmax, seed, M,type)
    %Genera nmax llegadas con tiempos entre llegadas exponenciales y una 
    %tasa de lambda llegadas por segundo y tiempos de servicio exponenciales con media tmedio.
    
    salidas = {};
    for machine=1:M
        salidas{machine}=[];
    end
    
    emptyEvent = event('L', 0, 0,0, [], [], []);
    events(1:nmax) = emptyEvent;
    arrivals = exprnd(1/lambda, [1 nmax]);

    events(1).idllegada = 1;
    events(1).tllegada = arrivals(1);
    events(1).tEntradaSistema = arrivals(1);
    events(1).tservicio = exprnd(tmedio);

    for i = 2:length(arrivals)
        events(i).idllegada = i;
        events(i).tllegada = events(i - 1).tllegada + arrivals(i);
        events(i).tEntradaSistema = events(i).tllegada;
        events(i).tservicio = exprnd(tmedio);
    end;
    
     for i=1:nmax
        if type==0 %Random
            machineID = randi([1 M]);
        elseif type==1 %RR
            machineID = mod(i,M) + 1;
        elseif type==2 %Seg�n tama�o, solo para 2 m�quinas
            if events(i).tservicio>tmedio %petici�n pesada
                machineID=1;
            else %petici�n ligera
                machineID=2;
            end
        else %Invalid
            
        end;
        
        machinesEvents = salidas{machineID};
        machinesEvents = [machinesEvents events(i)];
        salidas{machineID}=machinesEvents;
    end
end


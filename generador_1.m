function [events] = generador_1(lambda, tmedio, nmax)
    %Genera nmax llegadas con tiempos entre llegadas exponenciales y una 
    %tasa de lambda llegadas por segundo y tiempos de servicio exponenciales con media tmedio.

    emptyEvent = event('L', 0, 0, 0);
    events(1:nmax) = emptyEvent;
    arrivals = exprnd(lambda, [1 nmax]);

    events(1).idllegada = 1;
    events(1).tllegada = arrivals(1);
    events(1).tservicio = exprnd(tmedio);

    for i = 2:length(arrivals)
        events(i).idllegada = i;
        events(i).tllegada = events(i - 1).tllegada + arrivals(i);
        events(i).tservicio = exprnd(tmedio);
    end;
end


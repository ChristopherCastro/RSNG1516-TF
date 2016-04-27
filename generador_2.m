function [events] = generador_2(lambda, t, nmax)
    % Genera nmax llegadas con tiempos entre llegadas exponenciales y una
    % tasa de lambda llegadas por segundo y tiempos de servicio constantes t
    
    emptyEvent = event('L', 0, 0, t);
    events(1:nmax) = emptyEvent;
    arrivals = exprnd(1/lambda, [1 nmax]);

    events(1).idllegada = 1;
    events(1).tllegada = arrivals(1);

    for i = 2:length(arrivals)
        events(i).idllegada = i;
        events(i).tllegada = events(i - 1).tllegada + arrivals(i);
    end;
end


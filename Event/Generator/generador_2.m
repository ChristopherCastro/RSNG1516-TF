function [events] = generador_2(lambda, t, nmax, seed)
    % Genera nmax llegadas con tiempos entre llegadas exponenciales y una
    % tasa de lambda llegadas por segundo y tiempos de servicio constantes t
    
    if nargin == 4
        rng(seed);
    end
    
    emptyEvent = event('L', 0, 0, t, [], [], []);
    events(1:nmax) = emptyEvent;
    arrivals = exprnd(1/lambda, [1 nmax]);

    events(1).idllegada = 1;
    events(1).tllegada = arrivals(1);
    events(1).tEntradaSistema = arrivals(1);

    for i = 2:length(arrivals)
        events(i).idllegada = i;
        events(i).tllegada = events(i - 1).tllegada + arrivals(i);
        events(i).tEntradaSistema = events(i).tllegada;
    end;
end


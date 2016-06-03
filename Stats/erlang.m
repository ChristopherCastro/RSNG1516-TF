function [] = erlang(nThreads, rho)
    syms ro k i;
    erlangB(ro, k) = (ro^k / factorial(k)) / symsum(ro^i / factorial(i), i, [0 k]);

    nThreads = 0:5:(nThreads + mod(nThreads, 5));
    legends = {};

    figure('Name', 'Erlang-B');
    ylabel('Probabilidad Pn');
    xlabel('Rho');

    if rho <= 1
        rho = 10;
    else
        rho = rho * 1.5;
    end;

    for nIdx = 1:length(nThreads)
        n = nThreads(nIdx);
        hold on;
        plot(erlangB([0:rho], n));
        legends{end + 1} = sprintf('n = %d', n);
    end;

    legend(legends);
end

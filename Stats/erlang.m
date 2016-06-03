% Grafica de Erlang-B, que indica la probabilidad de ser rechazado en
% funci�n del numero de clientes en un instante dado y el n�mero hilos de
% procesamiento disponibles.
%
% Esta funci�n calcula m�ltiples funciones de probabilidad para distintas
% configuraciones de n�mero de hilos. De forma que conocida la
% configuraci�n de un sistema (su n�mero de hilos) se pueda comparar con
% otras configuraciones alternativas con el objetivo de encontraar un valor
% de n�mero de hilos adecuado / �ptimo al problema.
%
% nThreads: N�mero de hilos, recomendable que sea un multiple de 5.
% rho: Factor de utilizaci�n m�xima.
function [] = erlang(nThreads, rho)
    syms ro k ii;
    erlangB(ro, k) = (ro^k / factorial(k)) / symsum(ro^ii / factorial(ii), ii, [0 k]);

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

% Simulador básico con un único servidor y múltiples hilos.
%
function [salidaSimulador] = simpleSimulator(nHilos, Qmax, eventos)
    % nHilos == N
    % Qmax
    % Suponemos que el video está codificado para una velocidad de datos C y que dura un minuto en ser enviado a velocidad C.
    N = nHilos;
    nmax=length(eventos);
    qEventos = [];
    qClientes = []; % cola de clientes atenidos por el servidor
    salidaSimulador = zeros(7,nmax);


    for i=1:nmax
        
        if (strcmp(eventos(i).tipo, 'L'))
            %meter en la cola
            if length(qClientes)<N
                eventos(i).tipo = 'S';
                % modificar tiempos de lledada y de servicio

                qClientes(end+1) = eventos(i);
            end
        elseif (strcmp(eventos(i).tipo, 'S'))
            evento = qClientes(1);
            qClientes(1)=[];
            evento.
        end
        
    end
end


function [salidaSimulador] = simulador(nHilos, Qmax, eventos)
    % nHilos == N
    % Qmax
    % Suponemos que el video está codificado para una velocidad de datos C y que dura un minuto en ser enviado a velocidad C.
    [f,c]=size(eventos);
    for i=1:f
        peticion = eventos(i,:);
        tipo = peticion(1);
        tllegada = peticion(2);
        idllegada = peticion(3);
        tservicio = peticion(4);
        
    end
end

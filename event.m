function [e] = event(tipo, idllegada, tllegada, tservicio, fServida, tServidor, tFin)
	% añadidos argumentos de los eventos de salida pra no tener que crear dos tipos de evento
	% se ha modificado el constructor de generador_1 y generador_2
    if strcmp(tipo, 'L') == 0 && strcmp(tipo, 'S') == 0
        exp = MException('event:WRONG_ARG', 'Invalid type of event, allowed values are: "L" or "S"');
        throw(exp);
    end;
    
    if idllegada < 0 || tllegada < 0 || tservicio < 0
        exp = MException('event:WRONG_ARG', '"idllegada", "tllegada" and "tservicio" must be >= 0');
        throw(exp);
    end;

    e = struct('tipo', tipo, 'idllegada', idllegada, 'tllegada', tllegada, 'tservicio', tservicio, 'fServida', fServida, 'tServidor', tServidor, 'tFin', tFin);

end


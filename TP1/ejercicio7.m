% Modelo Matemático Ejercicio 7:
% - Término general: T_i = (-1)^i / (2*i + 1)  para i = 0, 1, 2, ...
% - Condición de parada: |T_n| = 1/17

1;

function [resultado] = esIgual(calculo)
    if (abs(calculo) == 1/17)
        resultado = true;
    else
        resultado = false;
    endif
endfunction

tic;
i = 0;
calculo = ((-1)^i) / (2*i + 1);

while !esIgual(calculo)
    i = i + 1;
    calculo = ((-1)^i) / (2*i + 1);
endwhile
tiempo = toc;

fprintf("La serie tiene %d términos en total.\n", i + 1);
printf('Tiempo de proceso: %.6f segundos\n', tiempo);
% Modelo Matemático Ejercicio 6 (Serie de Leibniz para Pi):
% Pi se aproxima como el producto de 4 por una serie alternada de impares:
% Pi = 4 * sum_{k=0}^{inf} [ (-1)^k / (2*k + 1) ] = 4 * (1 - 1/3 + 1/5 - 1/7 + 1/9 - ...)
%
% Condición de parada:
% error = |Pi_aproximado - pi| < 10^(-d)

1;

d = input('Ingrese la cantidad de decimales exactos deseada (ej: 3, 4 o 5): ');

if d <= 0
    printf('Error: la cantidad de decimales debe ser mayor a 0.\n');
    return;
endif


tol = 0.5 * 10^(-d);

% Variables iniciales
suma = 0;
k = 0;
pi_aprox = 0;

% Medición de tiempo de ejecución
tic;

% Bucle MIENTRAS el error sea mayor o igual a la tolerancia solicitada
while (abs(pi_aprox - pi) >= tol)
    termino = ((-1)^k) / (2*k + 1);
    suma = suma + termino;
    pi_aprox = 4 * suma;
    k = k + 1;
endwhile

% Tiempo transcurrido
tiempo = toc;

% Impresión formateada de resultados
printf('\n--- Resultados del Ejercicio 6 ---\n');
printf('Decimales exactos solicitados: %d\n', d);
printf('Términos necesarios (k): %d\n', k);
printf('Valor aproximado de Pi: %.8f\n', pi_aprox);
printf('Valor real de Pi (Octave): %.8f\n', pi);
printf('Tiempo de ejecución: %.6f segundos\n', tiempo);

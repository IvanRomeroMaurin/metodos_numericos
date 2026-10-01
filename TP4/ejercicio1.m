% Ejercicio 1: Metodo de Eliminacion de Gauss
clear; clc;
printf('--- Ejercicio 1: Metodo de Eliminacion de Gauss ---\n\n');

% Redondeo a 3 decimales segun pautas de la catedra
redondear = @(x) round(x * 1000) / 1000;

% Carga de la matriz aumentada completa
matriz_aumentada = input('Ingrese la matriz aumentada [A|b]: ');

% Determinacion de la dimension mediante size()
[num_ecuaciones, num_columnas] = size(matriz_aumentada);

printf('\nMatriz aumentada inicial [A|b]:\n');
disp(matriz_aumentada);

tic;

% Eliminacion hacia adelante
for etapa = 1:num_ecuaciones-1
  pivote = matriz_aumentada(etapa, etapa);
  if abs(pivote) < eps
    error('Pivote nulo en la etapa %d', etapa);
  end

  printf('\nEtapa %d (Pivote a_%d%d = %.3f):\n', etapa, etapa, etapa, pivote);

  for fila = etapa+1:num_ecuaciones
    factor_fila = matriz_aumentada(fila, etapa);
    matriz_aumentada(fila, etapa) = 0;
    for columna = etapa+1:num_ecuaciones+1
      % Formula de la catedra: a(i,j) = a(i,j) - (a(i,k) * a(k,j)) / a(k,k)
      termino_reduccion = redondear((factor_fila * matriz_aumentada(etapa, columna)) / pivote);
      matriz_aumentada(fila, columna) = redondear(matriz_aumentada(fila, columna) - termino_reduccion);
    end
  end

  printf('~ Matriz tras la etapa %d:\n', etapa);
  disp(matriz_aumentada);
end

% Sustitucion hacia atras
printf('\nSustitucion hacia atras:\n');
solucion = zeros(num_ecuaciones, 1);

for fila = num_ecuaciones:-1:1
  suma_acumulada = 0;
  for columna = fila+1:num_ecuaciones
    suma_acumulada = redondear(suma_acumulada + redondear(matriz_aumentada(fila, columna) * solucion(columna)));
  end
  solucion(fila) = redondear(redondear(matriz_aumentada(fila, num_ecuaciones+1) - suma_acumulada) / matriz_aumentada(fila, fila));
  printf('x_%d = (%.3f - %.3f) / %.3f = %.3f\n', fila, matriz_aumentada(fila, num_ecuaciones+1), suma_acumulada, matriz_aumentada(fila, fila), solucion(fila));
end

tiempo_proceso = toc;

% Resultados finales
printf('\nSolucion:\n');
for fila = 1:num_ecuaciones
  printf('  x_%d = %.3f\n', fila, solucion(fila));
end

printf('\nTiempo de proceso: %.6f segundos\n', tiempo_proceso);

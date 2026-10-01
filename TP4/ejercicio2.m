% Ejercicio 2: Metodo de Gauss-Jordan
clear; clc;
printf('--- Metodo de Gauss-Jordan ---\n\n');

% Redondeo a 2 decimales segun pautas de la catedra en Gauss-Jordan
redondear = @(x) round(x * 100) / 100;

% Carga de la matriz aumentada completa
matriz_aumentada = input('Ingrese la matriz aumentada [A|b]: ');

% Determinacion de la dimension mediante size()
[num_ecuaciones, num_columnas] = size(matriz_aumentada);

printf('\nMatriz aumentada inicial [A|b]:\n');
disp(matriz_aumentada);

tic;

tabla_actual = matriz_aumentada;

% Reduccion columna a columna segun el metodo de la catedra
for etapa = 1:num_ecuaciones
  pivote = tabla_actual(1, 1);
  if abs(pivote) < eps
    error('Pivote nulo en la etapa %d', etapa);
  end

  printf('\nEtapa %d (Pivote = %.2f):\n', etapa, pivote);

  columnas_actuales = size(tabla_actual, 2);
  tabla_siguiente = zeros(num_ecuaciones, columnas_actuales - 1);

  % Reduccion de las filas restantes
  for fila = 2:num_ecuaciones
    factor_fila = tabla_actual(fila, 1);
    for columna = 2:columnas_actuales
      termino_reduccion = redondear((tabla_actual(1, columna) * factor_fila) / pivote);
      tabla_siguiente(fila - 1, columna - 1) = redondear(tabla_actual(fila, columna) - termino_reduccion);
    end
  end

  % Fila pivote pasa a la ultima posicion dividida por el pivote
  for columna = 2:columnas_actuales
    tabla_siguiente(num_ecuaciones, columna - 1) = redondear(tabla_actual(1, columna) / pivote);
  end

  tabla_actual = tabla_siguiente;
  printf('~ Matriz tras reducir columna %d:\n', etapa);
  disp(tabla_actual);
end

solucion = tabla_actual;
tiempo_proceso = toc;

% Resultados finales
printf('\nSolucion:\n');
for i = 1:num_ecuaciones
  printf('  x_%d = %.2f\n', i, solucion(i));
end

printf('\nTiempo de proceso: %.6f segundos\n', tiempo_proceso);

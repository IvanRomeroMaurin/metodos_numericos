% Ejercicio 2: Metodo de Gauss-Jordan
clear; clc;
printf('--- Metodo de Gauss-Jordan ---\n\n');

% Redondeo a 2 decimales segun pautas de la catedra en Gauss-Jordan
red = @(x) round(x * 100) / 100;

% Carga de la matriz aumentada completa
A = input('Ingrese la matriz aumentada [A|b]: ');

% Determinacion de la dimension mediante size()
[n, m] = size(A);

printf('\nMatriz aumentada inicial [A|b]:\n');
disp(A);

tic;

T = A;

% Reduccion columna a columna segun el metodo de la catedra
for k = 1:n
  pivote = T(1, 1);
  if abs(pivote) < eps
    error('Pivote nulo en la etapa %d', k);
  end

  printf('\nEtapa %d (Pivote = %.2f):\n', k, pivote);

  cols = size(T, 2);
  T_sig = zeros(n, cols - 1);

  % Reduccion de las filas restantes
  for i = 2:n
    factor = T(i, 1);
    for j = 2:cols
      termino = red((T(1, j) * factor) / pivote);
      T_sig(i-1, j-1) = red(T(i, j) - termino);
    end
  end

  % Fila pivote pasa a la ultima posicion dividida por el pivote
  for j = 2:cols
    T_sig(n, j-1) = red(T(1, j) / pivote);
  end

  T = T_sig;
  printf('~ Matriz tras reducir columna %d:\n', k);
  disp(T);
end

x = T;
tiempo = toc;

% Resultados finales
printf('\nSolucion:\n');
for i = 1:n
  printf('  x_%d = %.2f\n', i, x(i));
end
ejer
printf('\nTiempo de proceso: %.6f segundos\n', tiempo);

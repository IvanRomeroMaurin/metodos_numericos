% Ejercicio 1: Metodo de Eliminacion de Gauss
clear; clc;
printf('--- Ejercicio 1: Metodo de Eliminacion de Gauss ---\n\n');

% Redondeo a 3 decimales segun pautas de la catedra
red = @(x) round(x * 1000) / 1000;

% Carga de la matriz aumentada completa
A = input('Ingrese la matriz aumentada [A|b]: ');

% Determinacion de la dimension mediante size()
[n, m] = size(A);

printf('\nMatriz aumentada inicial [A|b]:\n');
disp(A);

tic;

% Eliminacion hacia adelante
for k = 1:n-1
  pivote = A(k, k);
  if abs(pivote) < eps
    error('Pivote nulo en la fila %d', k);
  end

  printf('\nEtapa %d (Pivote a_%d%d = %.3f):\n', k, k, k, pivote);

  for i = k+1:n
    factor = A(i, k);
    A(i, k) = 0;
    for j = k+1:n+1
      % Formula: a(i,j) = a(i,j) - (a(i,k) * a(k,j)) / a(k,k)
      termino = red((factor * A(k, j)) / pivote);
      A(i, j) = red(A(i, j) - termino);
    end
  end

  printf('~ Matriz tras la etapa %d:\n', k);
  disp(A);
end

% Sustitucion hacia atras
printf('\nSustitucion hacia atras:\n');
x = zeros(n, 1);

for i = n:-1:1
  suma = 0;
  for j = i+1:n
    suma = red(suma + red(A(i, j) * x(j)));
  end
  x(i) = red(red(A(i, n+1) - suma) / A(i, i));
  printf('x_%d = (%.3f - %.3f) / %.3f = %.3f\n', i, A(i, n+1), suma, A(i, i), x(i));
end

tiempo = toc;

% Resultados finales
printf('\nSolucion:\n');
for i = 1:n
  printf('  x_%d = %.3f\n', i, x(i));
end

printf('\nTiempo de proceso: %.6f segundos\n', tiempo);

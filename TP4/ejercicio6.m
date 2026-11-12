1; % script con funciones locales

function [coeficientes_polinomio, autovalores, autovectores] = fadeev_leverrier(matriz_A)
  cantidad_incognitas = size(matriz_A, 1);
  coeficientes_polinomio = zeros(1, cantidad_incognitas);
  matriz_B = matriz_A;
  coeficientes_polinomio(1) = -trace(matriz_B);
  for k = 2:cantidad_incognitas
    matriz_B = matriz_A * (matriz_B + coeficientes_polinomio(k-1) * eye(cantidad_incognitas));
    coeficientes_polinomio(k) = -trace(matriz_B) / k;
  end
  autovalores = roots([1, coeficientes_polinomio]);
  autovectores = zeros(cantidad_incognitas, cantidad_incognitas);
  for k = 1:cantidad_incognitas
    espacio_nulo = null(matriz_A - autovalores(k) * eye(cantidad_incognitas), 1e-8);
    vector_propio = espacio_nulo(:, 1);
    [~, indice_mayor] = max(abs(vector_propio));
    autovectores(:, k) = vector_propio / vector_propio(indice_mayor);
  end
end

function [autovalor, autovector, historial] = metodo_potencias(matriz_A, vector_inicial, cantidad_iteraciones)
  % Autovalor dominante y su autovector: y=A*x; lambda=componente de mayor modulo de y; x=y/lambda.
  % historial guarda [iteracion, lambda, x'] en cada fila.
  autovector = vector_inicial(:);
  historial = [];
  for iteracion = 1:cantidad_iteraciones
    vector_y = matriz_A * autovector;
    [~, indice_mayor] = max(abs(vector_y));
    autovalor = vector_y(indice_mayor);
    autovector = vector_y / autovalor;
    historial = [historial; iteracion, autovalor, autovector'];
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 6 (sistemas homogeneos): vibraciones de 3 masas
% a) Arma A*x = lambda*x.  b) Autovalores/autovectores exactos (Fadeev-Leverrier).
% c) Metodo de las potencias para el autovalor maximo, comparando con b).
% ===================================================================
clear; clc;
disp('============================================================');
disp(' EJERCICIO 6 (SISTEMA HOMOGENEO) - VIBRACIONES DE 3 MASAS (METODO DE LAS POTENCIAS)');
disp('============================================================');

matriz_rigidez = input("\nIngrese la matriz de rigidez dividida por k\n(ej: [2 -1 0; -1 2 -1; 0 -1 2]): ");
coeficientes_masa = input('Ingrese los coeficientes de masa (multiplos de m) (ej: [1 2 3]): ');
vector_inicial = input('Ingrese el vector inicial del metodo de las potencias (ej: [1; 1; -0.5]): ');
cantidad_iteraciones = input('Ingrese el numero de iteraciones del metodo de las potencias (ej: 4): ');

matriz_A = diag(1 ./ coeficientes_masa(:)) * matriz_rigidez;
printf('\n>>> a) Sistema a resolver A*x = lambda*x, con A = <<<\n');
disp(matriz_A);

[~, autovalores, autovectores] = fadeev_leverrier(matriz_A);
[autovalores, orden] = sort(real(autovalores), 'descend');
autovectores = autovectores(:, orden);

printf('\n>>> b) Autovalores y autovectores exactos <<<\n');
for k = 1:length(autovalores)
  printf(' -> lambda_%d = %10.6f   v_%d = [%s]\n', k, autovalores(k), k, num2str(autovectores(:, k)', '%8.4f'));
end
printf(' -> Vector propio del autovalor intermedio (lambda_2 = %.6f): [%s]\n', ...
  autovalores(2), num2str(autovectores(:, 2)', '%8.4f'));

printf('\n>>> c) Metodo de las potencias (%d iteraciones) <<<\n', cantidad_iteraciones);
[~, ~, historial] = metodo_potencias(matriz_A, vector_inicial, cantidad_iteraciones);

autovalor_maximo_exacto = autovalores(1);
[~, indice_mayor] = max(abs(autovectores(:, 1)));
autovector_maximo_exacto = autovectores(:, 1) / autovectores(indice_mayor, 1);

printf('\n%4s %14s %10s %10s %10s %14s %12s\n', ...
  'Iter', 'lambda', 'x1', 'x2', 'x3', 'Error L(%)', 'Error x');
for k = 1:cantidad_iteraciones
  lambda_k = historial(k, 2);
  vector_k = historial(k, 3:5)';
  error_lambda = abs(lambda_k - autovalor_maximo_exacto) / abs(autovalor_maximo_exacto) * 100;
  error_vector = norm(vector_k - autovector_maximo_exacto, inf);
  printf('%4d %14.6f %10.6f %10.6f %10.6f %14.2f %12.4e\n', k, lambda_k, vector_k(1), vector_k(2), vector_k(3), error_lambda, error_vector);
end

autovalor_aproximado = historial(end, 2);
autovector_aproximado = historial(end, 3:5)';

printf('\n============================================================\n');
printf(' RESULTADOS FINALES\n');
printf('============================================================\n');
printf(' -> Autovalor maximo exacto      : %.6f\n', autovalor_maximo_exacto);
printf(' -> Autovalor maximo aproximado  : %.6f  (iteracion %d)\n', autovalor_aproximado, cantidad_iteraciones);
printf(' -> Error relativo de lambda     : %.2f %%\n', abs(autovalor_aproximado - autovalor_maximo_exacto) / abs(autovalor_maximo_exacto) * 100);
printf(' -> Vector propio exacto         : [%s]\n', num2str(autovector_maximo_exacto', '%8.4f'));
printf(' -> Vector propio aproximado     : [%s]\n', num2str(autovector_aproximado', '%8.4f'));
printf(' -> Error (norma inf.) del vector: %.4e\n', norm(autovector_aproximado - autovector_maximo_exacto, inf));
printf('============================================================\n');

figure('Name', 'Ejercicio 6 - Metodo de las potencias');
subplot(1, 2, 1);
plot(historial(:, 1), historial(:, 2), '-o', 'LineWidth', 1.5); hold on;
plot(historial(:, 1), autovalor_maximo_exacto * ones(size(historial(:, 1))), '--');
xlabel('Iteracion'); ylabel('lambda aproximado');
legend('Metodo de las potencias', 'Valor exacto', 'Location', 'best');
title('Convergencia del autovalor dominante'); grid on;

subplot(1, 2, 2);
error_historial = abs(historial(:, 2) - autovalor_maximo_exacto) / abs(autovalor_maximo_exacto) * 100;
semilogy(historial(:, 1), error_historial, '-o', 'LineWidth', 1.5);
xlabel('Iteracion'); ylabel('Error relativo (%)');
title('Error de lambda vs iteracion'); grid on;

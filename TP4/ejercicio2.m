1; % script con funciones locales

function es_dominante = verificar_dominancia_diagonal(matriz_coeficientes)
  % Dominancia diagonal: |a_ii| >= suma(|a_ij|, j~=i) para toda fila, con
  % desigualdad estricta en al menos una fila (condicion suficiente de
  % convergencia para Gauss-Seidel, formula 6.26 de la catedra).
  diagonal = abs(diag(matriz_coeficientes));
  resto_fila = sum(abs(matriz_coeficientes), 2) - diagonal;
  hay_alguna_estricta = false;
  es_dominante = true;
  for fila = 1:length(diagonal)
    if diagonal(fila) > resto_fila(fila)
      printf('  Fila %d: |a_%d%d| = %.4g > %.4g  => DOMINANTE (estricta)\n', fila, fila, fila, diagonal(fila), resto_fila(fila));
      hay_alguna_estricta = true;
    elseif diagonal(fila) == resto_fila(fila)
      printf('  Fila %d: |a_%d%d| = %.4g = %.4g  => DOMINANTE (igualdad)\n', fila, fila, fila, diagonal(fila), resto_fila(fila));
    else
      printf('  Fila %d: |a_%d%d| = %.4g < %.4g  => NO DOMINANTE\n', fila, fila, fila, diagonal(fila), resto_fila(fila));
      es_dominante = false;
    end
  end
  es_dominante = es_dominante && hay_alguna_estricta;
end

function [solucion, iteraciones, historial] = gauss_seidel(matriz_coeficientes, vector_b, solucion_inicial, tolerancia, iteraciones_maximas)
  % Metodo iterativo de Gauss-Seidel. Se detiene cuando el error absoluto
  % maximo entre iteraciones, E = max|x_k - x_(k-1)|, es menor que 'tolerancia'.
  % historial guarda [iter, x1..xn, error] en cada fila.
  cantidad_incognitas = length(vector_b);
  solucion = solucion_inicial(:);
  historial = [];

  printf('\n%4s', 'Iter');
  for j = 1:cantidad_incognitas, printf('  %12s', sprintf('x%d', j)); end
  printf('  %12s\n', 'Error');

  for iteraciones = 1:iteraciones_maximas
    solucion_anterior = solucion;
    for fila = 1:cantidad_incognitas
      otras_columnas = [1:fila-1, fila+1:cantidad_incognitas];
      suma = matriz_coeficientes(fila, otras_columnas) * solucion(otras_columnas);
      solucion(fila) = (vector_b(fila) - suma) / matriz_coeficientes(fila, fila);
    end
    error_absoluto = max(abs(solucion - solucion_anterior));
    historial = [historial; iteraciones, solucion', error_absoluto];
    printf('%4d', iteraciones);
    for j = 1:cantidad_incognitas, printf('  %12.6f', solucion(j)); end
    printf('  %12.4e\n', error_absoluto);
    if error_absoluto < tolerancia
      break;
    end
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 2 (sistemas no homogeneos): Metodo de Gauss-Seidel
% Analiza primero la convergencia (dominancia diagonal) y luego itera
% hasta que el error absoluto entre iteraciones sea menor que la tolerancia
% ===================================================================
clear; clc;
disp('============================================================');
disp(' EJERCICIO 2 - METODO DE GAUSS-SEIDEL (SISTEMA NO HOMOGENEO)');
disp('============================================================');

matriz_coeficientes = input("\nIngrese la matriz de coeficientes A\n(ej: [3.0 -0.1 -0.2; 0.1 7.0 -0.3; 0.3 -0.2 -10.3]): ");
vector_terminos_independientes = input('Ingrese el vector de terminos independientes b (ej: [7.85; -19.30; -19.30]): ');
solucion_inicial = input('Ingrese la solucion inicial x0 (ej: [1; 1; 1]): ');
tolerancia_error = input('Ingrese la tolerancia (cota de error absoluto, ej: 1e-3): ');
iteraciones_maximas = input('Ingrese el numero maximo de iteraciones (ej: 50): ');

printf('\n>>> Analisis previo de convergencia <<<\n');
sistema_dominante = verificar_dominancia_diagonal(matriz_coeficientes);
if sistema_dominante
  disp('=> El sistema es diagonalmente dominante: Gauss-Seidel converge para cualquier x0.');
else
  disp('=> El sistema NO es diagonalmente dominante; si no converge, reordene las filas e intente de nuevo.');
end

tic;
[solucion, iteraciones_realizadas, historial_error] = gauss_seidel(matriz_coeficientes, vector_terminos_independientes, solucion_inicial, tolerancia_error, iteraciones_maximas);
tiempo_proceso = toc;

printf('\n============================================================\n');
printf(' RESULTADOS OBTENIDOS\n');
printf('============================================================\n');
for i = 1:length(solucion)
  printf(' -> x_%d = %10.6f\n', i, solucion(i));
end
printf(' -> Iteraciones realizadas : %d\n', iteraciones_realizadas);
printf(' -> Residuo ||A*x - b||inf : %.4e\n', norm(matriz_coeficientes * solucion - vector_terminos_independientes(:), inf));
printf(' -> Tiempo de proceso      : %.6f segundos\n', tiempo_proceso);
printf('============================================================\n');

figure('Name', 'Ejercicio 2 - Convergencia Gauss-Seidel');
semilogy(historial_error(:, 1), historial_error(:, end), '-o', 'LineWidth', 1.5);
hold on;
semilogy(historial_error(:, 1), tolerancia_error * ones(size(historial_error(:, 1))), '--');
xlabel('Iteracion'); ylabel('Error absoluto max|x_k - x_{k-1}|');
title('Convergencia del metodo de Gauss-Seidel');
legend('Error', sprintf('Tolerancia (%.1e)', tolerancia_error));
grid on;

1; % script con funciones locales

function [coeficientes_polinomio, autovalores, autovectores, matrices_B] = fadeev_leverrier(matriz_A)
  % Coeficientes del polinomio caracteristico p(lambda)=lambda^n+c1*lambda^(n-1)+...+cn,
  % sin desarrollar el determinante. Sus raices son los autovalores; cada autovector
  % se obtiene resolviendo (A - lambda_k*I)*x = 0 y normalizando a componente mayor = 1.
  cantidad_incognitas = size(matriz_A, 1);
  coeficientes_polinomio = zeros(1, cantidad_incognitas);
  matriz_B = matriz_A;
  matrices_B = {matriz_B};
  coeficientes_polinomio(1) = -trace(matriz_B);
  for k = 2:cantidad_incognitas
    matriz_B = matriz_A * (matriz_B + coeficientes_polinomio(k-1) * eye(cantidad_incognitas));
    matrices_B{end+1} = matriz_B;
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

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 5 (sistemas homogeneos): Metodo de Fadeev-Leverrier
% Halla el polinomio caracteristico, los autovalores y los autovectores
% ===================================================================
clear; clc;
disp('============================================================');
disp(' EJERCICIO 5 (SISTEMA HOMOGENEO) - METODO DE FADEEV-LEVERRIER');
disp('============================================================');

matriz_A = input("\nIngrese la matriz de coeficientes A del sistema (A - lambda*I)*x = 0\n(ej: [3 2 -1; 1 -2 3; 2 0 4]): ");
cantidad_incognitas = size(matriz_A, 1);

tic;
[coeficientes_polinomio, autovalores, autovectores, matrices_B] = fadeev_leverrier(matriz_A);
tiempo_proceso = toc;

printf('\n>>> Matrices B_k y coeficientes c_k <<<\n');
for k = 1:cantidad_incognitas
  printf('\nMatriz B_%d:\n', k); disp(matrices_B{k});
  printf(' -> Coeficiente c_%d = %.4f\n', k, coeficientes_polinomio(k));
end

printf('\n>>> Polinomio caracteristico <<<\n');
printf('p(lambda) = lambda^%d', cantidad_incognitas);
for k = 1:cantidad_incognitas
  grado = cantidad_incognitas - k;
  if grado > 1
    printf(' %+g*lambda^%d', coeficientes_polinomio(k), grado);
  elseif grado == 1
    printf(' %+g*lambda', coeficientes_polinomio(k));
  else
    printf(' %+g', coeficientes_polinomio(k));
  end
end
printf(' = 0\n');

printf('\n>>> Autovalores y autovectores (normalizados, componente mayor = 1) <<<\n');
for k = 1:cantidad_incognitas
  printf(' -> lambda_%d = %10.6f   v_%d = [%s]\n', k, autovalores(k), k, num2str(autovectores(:, k)', '%8.4f'));
end

printf('\nVerificacion con eig(A):\n'); disp(eig(matriz_A));
printf('Tiempo de proceso: %.6f segundos\n', tiempo_proceso);
printf('============================================================\n');

figure('Name', 'Ejercicio 5 - Fadeev-Leverrier');
stem(real(autovalores), zeros(size(autovalores)), 'filled'); hold on;
plot(real(eig(matriz_A)), zeros(size(eig(matriz_A))), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('lambda'); yticks([]);
title('Autovalores: Fadeev-Leverrier vs eig()');
legend('Fadeev-Leverrier', 'eig() (referencia)');
grid on;

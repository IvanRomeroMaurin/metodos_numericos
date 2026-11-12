1; % script con funciones locales

function [matriz_L, matriz_U] = factorizacion_lu_doolittle(matriz_coeficientes)
  % Factoriza A = L*U (Doolittle: diagonal de L unitaria, sin pivoteo).
  cantidad_incognitas = size(matriz_coeficientes, 1);
  matriz_L = eye(cantidad_incognitas);
  matriz_U = zeros(cantidad_incognitas);
  for k = 1:cantidad_incognitas
    for j = k:cantidad_incognitas
      matriz_U(k, j) = matriz_coeficientes(k, j) - matriz_L(k, 1:k-1) * matriz_U(1:k-1, j);
    end
    for i = k+1:cantidad_incognitas
      matriz_L(i, k) = (matriz_coeficientes(i, k) - matriz_L(i, 1:k-1) * matriz_U(1:k-1, k)) / matriz_U(k, k);
    end
  end
end

function [solucion_x, vector_y] = resolver_sistema_lu(matriz_L, matriz_U, vector_b)
  % Resuelve A*x=b ya factorizada: sustitucion progresiva L*y=b y regresiva U*x=y.
  cantidad_incognitas = length(vector_b);
  vector_b = vector_b(:);
  vector_y = zeros(cantidad_incognitas, 1);
  for i = 1:cantidad_incognitas
    vector_y(i) = vector_b(i) - matriz_L(i, 1:i-1) * vector_y(1:i-1);
  end
  solucion_x = zeros(cantidad_incognitas, 1);
  for i = cantidad_incognitas:-1:1
    solucion_x(i) = (vector_y(i) - matriz_U(i, i+1:cantidad_incognitas) * solucion_x(i+1:cantidad_incognitas)) / matriz_U(i, i);
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 3 (sistemas no homogeneos): Factorizacion LU (metodo de Doolittle)
% ===================================================================
clear; clc;
disp('============================================================');
disp(' EJERCICIO 3 - FACTORIZACION LU (METODO DE DOOLITTLE)');
disp('============================================================');

matriz_coeficientes = input("\nIngrese la matriz de coeficientes A (ej: [2 3 4; 4 5 10; 4 8 2]): ");
vector_terminos_independientes = input('Ingrese el vector de terminos independientes b (ej: [6; 16; 2]): ');

tic;
[matriz_L, matriz_U] = factorizacion_lu_doolittle(matriz_coeficientes);
[solucion_x, vector_y] = resolver_sistema_lu(matriz_L, matriz_U, vector_terminos_independientes);
tiempo_proceso = toc;

printf('\n>>> a) Matrices de la factorizacion A = L*U <<<\n');
disp('Matriz L (triangular inferior, diagonal unitaria):'); disp(matriz_L);
disp('Matriz U (triangular superior):'); disp(matriz_U);
printf('Verificacion ||L*U - A|| = %.4e\n', norm(matriz_L * matriz_U - matriz_coeficientes));

printf('\n>>> b) Resolucion del sistema <<<\n');
disp('Vector y obtenido (sustitucion progresiva L*y = b):'); disp(vector_y);
disp('Solucion final x (sustitucion regresiva U*x = y):'); disp(solucion_x);
printf('Residuo ||A*x - b|| = %.4e\n', norm(matriz_coeficientes * solucion_x - vector_terminos_independientes(:)));
printf('Tiempo de proceso: %.6f segundos\n', tiempo_proceso);
printf('============================================================\n');

figure('Name', 'Ejercicio 3 - Factorizacion LU');
subplot(1, 3, 1); imagesc(matriz_coeficientes); colorbar; axis image; title('Matriz A');
subplot(1, 3, 2); imagesc(matriz_L); colorbar; axis image; title('Matriz L');
subplot(1, 3, 3); imagesc(matriz_U); colorbar; axis image; title('Matriz U');

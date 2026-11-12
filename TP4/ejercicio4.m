1; % script con funciones locales

function solucion_x = eliminacion_gauss(matriz_coeficientes, vector_b)
  cantidad_incognitas = length(vector_b);
  matriz_aumentada = [matriz_coeficientes, vector_b(:)];
  for etapa = 1:cantidad_incognitas-1
    for fila = etapa+1:cantidad_incognitas
      multiplicador = matriz_aumentada(fila, etapa) / matriz_aumentada(etapa, etapa);
      matriz_aumentada(fila, etapa:cantidad_incognitas+1) = matriz_aumentada(fila, etapa:cantidad_incognitas+1) ...
        - multiplicador * matriz_aumentada(etapa, etapa:cantidad_incognitas+1);
    end
  end
  solucion_x = zeros(cantidad_incognitas, 1);
  for fila = cantidad_incognitas:-1:1
    solucion_x(fila) = (matriz_aumentada(fila, cantidad_incognitas+1) ...
      - matriz_aumentada(fila, fila+1:cantidad_incognitas) * solucion_x(fila+1:cantidad_incognitas)) / matriz_aumentada(fila, fila);
  end
end

function solucion_x = gauss_jordan(matriz_coeficientes, vector_b)
  % Metodo de Gauss-Jordan por condensacion (como lo ensena la catedra):
  % en cada etapa se usa la fila 1 como pivote; las filas restantes se
  % reducen y la fila pivote normalizada pasa a la ultima posicion de una
  % tabla con una columna menos. Tras 'cantidad_incognitas' etapas, la
  % columna final es directamente la solucion x1..xn en orden original.
  cantidad_incognitas = length(vector_b);
  tabla_actual = [matriz_coeficientes, vector_b(:)];
  for etapa = 1:cantidad_incognitas
    pivote = tabla_actual(1, 1);
    columnas_actuales = size(tabla_actual, 2);
    tabla_siguiente = zeros(cantidad_incognitas, columnas_actuales - 1);
    for fila = 2:cantidad_incognitas
      factor_fila = tabla_actual(fila, 1);
      for columna = 2:columnas_actuales
        termino_reduccion = (tabla_actual(1, columna) * factor_fila) / pivote;
        tabla_siguiente(fila - 1, columna - 1) = tabla_actual(fila, columna) - termino_reduccion;
      end
    end
    for columna = 2:columnas_actuales
      tabla_siguiente(cantidad_incognitas, columna - 1) = tabla_actual(1, columna) / pivote;
    end
    tabla_actual = tabla_siguiente;
  end
  solucion_x = tabla_actual;
end

function [matriz_L, matriz_U] = factorizacion_lu_doolittle(matriz_coeficientes)
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

function solucion_x = resolver_sistema_lu(matriz_L, matriz_U, vector_b)
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

function [solucion_x, iteraciones] = gauss_seidel(matriz_coeficientes, vector_b, solucion_inicial, tolerancia, iteraciones_maximas)
  % Se detiene cuando el error absoluto maximo entre iteraciones es menor que 'tolerancia'.
  cantidad_incognitas = length(vector_b);
  solucion_x = solucion_inicial(:);
  for iteraciones = 1:iteraciones_maximas
    solucion_anterior = solucion_x;
    for fila = 1:cantidad_incognitas
      otras_columnas = [1:fila-1, fila+1:cantidad_incognitas];
      suma = matriz_coeficientes(fila, otras_columnas) * solucion_x(otras_columnas);
      solucion_x(fila) = (vector_b(fila) - suma) / matriz_coeficientes(fila, fila);
    end
    error_absoluto = max(abs(solucion_x - solucion_anterior));
    if error_absoluto < tolerancia
      break;
    end
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 4 (sistemas no homogeneos): produccion de componentes electronicos
% Compara los cuatro metodos de resolucion ya implementados en los ejercicios 1 a 3
% ===================================================================
clear; clc;
disp('============================================================');
disp(' EJERCICIO 4 - PRODUCCION DE COMPONENTES: COMPARACION DE METODOS');
disp('============================================================');

matriz_coeficientes = input("\nIngrese la matriz de coeficientes A (consumo de material por unidad)\n(ej: [4.3 3 2; 1 3 1; 2 1 3]): ");
vector_disponibilidad = input('Ingrese el vector de disponibilidad de materiales b (ej: [960; 510; 610]): ');
solucion_inicial = input('Ingrese la solucion inicial para Gauss-Seidel (ej: [0; 0; 0]): ');
tolerancia_error = input('Ingrese la tolerancia para Gauss-Seidel (cota de error absoluto, ej: 1e-6): ');

tic; solucion_gauss = eliminacion_gauss(matriz_coeficientes, vector_disponibilidad); tiempo_gauss = toc;
tic; solucion_gauss_jordan = gauss_jordan(matriz_coeficientes, vector_disponibilidad); tiempo_gauss_jordan = toc;
tic; [matriz_L, matriz_U] = factorizacion_lu_doolittle(matriz_coeficientes);
     solucion_lu = resolver_sistema_lu(matriz_L, matriz_U, vector_disponibilidad); tiempo_lu = toc;
tic; [solucion_gauss_seidel, iteraciones_gauss_seidel] = gauss_seidel(matriz_coeficientes, vector_disponibilidad, solucion_inicial, tolerancia_error, 500); tiempo_gauss_seidel = toc;

printf('\n============================================================\n');
printf(' TABLA COMPARATIVA DE METODOS\n');
printf('============================================================\n');
printf('%-22s %10s %10s %10s %12s %10s\n', 'Metodo', 'x1', 'x2', 'x3', 'Residuo', 'Tiempo(s)');
disp('--------------------------------------------------------------------------');
nombres_metodos = {'Eliminacion de Gauss', 'Gauss-Jordan', 'Factorizacion LU', sprintf('Gauss-Seidel (%d it.)', iteraciones_gauss_seidel)};
soluciones = [solucion_gauss(:), solucion_gauss_jordan(:), solucion_lu(:), solucion_gauss_seidel(:)];
tiempos = [tiempo_gauss, tiempo_gauss_jordan, tiempo_lu, tiempo_gauss_seidel];
for k = 1:4
  solucion_k = soluciones(:, k);
  residuo_k = norm(matriz_coeficientes * solucion_k - vector_disponibilidad(:), inf);
  printf('%-22s %10.4f %10.4f %10.4f %12.2e %10.6f\n', nombres_metodos{k}, solucion_k(1), solucion_k(2), solucion_k(3), residuo_k, tiempos(k));
end
printf('============================================================\n');
printf(' -> Produccion semanal sugerida: %.2f transistores, %.2f resistores, %.2f chips\n', ...
  solucion_gauss(1), solucion_gauss(2), solucion_gauss(3));
printf('============================================================\n');

figure('Name', 'Ejercicio 4 - Comparacion de metodos');
bar(soluciones);
set(gca, 'xticklabel', {'x_1', 'x_2', 'x_3'});
legend(nombres_metodos, 'Location', 'best');
ylabel('Cantidad producida'); title('Comparacion de soluciones por metodo');
grid on;

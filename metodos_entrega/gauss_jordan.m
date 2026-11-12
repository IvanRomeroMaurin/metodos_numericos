% =========================================================================
% MÉTODO DE GAUSS-JORDAN POR CONDENSACIÓN
% Métodos Numéricos / Métodos Computacionales
%
% Características:
%   1. Carga del sistema de ecuaciones A*x = b por teclado (tamaño n x n).
%   2. Validación de las condiciones de aplicabilidad del método.
%   3. Resolución mediante el método de condensación (reduce una columna
%      por etapa, conservando n filas) tal como lo enseña la cátedra.
%   4. Tabla detallada de cada etapa de la condensación.
%   5. Verificación contra la solución de referencia de Octave.
%   6. Gráfica comparativa de la solución obtenida.
% =========================================================================

1; % Declaración de script en GNU Octave

% -------------------------------------------------------------------------
% 1. Validación de las condiciones de aplicabilidad del método
% -------------------------------------------------------------------------
function cumple = validar_condiciones(matriz_A, vector_b)
    [filas, columnas] = size(matriz_A);
    n = length(vector_b);

    printf('\n=================================================================\n');
    printf('        VALIDACIÓN DE LAS CONDICIONES DEL MÉTODO                 \n');
    printf('=================================================================\n');

    c1_cuadrada = (filas == columnas);
    printf('1. La matriz de coeficientes debe ser cuadrada (n x n)\n');
    printf('   Dimensiones de A: %d x %d\n', filas, columnas);
    if c1_cuadrada
        printf('   [CUMPLE] La matriz es cuadrada.\n');
    else
        printf('   [NO CUMPLE] La matriz no es cuadrada: el metodo no es aplicable.\n');
    end

    c2_tamanios = (filas == n);
    printf('\n2. La cantidad de incognitas debe coincidir con la cantidad de\n');
    printf('   terminos independientes\n');
    printf('   Filas de A = %d   |   Elementos de b = %d\n', filas, n);
    if c2_tamanios
        printf('   [CUMPLE] Los tamanios coinciden.\n');
    else
        printf('   [NO CUMPLE] Los tamanios no coinciden.\n');
    end

    c3_determinante = false;
    if c1_cuadrada
        determinante = det(matriz_A);
        printf('\n3. El sistema debe tener solucion unica: det(A) != 0\n');
        printf('   det(A) = %.6g\n', determinante);
        c3_determinante = (abs(determinante) > 1e-10);
        if c3_determinante
            printf('   [CUMPLE] La matriz no es singular: la solucion es unica.\n');
        else
            printf('   [NO CUMPLE] La matriz es singular (o casi singular): no hay solucion unica.\n');
        end
    else
        printf('\n3. El sistema debe tener solucion unica: det(A) != 0\n');
        printf('   [OMITIDO] No se puede calcular el determinante de una matriz no cuadrada.\n');
    end

    cumple = c1_cuadrada && c2_tamanios && c3_determinante;
    printf('=================================================================\n');
end

% -------------------------------------------------------------------------
% 2. Método de Gauss-Jordan por condensación
% -------------------------------------------------------------------------
function solucion_x = resolver_gauss_jordan(matriz_A, vector_b)
    % En cada etapa se usa la fila 1 como pivote: las filas restantes se
    % reducen y la fila pivote normalizada pasa a la ultima posicion de
    % una tabla con una columna menos. Tras 'n' etapas, la columna final
    % es directamente la solucion x1..xn en su orden original.
    n = length(vector_b);
    tabla_actual = [matriz_A, vector_b(:)];

    printf('\n=================================================================\n');
    printf('              ETAPAS DE LA CONDENSACION                           \n');
    printf('=================================================================\n');

    for etapa = 1:n
        pivote = tabla_actual(1, 1);
        if abs(pivote) < 1e-12
            error('Gauss-Jordan: el pivote de la etapa %d es nulo. Reordene las filas.', etapa);
        end
        columnas_actuales = size(tabla_actual, 2);
        tabla_siguiente = zeros(n, columnas_actuales - 1);

        for fila = 2:n
            factor_fila = tabla_actual(fila, 1);
            for columna = 2:columnas_actuales
                termino_reduccion = (tabla_actual(1, columna) * factor_fila) / pivote;
                tabla_siguiente(fila - 1, columna - 1) = tabla_actual(fila, columna) - termino_reduccion;
            end
        end
        for columna = 2:columnas_actuales
            tabla_siguiente(n, columna - 1) = tabla_actual(1, columna) / pivote;
        end

        printf('\n-- Etapa %d (pivote a_11 = %.6g) --\n', etapa, pivote);
        printf('Tabla antes de condensar:\n');
        disp(tabla_actual);
        printf('Tabla despues de condensar (queda con %d columnas):\n', columnas_actuales - 1);
        disp(tabla_siguiente);

        tabla_actual = tabla_siguiente;
    end
    solucion_x = tabla_actual;
end

% =========================================================================
% PROGRAMA PRINCIPAL
% =========================================================================
clc;
printf('=================================================================\n');
printf('            METODO DE GAUSS-JORDAN (POR CONDENSACION)             \n');
printf('=================================================================\n\n');

printf('Ejemplo practico (produccion de componentes electronicos, TP4):\n');
printf('  Una companhia produce transistores, resistores y chips. Cada uno\n');
printf('  consume cobre, zinc y vidrio segun la tabla de coeficientes A, y\n');
printf('  se dispone de b unidades de cada material por semana.\n');
printf('  A = [4.3 3 2; 1 3 1; 2 1 3]   b = [960; 510; 610]\n\n');

matriz_A = input('Ingrese la matriz de coeficientes A (ej: [4.3 3 2; 1 3 1; 2 1 3]): ');
vector_b = input('Ingrese el vector de terminos independientes b (ej: [960; 510; 610]): ');

if ~validar_condiciones(matriz_A, vector_b)
    error('No se cumplen las condiciones necesarias para aplicar el metodo de Gauss-Jordan.');
end

tic;
solucion_gauss_jordan = resolver_gauss_jordan(matriz_A, vector_b);
tiempo_computo = toc;

solucion_referencia = matriz_A \ vector_b(:);

printf('\n=================================================================\n');
printf('                      RESULTADOS FINALES                          \n');
printf('=================================================================\n');
printf('%-6s %16s %18s %14s\n', 'x_i', 'Gauss-Jordan', 'Referencia Octave', 'Error abs.');
printf('-----------------------------------------------------------------\n');
for i = 1:length(vector_b)
    printf('x_%-4d %16.6f %18.6f %14.4e\n', i, solucion_gauss_jordan(i), solucion_referencia(i), ...
        abs(solucion_gauss_jordan(i) - solucion_referencia(i)));
end
printf('-----------------------------------------------------------------\n');
printf('Residuo ||A*x - b||inf : %.4e\n', norm(matriz_A * solucion_gauss_jordan(:) - vector_b(:), inf));
printf('Tiempo de computo       : %.6f segundos\n', tiempo_computo);
printf('=================================================================\n');

% Grafico comparativo
figure('Name', 'Gauss-Jordan: solucion obtenida');
bar([solucion_gauss_jordan(:), solucion_referencia(:)]);
etiquetas = cell(1, length(vector_b));
for i = 1:length(vector_b)
    etiquetas{i} = sprintf('x_%d', i);
end
set(gca, 'xticklabel', etiquetas);
legend('Gauss-Jordan', 'Referencia Octave', 'Location', 'best');
ylabel('Valor');
title('Solucion por Gauss-Jordan vs. solucion de referencia');
grid on;

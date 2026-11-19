% =========================================================================
% MÉTODO DE GAUSS-JORDAN
% Métodos Numéricos / Métodos Computacionales
%
% Características:
%   1. Carga del sistema de ecuaciones A*x = b por teclado (tamaño n x n).
%   2. Validación de las condiciones de aplicabilidad del método.
%   3. Resolución mediante el método de condensación (reduce una columna
%      por etapa, conservando n filas) tal como lo enseña la cátedra.
%   4. Tabla detallada de cada etapa de la condensación.
%   5. Verificación de la solución reemplazando en el sistema (A*x vs b).
% =========================================================================
%
% ENUNCIADO (ejemplo práctico usado en este archivo):
%
% Una compañía electrónica produce transistores, resistores y chips de
% computadora. Cada transistor requiere 4,3 unidades de cobre, 1 unidad de
% zinc y 2 unidades de vidrio. Cada resistor requiere 3 unidades de cobre,
% 3 unidades de zinc y 1 unidad de vidrio. Cada chip de computadora
% requiere 2 unidades de cobre, 1 unidad de zinc y 3 unidades de vidrio.
%
% Los suministros de estos materiales varían de una semana a la otra, por
% lo que la compañía necesita recalcular su producción cada vez. Cierta
% semana cuenta con 960 unidades de cobre, 510 unidades de zinc y 610
% unidades de vidrio disponibles.
%
% ¿Cuántos transistores, resistores y chips de computadora debe producir
% la compañía esa semana, de modo que consuma exactamente la totalidad de
% los materiales disponibles, sin que sobre ni falte ninguno? Plantee el
% sistema de ecuaciones correspondiente y resuélvalo aplicando el método
% de Gauss-Jordan.
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
% 2. Método de Gauss-Jordan 
% -------------------------------------------------------------------------
function [solucion_x, cantidad_intercambios] = resolver_gauss_jordan(matriz_A, vector_b)
    % En cada etapa se usa la fila 1 como pivote: las filas restantes se
    % reducen y la fila pivote normalizada pasa a la ultima posicion de
    % una tabla con una columna menos. Tras 'n' etapas, la columna final
    % es directamente la solucion x1..xn en su orden original.
    n = length(vector_b);
    tabla_actual = [matriz_A, vector_b(:)];   % matriz ampliada [A | b]
    cantidad_intercambios = 0;                % contador de intercambios de filas

    printf('\n=================================================================\n');
    printf('              ETAPAS DE LA CONDENSACION                           \n');
    printf('=================================================================\n');
    printf('\nTabla inicial [A | b]:\n');
    disp(tabla_actual);

    for etapa = 1:n
        % Pivoteo parcial: se busca la fila con mayor |valor| en la primera columna,
        % solo entre las filas no usadas como pivote (las ultimas etapa-1 ya lo fueron)
        filas_candidatas = n - etapa + 1;
        [~, fila_max] = max(abs(tabla_actual(1:filas_candidatas, 1)));
        if fila_max ~= 1
            % Se intercambia esa fila con la fila 1 (no altera la solucion)
            tabla_actual([1, fila_max], :) = tabla_actual([fila_max, 1], :);
            cantidad_intercambios = cantidad_intercambios + 1;
            printf('\n   Intercambio en etapa %d: fila 1 <-> fila %d\n', etapa, fila_max);
        end

        % Pivote de la etapa: elemento a_11 de la tabla actual
        pivote = tabla_actual(1, 1);
        if abs(pivote) < 1e-12
            error('Gauss-Jordan: el pivote de la etapa %d es nulo aun tras intercambiar filas.', etapa);
        end

        % La nueva tabla tiene una columna menos (se elimina la incognita actual)
        columnas_actuales = size(tabla_actual, 2);
        tabla_siguiente = zeros(n, columnas_actuales - 1);

        % Reduccion de las filas 2..n: a_ij - (a_1j * a_i1) / pivote
        for fila = 2:n
            factor_fila = tabla_actual(fila, 1);
            for columna = 2:columnas_actuales
                termino_reduccion = (tabla_actual(1, columna) * factor_fila) / pivote;
                tabla_siguiente(fila - 1, columna - 1) = tabla_actual(fila, columna) - termino_reduccion;
            end
        end
        % La fila pivote, dividida por el pivote, pasa a la ultima fila
        for columna = 2:columnas_actuales
            tabla_siguiente(n, columna - 1) = tabla_actual(1, columna) / pivote;
        end

        printf('\n-- Etapa %d (pivote a_11 = %.6g) --\n', etapa, pivote);
        disp(tabla_siguiente);

        % La tabla condensada pasa a ser la tabla de la proxima etapa
        tabla_actual = tabla_siguiente;
    end
    % Al terminar queda una sola columna: la solucion x1..xn
    solucion_x = tabla_actual;
end

% =========================================================================
% PROGRAMA PRINCIPAL
% =========================================================================
printf('=================================================================\n');
printf('                METODO DE GAUSS-JORDAN                             \n');
printf('=================================================================\n\n');

printf('Ejemplo practico (produccion de componentes electronicos, TP4):\n');
printf('  Una compania produce transistores, resistores y chips. Cada uno\n');
printf('  consume cobre, zinc y vidrio segun la tabla de coeficientes A, y\n');
printf('  se dispone de b unidades de cada material por semana.\n');
printf('  A = [4.3 3 2; 1 3 1; 2 1 3]   b = [960; 510; 610]\n\n');

% Valores por defecto (ejemplo del enunciado): se usan si se presiona Enter
A_defecto = [4.3 3 2; 1 3 1; 2 1 3];
b_defecto = [960; 510; 610];

matriz_A = input('Ingrese la matriz de coeficientes A (Enter = [4.3 3 2; 1 3 1; 2 1 3]): ');
if isempty(matriz_A)
    matriz_A = A_defecto;
    printf('  -> Se usa A por defecto.\n');
end
vector_b = input('Ingrese el vector de terminos independientes b (Enter = [960; 510; 610]): ');
if isempty(vector_b)
    vector_b = b_defecto;
    printf('  -> Se usa b por defecto.\n');
end

if ~validar_condiciones(matriz_A, vector_b)
    error('No se cumplen las condiciones necesarias para aplicar el metodo de Gauss-Jordan.');
end

% Resolucion del sistema midiendo el tiempo de computo
tic;
[solucion_gauss_jordan, cantidad_intercambios] = resolver_gauss_jordan(matriz_A, vector_b);
tiempo_computo = toc;

printf('\n=================================================================\n');
printf('                      RESULTADOS FINALES                          \n');
printf('=================================================================\n');
printf('Solucion obtenida:\n');
for i = 1:length(vector_b)
    printf('  x_%d = %.6f\n', i, solucion_gauss_jordan(i));
end

% Verificacion: se reemplaza la solucion en el sistema y se compara A*x con b
producto_Ax = matriz_A * solucion_gauss_jordan(:);
error_abs = abs(producto_Ax - vector_b(:));

printf('\n=================================================================\n');
printf('              VERIFICACION: A*x CONTRA b                          \n');
printf('=================================================================\n');
printf('%-8s %16s %16s %14s\n', 'Ecuacion', '(A*x)_i', 'b_i', 'Error abs.');
printf('-----------------------------------------------------------------\n');
for i = 1:length(vector_b)
    printf('%-8d %16.6f %16.6f %14.4e\n', i, producto_Ax(i), vector_b(i), error_abs(i));
end
printf('-----------------------------------------------------------------\n');
printf('Error maximo (mayor |A*x - b|) : %.4e\n', max(error_abs));
% Informe de intercambios de filas realizados durante la condensacion
if cantidad_intercambios > 0
    printf('Intercambios de filas          : %d (se reordenaron filas para poder calcular)\n', cantidad_intercambios);
else
    printf('Intercambios de filas          : ninguno\n');
end
printf('Tiempo de computo              : %.6f segundos\n', tiempo_computo);
printf('=================================================================\n');

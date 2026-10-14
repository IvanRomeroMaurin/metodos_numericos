% =========================================================================
% MÉTODO DE NEWTON-RAPHSON CON TANTEO Y VALIDACIÓN DE CONDICIONES DE FOURIER
% Métodos Numéricos / Métodos Computacionales
%
% Características:
%   1. Carga de la función f(x) por teclado de forma interactiva.
%   2. Cálculo automático de derivadas (df(x) y d2f(x)) por diferencias
%      finitas de alta precisión (orden O(h^4)), sin requerir ingreso manual.
%   3. Separación de raíces por Método de Tanteo (búsqueda incremental).
%   4. Gráfica interactiva de la función con fplot y eje horizontal f(x) = 0.
%   5. Validación de las condiciones suficientes de convergencia de Fourier.
%   6. Elección óptima del punto inicial x0 según Fourier (f(x0)*d2f(x0) > 0).
%   7. Ejecución del método de Newton-Raphson con tabla prolija de iteraciones.
%   8. Marcado visual de las raíces halladas sobre la gráfica.
%   9. Soporte para calcular todas las raíces detectadas en el tanteo.
% =========================================================================

1; % Declaración de script en GNU Octave

% -------------------------------------------------------------------------
% 1. Funciones auxiliares para derivadas numéricas de alta precisión
% -------------------------------------------------------------------------

function d1 = deriv_primera(f, x)
    % Derivada primera por diferencias finitas centradas de 5 puntos: O(h^4)
    h = 1e-4 * max(1.0, abs(x));
    d1 = (-f(x + 2*h) + 8*f(x + h) - 8*f(x - h) + f(x - 2*h)) / (12 * h);
end

function d2 = deriv_segunda(f, x)
    % Derivada segunda por diferencias finitas centradas de 5 puntos: O(h^4)
    h = 1e-3 * max(1.0, abs(x));
    d2 = (-f(x + 2*h) + 16*f(x + h) - 30*f(x) + 16*f(x - h) - f(x - 2*h)) / (12 * (h^2));
end

% -------------------------------------------------------------------------
% 2. Graficador de función (estilo ejercicio 2 del TP3)
% -------------------------------------------------------------------------

function graficar_funcion(f, a, b, f_str, raices)
    % Grafica f(x) en [a, b] con fplot, la recta f(x) = 0 y, si se pasan,
    % las raíces calculadas marcadas en rojo con su valor.
    if nargin < 5
        raices = [];
    end
    raices = raices(isfinite(raices));

    try
        figure(1);
        clf;
        fplot(f, [a, b], 'b-', 'LineWidth', 2);
        h_f = findobj(gca, 'Type', 'line');
        hold on; grid on;
        h_eje = line([a, b], [0, 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
        xlabel('x');
        ylabel('f(x)');
        title(['f(x) = ' f_str]);

        % Límites en y robustos: ignora valores no finitos y recorta los
        % picos de asíntotas (ej. 1/x) para que el cruce con el eje se vea
        y = sort(f(linspace(a, b, 500)));
        y = y(isfinite(y));
        if ~isempty(y)
            n = numel(y);
            y_min = min(y(max(1, round(0.02 * n))), 0);
            y_max = max(y(max(1, round(0.98 * n))), 0);
            margen = 0.1 * max(y_max - y_min, eps);
            ylim([y_min - margen, y_max + margen]);
        end
        xlim([a, b]);

        if isempty(raices)
            legend([h_f, h_eje], {'f(x)', 'f(x) = 0'}, 'Location', 'northeastoutside');
        else
            h_r = plot(raices, f(raices), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
            for k = 1:numel(raices)
                text(raices(k), 0, sprintf('  x%d = %.4f', k, raices(k)), ...
                     'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
            end
            legend([h_f, h_eje, h_r], {'f(x)', 'f(x) = 0', 'Raíces'}, 'Location', 'northeastoutside');
        end
        hold off;
        drawnow;
    catch err
        printf('No se pudo generar la gráfica: %s\n', err.message);
    end
end

% -------------------------------------------------------------------------
% 3. Método de Tanteo (Búsqueda Incremental)
% -------------------------------------------------------------------------

function intervalos = ejecutar_tanteo(f, a, b, paso)
    % Recorre [a, b] con paso delta x identificando cambios de signo
    intervalos = [];
    x_actual = a;
    f_actual = f(x_actual);

    printf('\n-------------------------------------------------------------\n');
    printf('                TABLA DEL MÉTODO DE TANTEO                   \n');
    printf('-------------------------------------------------------------\n');
    printf('%-14s | %-16s | %-16s\n', 'x_i', 'f(x_i)', 'Cambio Signo');
    printf('%s\n', repmat('-', 1, 52));
    printf('%14.6f | %16.6e | %-16s\n', x_actual, f_actual, '-');

    while x_actual < b
        x_sig = min(x_actual + paso, b);
        f_sig = f(x_sig);

        hay_cambio = (f_actual * f_sig <= 0);

        if hay_cambio
            marca = 'SI (Raiz)';
            intervalos = [intervalos; x_actual, x_sig];
        else
            marca = 'NO';
        end

        printf('%14.6f | %16.6e | %-16s\n', x_sig, f_sig, marca);

        x_actual = x_sig;
        f_actual = f_sig;
    end
    printf('%s\n', repmat('-', 1, 52));
end

% -------------------------------------------------------------------------
% 4. Validación de Condiciones de Convergencia de Fourier
% -------------------------------------------------------------------------

function [cumple, x0_fourier] = validar_fourier(f, a, b)
    % Evalúa las 4 condiciones de Fourier para Newton-Raphson en [a, b]:
    % 1. Existencia: f(a)*f(b) <= 0
    % 2. Monotonía: df(x) != 0 y no cambia de signo en [a, b]
    % 3. Concavidad: d2f(x) != 0 y no cambia de signo en [a, b]
    % 4. Elección de x0 tal que f(x0)*d2f(x0) > 0

    fa = f(a);
    fb = f(b);
    dfa = deriv_primera(f, a);
    dfb = deriv_primera(f, b);
    d2fa = deriv_segunda(f, a);
    d2fb = deriv_segunda(f, b);

    % Muestreo interno en 60 puntos para verificar signo constante
    puntos_test = linspace(a, b, 60);
    df_vals = zeros(1, length(puntos_test));
    d2f_vals = zeros(1, length(puntos_test));
    for i = 1:length(puntos_test)
        df_vals(i)  = deriv_primera(f, puntos_test(i));
        d2f_vals(i) = deriv_segunda(f, puntos_test(i));
    end

    c1_bolzano    = (fa * fb <= 0);
    c2_monotonia  = (all(df_vals > 0) || all(df_vals < 0)) && all(abs(df_vals) > 1e-12);
    c3_concavidad = (all(d2f_vals > 0) || all(d2f_vals < 0)) && all(abs(d2f_vals) > 1e-12);

    prod_a = fa * d2fa;
    prod_b = fb * d2fb;

    if prod_a > 0
        x0_fourier = a;
        c4_x0 = true;
    elseif prod_b > 0
        x0_fourier = b;
        c4_x0 = true;
    else
        % Si ninguno es estrictamente mayor que cero, se toma el de mayor producto o punto medio
        if prod_a >= prod_b
            x0_fourier = a;
        else
            x0_fourier = b;
        end
        c4_x0 = false;
    end

    cumple = c1_bolzano && c2_monotonia && c3_concavidad && c4_x0;

    printf('\n=============================================================\n');
    printf('     VALIDACIÓN DE CONDICIONES DE FOURIER EN [%.4f, %.4f]   \n', a, b);
    printf('=============================================================\n');

    % Condición 1
    printf('1. Existencia de raíz (Bolzano): f(a) * f(b) <= 0\n');
    printf('   f(%.4f) = %12.5e  |  f(%.4f) = %12.5e\n', a, fa, b, fb);
    if c1_bolzano
        printf('   [CUMPLE] Hay al menos una raíz en el intervalo.\n');
    else
        printf('   [NO CUMPLE] No se detecta cambio de signo en los extremos.\n');
    end

    % Condición 2
    printf('\n2. Monotonía estricta: df(x) != 0 y no cambia de signo en [a, b]\n');
    printf('   df(a) = %12.5e  |  df(b) = %12.5e\n', dfa, dfb);
    if c2_monotonia
        printf('   [CUMPLE] La derivada primera conserva el signo (función monótona).\n');
    else
        printf('   [ADVERTENCIA] df(x) cambia de signo o se anula (puede haber extremo local).\n');
    end

    % Condición 3
    printf('\n3. Concavidad estricta: d2f(x) != 0 y no cambia de signo en [a, b]\n');
    printf('   d2f(a) = %12.5e  |  d2f(b) = %12.5e\n', d2fa, d2fb);
    if c3_concavidad
        printf('   [CUMPLE] La concavidad no cambia (no hay punto de inflexión).\n');
    else
        printf('   [ADVERTENCIA] d2f(x) cambia de signo o se anula en el intervalo.\n');
    end

    % Condición 4
    printf('\n4. Criterio de Fourier para el valor inicial x0: f(x0) * d2f(x0) > 0\n');
    printf('   Extremo a = %10.4f -> f(a)*d2f(a) = %12.5e\n', a, prod_a);
    printf('   Extremo b = %10.4f -> f(b)*d2f(b) = %12.5e\n', b, prod_b);
    printf('   -> Punto de arranque recomendado por Fourier: x0 = %.6f\n', x0_fourier);

    if cumple
        printf('\n=> CONCLUSIÓN: SE CUMPLEN TODAS LAS CONDICIONES DE FOURIER.\n');
        printf('   La convergencia monótona hacia la raíz está teóricamente garantizada.\n');
    else
        printf('\n=> ADVERTENCIA: Alguna condición no se cumple de forma estricta.\n');
        printf('   El método puede converger igualmente, pero requiere atención al punto de partida.\n');
    end
    printf('=============================================================\n');
end

% -------------------------------------------------------------------------
% 5. Algoritmo de Newton-Raphson
% -------------------------------------------------------------------------

function [raiz, iter, tabla] = ejecutar_newton_raphson(f, x0, tol, max_iter)
    printf('\n-------------------------------------------------------------\n');
    printf('            ITERACIONES DEL MÉTODO DE NEWTON-RAPHSON          \n');
    printf('-------------------------------------------------------------\n');
    printf('Punto inicial x0 = %.8f  |  Tolerancia = %.2e\n', x0, tol);
    printf('%s\n', repmat('-', 1, 68));
    printf('%-4s | %-14s | %-14s | %-14s | %-12s\n', ...
           'k', 'x_k', 'f(x_k)', 'df(x_k)', 'Error |dx|');
    printf('%s\n', repmat('-', 1, 68));

    x = x0;
    tabla = [];

    for k = 1:max_iter
        fx = f(x);
        dfx = deriv_primera(f, x);

        if abs(dfx) < 1e-14
            error('Newton-Raphson: Derivada prácticamente nula en x = %.8f. División por cero.', x);
        end

        x_sig = x - (fx / dfx);
        error_paso = abs(x_sig - x);

        % Criterio de parada
        if error_paso < tol || abs(fx) < tol
            printf('%4d | %14.8f | %14.6e | %14.6e | %12.6e  (Fin)\n', ...
                   k - 1, x, fx, dfx, error_paso);
            tabla = [tabla; k - 1, x, fx, dfx, error_paso];
            raiz = x_sig;
            iter = k;
            printf('%s\n', repmat('-', 1, 68));
            return;
        else
            printf('%4d | %14.8f | %14.6e | %14.6e | %12.6e\n', ...
                   k - 1, x, fx, dfx, error_paso);
            tabla = [tabla; k - 1, x, fx, dfx, error_paso];
        end

        x = x_sig;
    end

    raiz = x;
    iter = max_iter;
    printf('%s\n', repmat('-', 1, 68));
    warning('Se alcanzó el número máximo de iteraciones permitidas (%d).', max_iter);
end

% =========================================================================
% FLUJO PRINCIPAL DEL PROGRAMA INTERACTIVO
% =========================================================================

clc;
printf('=================================================================\n');
printf('             MÉTODO DE NEWTON-RAPHSON INTERACTIVO                \n');
printf('   Con Tanteo Previo, Gráfica y Validación de Fourier            \n');
printf('=================================================================\n\n');

% -------------------------------------------------------------------------
% PASO 1: Ingreso de la función f(x)
% -------------------------------------------------------------------------
printf('Ingrese la función f(x) en términos de x.\n');
printf('Ejemplos:\n');
printf('  - 8*x + 0.3*x^2 - 0.0013*x^3 - 372\n');
printf('  - sin(x) - 0.5*x\n');
printf('  - exp(-x) - x\n\n');

funcion_valida = false;
while ~funcion_valida
    f_str = input('f(x) = ', 's');
    if isempty(strtrim(f_str))
        printf('Error: La función no puede estar vacía. Intente nuevamente.\n');
        continue;
    end

    try
        % Creamos un handle anónimo que evalúe elemento a elemento de forma segura
        f_raw = str2func(['@(x) ' f_str]);
        f = @(x) arrayfun(f_raw, x);

        % Prueba de evaluación en un punto
        test_val = f(1.0);
        if isnan(test_val) || isinf(test_val)
            % Intento en cero si 1.0 da problema
            test_val = f(0.0);
        end
        funcion_valida = true;
        printf('-> Función f(x) cargada y validada correctamente.\n\n');
    catch err
        printf('Error al interpretar la expresión: %s\n', err.message);
        printf('Verifique la sintaxis matemática e intente de nuevo.\n\n');
    end
end

% -------------------------------------------------------------------------
% PASO 2: Método de Tanteo (Separación de raíces)
% -------------------------------------------------------------------------
printf('-----------------------------------------------------------------\n');
printf('                     MÉTODO DE TANTEOS                           \n');
printf('-----------------------------------------------------------------\n');

tanteo_completado = false;
while ~tanteo_completado
    a_tanteo = input('Ingrese el límite inferior del intervalo a: ');
    b_tanteo = input('Ingrese el límite superior del intervalo b: ');

    if b_tanteo <= a_tanteo
        printf('Error: El límite superior b debe ser mayor que el límite inferior a.\n');
        continue;
    end

    paso_tanteo = input('Ingrese el paso / incremento delta x (ej. 1, 5, 50): ');
    if paso_tanteo <= 0
        printf('Error: El paso debe ser un número positivo mayor a cero.\n');
        continue;
    end

    intervalos = ejecutar_tanteo(f, a_tanteo, b_tanteo, paso_tanteo);

    if isempty(intervalos)
        printf('\n[!] No se encontraron cambios de signo en [%.4f, %.4f] con paso %.4f.\n', ...
               a_tanteo, b_tanteo, paso_tanteo);
        reintentar = input('¿Desea probar con otro intervalo o paso más fino? (1 = Sí, 0 = Salir): ');
        if reintentar ~= 1
            printf('\nFinalizando el programa.\n');
            return;
        end
    else
        tanteo_completado = true;
    end
end

num_raices = size(intervalos, 1);
printf('\n-> Se encontraron %d intervalo(s) con cambio de signo:\n', num_raices);
for i = 1:num_raices
    printf('   Raíz %d: [%.4f, %.4f]\n', i, intervalos(i, 1), intervalos(i, 2));
end

% -------------------------------------------------------------------------
% PASO 3: Gráfica inicial de la función con fplot (Estilo Ejercicio 2)
% -------------------------------------------------------------------------
printf('\n-> Generando gráfica de f(x) en el intervalo [%.2f, %.2f]...\n', a_tanteo, b_tanteo);
graficar_funcion(f, a_tanteo, b_tanteo, f_str);

% -------------------------------------------------------------------------
% PASO 4: Parámetros del Método de Newton-Raphson
% -------------------------------------------------------------------------
printf('\n-----------------------------------------------------------------\n');
printf('              PARÁMETROS DE NEWTON-RAPHSON                       \n');
printf('-----------------------------------------------------------------\n');

tol = 0;
while tol <= 0
    tol = input('Ingrese la cota de error / tolerancia (ej. 1e-4 o 0.0001): ');
    if tol <= 0
        printf('Error: La tolerancia debe ser un número positivo mayor que cero.\n');
    end
end

max_iter = 100;
max_iter_in = input('Máximo de iteraciones permitidas (Presione Enter para 100): ', 's');
if ~isempty(strtrim(max_iter_in)) && str2double(max_iter_in) > 0
    max_iter = round(str2double(max_iter_in));
end

% -------------------------------------------------------------------------
% PASO 5: Validación de Fourier y Cálculo de Raíces para cada intervalo
% -------------------------------------------------------------------------
raices_calculadas = [];

for i = 1:num_raices
    a_i = intervalos(i, 1);
    b_i = intervalos(i, 2);

    printf('\n=================================================================\n');
    printf('              PROCESANDO RAÍZ %d: INTERVALO [%.4f, %.4f]         \n', i, a_i, b_i);
    printf('=================================================================\n');

    % Validación de Fourier (con derivadas calculadas automáticamente)
    [cumple_fourier, x0_sugerido] = validar_fourier(f, a_i, b_i);

    % Elección de x0
    printf('\nPunto de arranque x0:\n');
    printf('  - Sugerido por Fourier: %.6f\n', x0_sugerido);
    opcion_x0 = input(sprintf('Presione Enter para usar %.6f o ingrese otro valor: ', x0_sugerido), 's');

    if isempty(strtrim(opcion_x0))
        x0 = x0_sugerido;
    else
        x0 = str2double(opcion_x0);
    end

    % Ejecución de Newton-Raphson y medición de tiempo
    tic;
    [raiz_aprox, iteraciones, ~] = ejecutar_newton_raphson(f, x0, tol, max_iter);
    tiempo_computo = toc;

    raices_calculadas = [raices_calculadas, raiz_aprox];

    % Muestra final de resultados
    printf('\n================== RESULTADOS DE LA RAÍZ %d ==================\n', i);
    printf('Intervalo analizado  : [%.6f, %.6f]\n', a_i, b_i);
    printf('Punto inicial x0     : %.6f\n', x0);
    printf('Raíz calculada x*    : %.8f\n', raiz_aprox);
    printf('Residuo f(x*)        : %.8e\n', f(raiz_aprox));
    printf('Derivada df(x*)      : %.8e\n', deriv_primera(f, raiz_aprox));
    printf('Iteraciones reales   : %d\n', iteraciones);
    printf('Tiempo de cómputo    : %.6f segundos\n', tiempo_computo);
    printf('===============================================================\n');
end

% Actualización de la gráfica con las raíces encontradas
if ~isempty(raices_calculadas)
    graficar_funcion(f, a_tanteo, b_tanteo, f_str, raices_calculadas);
    printf('-> Gráfica actualizada con las raíces marcadas en rojo.\n');
end

printf('\nProceso finalizado con éxito para todas las raíces encontradas.\n');

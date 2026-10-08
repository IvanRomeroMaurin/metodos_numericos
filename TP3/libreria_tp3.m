% =========================================================================
% LIBRERÍA DE MÉTODOS NUMÉRICOS - TP3
% Métodos Computacionales
% =========================================================================

function lib = libreria_tp3()
    % LIBRERIA_TP3 Retorna una estructura con punteros a las funciones
    % numéricas para cálculo de raíces no lineales f(x) = 0.
    
    lib.tanteo               = @metodo_tanteo;
    lib.intervalo_medio      = @metodo_intervalo_medio;
    lib.interpolacion_lineal = @metodo_interpolacion_lineal;
    lib.newton_raphson       = @metodo_newton_raphson;
    lib.fourier              = @analizar_fourier;
    lib.punto_fijo           = @metodo_punto_fijo;
end

% -------------------------------------------------------------------------
% 1. Método de Tanteo (Búsqueda Incremental para Separación de Raíces)
% -------------------------------------------------------------------------
function intervalos = metodo_tanteo(f, a, b, paso, mostrar_tabla)
    % METODO_TANTEO Recorre [a, b] evaluando cambios de signo f(x)*f(x+paso) <= 0
    %
    % Parámetros:
    %   f             (function_handle): Función a evaluar f(x).
    %   a             (double):          Límite inferior del intervalo global.
    %   b             (double):          Límite superior del intervalo global.
    %   paso          (double):          Incremento o paso de muestreo (delta x).
    %   mostrar_tabla (boolean):         (Opcional, por defecto true) Muestra tabla.
    %
    % Retorna:
    %   intervalos (matriz N x 2): Cada fila contiene [x_izq, x_der] donde hay raíz.

    if nargin < 5 || isempty(mostrar_tabla)
        mostrar_tabla = true;
    end

    if paso <= 0
        error('El paso del método de tanteo debe ser un valor positivo mayor que cero.');
    end

    intervalos = [];
    x_actual = a;
    f_actual = f(x_actual);

    if mostrar_tabla
        printf('\n%-5s | %-12s | %-14s | %-15s\n', ...
               'Paso', 'x', 'f(x)', 'Cambio Signo');
        printf('%s\n', repmat('-', 1, 52));
        printf('%5d | %12.4f | %14.6f | %-15s\n', 1, x_actual, f_actual, '-');
    end

    k = 2;
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

        if mostrar_tabla
            printf('%5d | %12.4f | %14.6f | %-15s\n', ...
                   k, x_sig, f_sig, marca);
        end

        x_actual = x_sig;
        f_actual = f_sig;
        k = k + 1;
    end
end

% -------------------------------------------------------------------------
% 2. Método de Intervalo Medio (Bisección)
% -------------------------------------------------------------------------
function [raiz, iter, tabla, n_teorico] = metodo_intervalo_medio(f, a, b, tol, max_iter, mostrar_tabla)
    % METODO_INTERVALO_MEDIO Aproxima la raíz por bisección sucesiva de [a, b].
    %
    % Parámetros:
    %   f             (function_handle): Función f(x).
    %   a             (double):          Extremo izquierdo inicial.
    %   b             (double):          Extremo derecho inicial.
    %   tol           (double):          Cota de error admisible (tolerancia).
    %   max_iter      (int):             (Opcional, por defecto 100) Máximo de iteraciones.
    %   mostrar_tabla (boolean):         (Opcional, por defecto true) Imprime tabla.
    %
    % Retorna:
    %   raiz      (double): Valor aproximado de la raíz.
    %   iter      (int):    Cantidad de iteraciones ejecutadas.
    %   tabla     (matriz): Filas con [k, a, b, c, f(c), error].
    %   n_teorico (int):    Cantidad teórica de iteraciones mínimas necesarias.

    if nargin < 5 || isempty(max_iter)
        max_iter = 100;
    end
    if nargin < 6 || isempty(mostrar_tabla)
        mostrar_tabla = true;
    end

    fa = f(a);
    fb = f(b);

    if fa * fb > 0
        error('El intervalo [%.4f, %.4f] no cumple la condición de cambio de signo (Bolzano).', a, b);
    end

    % Cota teórica de iteraciones por fórmula: n >= log2((b - a) / tol)
    n_teorico = ceil((log(b - a) - log(tol)) / log(2));

    if mostrar_tabla
        printf('\n--- Método de Intervalo Medio (Bisección) ---\n');
        printf('Intervalo inicial: [%.4f, %.4f] | Tolerancia: %.6f\n', a, b, tol);
        printf('Iteraciones teóricas mínimas estimadas: %d\n\n', n_teorico);
        printf('%-4s | %-11s | %-11s | %-11s | %-14s | %-12s\n', ...
               'k', 'a', 'b', 'c (medio)', 'f(c)', 'Error Cota');
        printf('%s\n', repmat('-', 1, 75));
    end

    tabla = [];
    c_ant = a;

    for k = 1:max_iter
        c = (a + b) / 2;
        fc = f(c);
        cota_error = (b - a) / 2;

        if mostrar_tabla
            printf('%4d | %11.6f | %11.6f | %11.6f | %14.6e | %12.6e\n', ...
                   k, a, b, c, fc, cota_error);
        end

        tabla = [tabla; k, a, b, c, fc, cota_error];

        % Criterio de parada
        if cota_error < tol || abs(fc) < eps
            raiz = c;
            iter = k;
            return;
        end

        % Actualización de subintervalo según Bolzano
        if fa * fc < 0
            b = c;
            fb = fc;
        else
            a = c;
            fa = fc;
        end
        c_ant = c;
    end

    raiz = c;
    iter = max_iter;
    warning('Intervalo Medio: Se alcanzó el número máximo de iteraciones (%d).', max_iter);
end

% -------------------------------------------------------------------------
% 3. Método de Interpolación Lineal (Regula Falsi / Falsa Posición)
% -------------------------------------------------------------------------
function [raiz, iter, tabla] = metodo_interpolacion_lineal(f, a, b, tol, max_iter, mostrar_tabla)
    % METODO_INTERPOLACION_LINEAL Aproxima la raíz trazando la recta secante.
    %
    % Parámetros:
    %   f             (function_handle): Función f(x).
    %   a             (double):          Extremo izquierdo inicial.
    %   b             (double):          Extremo derecho inicial.
    %   tol           (double):          Cota de error admisible.
    %   max_iter      (int):             (Opcional, por defecto 100) Máximo de iteraciones.
    %   mostrar_tabla (boolean):         (Opcional, por defecto true) Imprime tabla.
    %
    % Retorna:
    %   raiz  (double): Valor aproximado de la raíz.
    %   iter  (int):    Cantidad de iteraciones ejecutadas.
    %   tabla (matriz): Filas con [k, a, b, c, f(c), error].

    if nargin < 5 || isempty(max_iter)
        max_iter = 100;
    end
    if nargin < 6 || isempty(mostrar_tabla)
        mostrar_tabla = true;
    end

    fa = f(a);
    fb = f(b);

    if fa * fb > 0
        error('El intervalo [%.4f, %.4f] no cumple la condición de cambio de signo (Bolzano).', a, b);
    end

    if mostrar_tabla
        printf('\n--- Método de Interpolación Lineal (Regula Falsi) ---\n');
        printf('Intervalo inicial: [%.4f, %.4f] | Tolerancia: %.6f\n\n', a, b, tol);
        printf('%-4s | %-11s | %-11s | %-11s | %-14s | %-12s\n', ...
               'k', 'a', 'b', 'c (secante)', 'f(c)', 'Error Paso');
        printf('%s\n', repmat('-', 1, 75));
    end

    tabla = [];
    c_ant = a;

    for k = 1:max_iter
        c = b - (fb * (b - a)) / (fb - fa);
        fc = f(c);
        error_paso = abs(c - c_ant);

        if mostrar_tabla
            printf('%4d | %11.6f | %11.6f | %11.6f | %14.6e | %12.6e\n', ...
                   k, a, b, c, fc, error_paso);
        end

        tabla = [tabla; k, a, b, c, fc, error_paso];

        % Criterio de parada
        if (k > 1 && error_paso < tol) || abs(fc) < tol
            raiz = c;
            iter = k;
            return;
        end

        % Actualización de extremos
        if fa * fc < 0
            b = c;
            fb = fc;
        else
            a = c;
            fa = fc;
        end
        c_ant = c;
    end

    raiz = c;
    iter = max_iter;
    warning('Interpolación Lineal: Se alcanzó el número máximo de iteraciones (%d).', max_iter);
end

% -------------------------------------------------------------------------
% 4. Método de Newton-Raphson
% -------------------------------------------------------------------------
function [raiz, iter, tabla] = metodo_newton_raphson(f, df, x0, tol, max_iter, mostrar_tabla)
    % METODO_NEWTON_RAPHSON Aproxima la raíz usando rectas tangentes:
    % x_{k+1} = x_k - f(x_k) / f'(x_k)
    %
    % Parámetros:
    %   f             (function_handle): Función f(x).
    %   df            (function_handle): Derivada f'(x).
    %   x0            (double):          Punto inicial.
    %   tol           (double):          Cota de error admisible (|x_{k+1} - x_k| < tol).
    %   max_iter      (int):             (Opcional, por defecto 100) Máximo de iteraciones.
    %   mostrar_tabla (boolean):         (Opcional, por defecto true) Imprime tabla.
    %
    % Retorna:
    %   raiz  (double): Valor aproximado de la raíz.
    %   iter  (int):    Cantidad de iteraciones ejecutadas.
    %   tabla (matriz): Filas con [k, x_k, f(x_k), f'(x_k), error].

    if nargin < 5 || isempty(max_iter)
        max_iter = 100;
    end
    if nargin < 6 || isempty(mostrar_tabla)
        mostrar_tabla = true;
    end

    if mostrar_tabla
        printf('\n--- Método de Newton-Raphson ---\n');
        printf('Punto inicial x0 = %.6f | Tolerancia = %.6e\n\n', x0, tol);
        printf('%-4s | %-12s | %-14s | %-14s | %-12s\n', ...
               'k', 'x_k', 'f(x_k)', "f'(x_k)", 'Error Paso');
        printf('%s\n', repmat('-', 1, 68));
    end

    x = x0;
    tabla = [];

    for k = 1:max_iter
        fx = f(x);
        dfx = df(x);

        if abs(dfx) < eps
            error('Newton-Raphson: Derivada nula o muy cercana a cero en x = %.6f (división por cero).', x);
        end

        % Paso de Newton
        x_sig = x - (fx / dfx);
        error_paso = abs(x_sig - x);

        if mostrar_tabla
            printf('%4d | %12.6f | %14.6e | %14.6e | %12.6e\n', ...
                   k - 1, x, fx, dfx, error_paso);
        end

        tabla = [tabla; k - 1, x, fx, dfx, error_paso];

        % Criterios de parada
        if error_paso < tol || abs(fx) < tol
            raiz = x_sig;
            iter = k;
            if mostrar_tabla
                printf('%4d | %12.6f | %14.6e | %14.6e | %12.6e  (Fin)\n', ...
                       k, x_sig, f(x_sig), df(x_sig), 0);
            end
            return;
        end

        x = x_sig;
    end

    raiz = x;
    iter = max_iter;
    warning('Newton-Raphson: Se alcanzó el número máximo de iteraciones (%d).', max_iter);
end

% -------------------------------------------------------------------------
% 5. Análisis de Condiciones de Fourier para Newton-Raphson
% -------------------------------------------------------------------------
function [cumple, x0_fourier, info] = analizar_fourier(f, df, d2f, a, b, mostrar_detalle)
    % ANALIZAR_FOURIER Evalúa las condiciones suficientes de convergencia de
    % Fourier para el método de Newton-Raphson en el intervalo [a, b]:
    % 1. f(a) * f(b) < 0 (Existencia de raíz por Bolzano)
    % 2. f'(x) != 0 y no cambia de signo en [a, b] (Monotonía estricta)
    % 3. f''(x) != 0 y no cambia de signo en [a, b] (Concavidad estricta)
    % 4. Elección de x0: aquel extremo donde f(x0) * f''(x0) > 0
    %
    % Parámetros:
    %   f               (function_handle): Función f(x).
    %   df              (function_handle): Primera derivada f'(x).
    %   d2f             (function_handle): Segunda derivada f''(x).
    %   a               (double):          Límite inferior.
    %   b               (double):          Límite superior.
    %   mostrar_detalle (boolean):         (Opcional, por defecto true)
    %
    % Retorna:
    %   cumple     (boolean): true si se satisfacen todas las condiciones.
    %   x0_fourier (double):  Punto inicial recomendado según Fourier.
    %   info       (struct):  Detalle de cada condición evaluada.

    if nargin < 6 || isempty(mostrar_detalle)
        mostrar_detalle = true;
    end

    fa = f(a);
    fb = f(b);
    dfa = df(a);
    dfb = df(b);
    d2fa = d2f(a);
    d2fb = d2f(b);

    % Muestreo en el intervalo para verificar signos de derivadas
    x_test = linspace(a, b, 50);
    df_vals = arrayfun(df, x_test);
    d2f_vals = arrayfun(d2f, x_test);

    c1_bolzano    = (fa * fb < 0);
    c2_monotonia  = (all(df_vals > 0) || all(df_vals < 0)) && all(abs(df_vals) > eps);
    c3_concavidad = (all(d2f_vals > 0) || all(d2f_vals < 0)) && all(abs(d2f_vals) > eps);

    % Determinación de x0 según f(x0) * f''(x0) > 0
    prod_a = fa * d2fa;
    prod_b = fb * d2fb;

    if prod_a > 0
        x0_fourier = a;
        c4_x0 = true;
    elseif prod_b > 0
        x0_fourier = b;
        c4_x0 = true;
    else
        x0_fourier = (a + b) / 2;
        c4_x0 = false;
    end

    cumple = c1_bolzano && c2_monotonia && c3_concavidad && c4_x0;

    info.c1_bolzano    = c1_bolzano;
    info.c2_monotonia  = c2_monotonia;
    info.c3_concavidad = c3_concavidad;
    info.c4_x0         = c4_x0;
    info.x0_fourier    = x0_fourier;

    if mostrar_detalle
        printf('\n=================================================================\n');
        printf('   ANÁLISIS DE CONDICIONES DE FOURIER EN [%.4f, %.4f]           \n', a, b);
        printf('=================================================================\n');
        printf('1. Existencia (Bolzano): f(a)*f(b) < 0\n');
        printf('   f(%.4f) = %11.4e  |  f(%.4f) = %11.4e\n', a, fa, b, fb);
        if c1_bolzano
            printf('   -> CUMPLE: Hay cambio de signo en el intervalo.\n');
        else
            printf('   -> NO CUMPLE: No hay cambio de signo.\n');
        end

        printf('\n2. Monotonía (Primera derivada): f''(x) != 0 sin cambio de signo\n');
        printf("   f'(%.4f) = %11.4e  |  f'(%.4f) = %11.4e\n", a, dfa, b, dfb);
        if c2_monotonia
            printf("   -> CUMPLE: f'(x) no se anula y conserva el mismo signo en el intervalo.\n");
        else
            printf("   -> NO CUMPLE: f'(x) cambia de signo o se anula.\n");
        end

        printf('\n3. Concavidad (Segunda derivada): f''''(x) != 0 sin cambio de signo\n');
        printf("   f''(%.4f) = %11.4e  |  f''(%.4f) = %11.4e\n", a, d2fa, b, d2fb);
        if c3_concavidad
            printf("   -> CUMPLE: f''(x) no tiene puntos de inflexión en el intervalo.\n");
        else
            printf("   -> NO CUMPLE: f''(x) cambia de signo en el intervalo.\n");
        end

        printf('\n4. Elección del punto inicial x0 tal que f(x0) * f''''(x0) > 0:\n');
        printf('   Extremo a = %.4f: f(a)*f''''(a) = %11.4e\n', a, prod_a);
        printf('   Extremo b = %.4f: f(b)*f''''(b) = %11.4e\n', b, prod_b);
        printf('   -> Punto de arranque óptimo recomendado por Fourier: x0 = %.4f\n', x0_fourier);
        if cumple
            printf('\n==> Conclusión: SE SATISFACEN TODAS LAS CONDICIONES DE FOURIER.\n');
            printf('    La convergencia monótona de Newton-Raphson está teóricamente garantizada.\n');
        else
            printf('\n==> ADVERTENCIA: Alguna condición no se cumple plenamente.\n');
        end
        printf('=================================================================\n\n');
    end
end

% -------------------------------------------------------------------------
% 6. Método de Iteración de Punto Fijo (con opción de Aceleración de Aitken)
% -------------------------------------------------------------------------
function [raiz, iter, tabla] = metodo_punto_fijo(g, x0, tol, max_iter, usar_aitken, mostrar_tabla)
    % METODO_PUNTO_FIJO Resuelve x = g(x) de forma estándar o con Aitken Delta^2.
    %
    % Parámetros:
    %   g             (function_handle): Función de punto fijo g(x).
    %   x0            (double):          Valor inicial.
    %   tol           (double):          Cota de error (|x_{k+1} - x_k| < tol).
    %   max_iter      (int):             (Opcional, por defecto 100).
    %   usar_aitken   (boolean):         (Opcional, por defecto false).
    %   mostrar_tabla (boolean):         (Opcional, por defecto true).

    if nargin < 4 || isempty(max_iter)
        max_iter = 100;
    end
    if nargin < 5 || isempty(usar_aitken)
        usar_aitken = false;
    end
    if nargin < 6 || isempty(mostrar_tabla)
        mostrar_tabla = true;
    end

    tabla = [];
    x = x0;

    if ~usar_aitken
        if mostrar_tabla
            printf('\n--- Método de Punto Fijo Simple: x = g(x) ---\n');
            printf('Punto inicial x0 = %.6f | Tolerancia = %.6e\n\n', x0, tol);
            printf('%-4s | %-14s | %-14s | %-14s\n', 'k', 'x_k', 'x_{k+1}=g(x_k)', 'Error Paso');
            printf('%s\n', repmat('-', 1, 58));
        end

        for k = 1:max_iter
            x_sig = g(x);
            err = abs(x_sig - x);

            if mostrar_tabla
                printf('%4d | %14.6f | %14.6f | %14.6e\n', k, x, x_sig, err);
            end

            tabla = [tabla; k, x, x_sig, err];

            if err < tol
                raiz = x_sig;
                iter = k;
                return;
            end
            x = x_sig;
        end
    else
        if mostrar_tabla
            printf('\n--- Método de Punto Fijo con Aceleración de Aitken (Delta^2) ---\n');
            printf('Punto inicial x0 = %.6f | Tolerancia = %.6e\n\n', x0, tol);
            printf('%-4s | %-14s | %-14s | %-14s\n', 'Ciclo', 'x_base', 'x_aitken', 'Error Paso');
            printf('%s\n', repmat('-', 1, 58));
        end

        for k = 1:max_iter
            x1 = g(x);
            x2 = g(x1);
            denominador = x2 - 2*x1 + x;

            if abs(denominador) < eps
                raiz = x2;
                iter = k;
                return;
            end

            x_aitken = x2 - ((x2 - x1)^2) / denominador;
            err = abs(x_aitken - x);

            if mostrar_tabla
                printf('%4d | %14.6f | %14.6f | %14.6e\n', k, x, x_aitken, err);
            end

            tabla = [tabla; k, x, x_aitken, err];

            if err < tol
                raiz = x_aitken;
                iter = k;
                return;
            end
            x = x_aitken;
        end
    end

    raiz = x;
    iter = max_iter;
    warning('Punto Fijo: Se alcanzó el número máximo de iteraciones (%d).', max_iter);
end

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
        printf('\n%-5s | %-12s | %-14s | %-12s | %-14s | %-10s\n', ...
               'Paso', 'x_i', 'f(x_i)', 'x_{i+1}', 'f(x_{i+1})', 'Cambio Signo');
        printf('%s\n', repmat('-', 1, 78));
    end

    k = 1;
    while x_actual < b
        x_sig = min(x_actual + paso, b);
        f_sig = f(x_sig);

        hay_cambio = (f_actual * f_sig <= 0);

        if mostrar_tabla
            if hay_cambio
                marca = 'SI (Raiz)';
            else
                marca = 'NO';
            end
            printf('%5d | %12.4f | %14.6f | %12.4f | %14.6f | %-10s\n', ...
                   k, x_actual, f_actual, x_sig, f_sig, marca);
        end

        if hay_cambio
            intervalos = [intervalos; x_actual, x_sig];
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
        % Fórmula de la secante para la falsa posición
        c = b - (fb * (b - a)) / (fb - fa);
        fc = f(c);
        error_paso = abs(c - c_ant);

        if mostrar_tabla
            printf('%4d | %11.6f | %11.6f | %11.6f | %14.6e | %12.6e\n', ...
                   k, a, b, c, fc, error_paso);
        end

        tabla = [tabla; k, a, b, c, fc, error_paso];

        % Criterio de parada: error entre pasos sucesivos o residuo nulo
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

% =========================================================================
% MÉTODO DE INTERVALO MEDIO (BISECCIÓN) CON TANTEO PREVIO
% Métodos Numéricos / Métodos Computacionales
%
%   1. Carga de la función f(x) por teclado.
%   2. Separación de raíces por Método de Tanteo.
%   3. Gráfica de la función con fplot y la recta f(x) = 0.
%   4. Validación de las condiciones del método en cada intervalo.
%   5. Cálculo de todas las raíces por Intervalo Medio.
%   6. Marcado de las raíces halladas sobre la gráfica.
% =========================================================================

1; % Indica a Octave que el archivo es un script con funciones

% -------------------------------------------------------------------------
% Graficador de función
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
% Método de Tanteo: recorre [a, b] con el incremento dado y guarda los
% subintervalos donde f cambia de signo.
% -------------------------------------------------------------------------
function intervalos = metodo_tanteo(f, a, b, incremento)
    intervalos = [];
    x_actual = a;
    f_actual = f(x_actual);

    printf('\n%-12s | %-14s | %-15s\n', 'x_i', 'f(x_i)', 'Cambio Signo');
    printf('%s\n', repmat('-', 1, 46));
    printf('%12.4f | %14.6f | %-15s\n', x_actual, f_actual, '-');

    while x_actual < b
        x_sig = min(x_actual + incremento, b);
        f_sig = f(x_sig);

        % f_sig == 0 cubre la raíz exacta sin duplicar el intervalo siguiente
        if f_actual * f_sig < 0 || f_sig == 0
            marca = 'SI (Raiz)';
            intervalos = [intervalos; x_actual, x_sig];
        else
            marca = 'NO';
        end

        printf('%12.4f | %14.6f | %-15s\n', x_sig, f_sig, marca);

        x_actual = x_sig;
        f_actual = f_sig;
    end

    % Raíz exacta en el extremo inicial
    if f(a) == 0
        intervalos = [a, a; intervalos];
    end
end

% -------------------------------------------------------------------------
% Condiciones del Método de Intervalo Medio en [a, b]:
%   1. f continua en [a, b] (se verifica que sea finita en todo el intervalo)
%   2. f(a) * f(b) < 0 (Teorema de Bolzano)
% -------------------------------------------------------------------------
function cumple = validar_condiciones(f, a, b)
    fa = f(a);
    fb = f(b);
    muestras = f(linspace(a, b, 100));

    c1_continua = all(isfinite(muestras));
    c2_bolzano  = (fa * fb <= 0);

    printf('\nCondiciones del método en [%.4f, %.4f]:\n', a, b);

    printf('1. Continuidad de f en [a, b]\n');
    if c1_continua
        printf('   [CUMPLE] f es finita en todo el intervalo.\n');
    else
        printf('   [NO CUMPLE] f presenta valores no finitos (posible discontinuidad).\n');
    end

    printf('2. Cambio de signo (Bolzano): f(a) * f(b) < 0\n');
    printf('   f(%.4f) = %.6f  |  f(%.4f) = %.6f\n', a, fa, b, fb);
    if c2_bolzano
        printf('   [CUMPLE] Existe al menos una raíz en el intervalo.\n');
    else
        printf('   [NO CUMPLE] No hay cambio de signo en los extremos.\n');
    end

    cumple = c1_continua && c2_bolzano;
end

% -------------------------------------------------------------------------
% Método de Intervalo Medio: divide [a, b] a la mitad hasta que la cota
% del error (b - a) / 2 sea menor que la tolerancia.
% -------------------------------------------------------------------------
function [raiz, iter, n_teorico] = metodo_intervalo_medio(f, a, b, tol, max_iter)
    fa = f(a);
    fb = f(b);

    % Raíz exacta en un extremo
    if fa == 0 || fb == 0
        raiz = a * (fa == 0) + b * (fa ~= 0);
        iter = 0;
        n_teorico = 0;
        printf('\nRaíz exacta en el extremo del intervalo: x = %.6f\n', raiz);
        return;
    end

    % Cantidad mínima de iteraciones: n >= log2((b - a) / tol)
    n_teorico = ceil(log2((b - a) / tol));

    printf('\nIteraciones teóricas mínimas estimadas: %d\n\n', n_teorico);
    printf('%-4s | %-26s | %-11s | %-14s | %-12s\n', ...
           'i', 'Intervalo', 'x', 'f(x)', 'Error');
    printf('%s\n', repmat('-', 1, 79));

    for k = 1:max_iter
        c = (a + b) / 2;
        fc = f(c);
        cota_error = (b - a) / 2;

        printf('%4d | [%11.6f, %11.6f] | %11.6f | %14.6e | %12.6f\n', ...
               k, a, b, c, fc, cota_error);

        if cota_error < tol || fc == 0
            raiz = c;
            iter = k;
            return;
        end

        if fa * fc < 0
            b = c;
        else
            a = c;
            fa = fc;
        end
    end

    raiz = c;
    iter = max_iter;
    warning('Se alcanzó el número máximo de iteraciones (%d).', max_iter);
end

% =========================================================================
% PROGRAMA PRINCIPAL
% =========================================================================
clc;




printf('=================================================================\n');
printf('          MÉTODO DE INTERVALO MEDIO (BISECCIÓN)                  \n');
printf('=================================================================\n\n');

% 1. Ingreso de la función
printf('Ingrese la función f(x) en términos de x.\n');
printf('Ejemplos:  pi*x^2*(3 - x/3) - 30   |   8*x + 0.3*x^2 - 0.0013*x^3 - 372\n\n');

f = [];
while isempty(f)
    f_str = strtrim(input('f(x) = ', 's'));
    try
        f_escalar = str2func(['@(x) ' f_str]);
        f = @(x) arrayfun(f_escalar, x);
        f(1);  % prueba de evaluación
    catch err
        printf('Error en la expresión: %s\nIntente nuevamente.\n\n', err.message);
        f = [];
    end
end

% 2. Método de Tanteo
printf('\n-----------------------------------------------------------------\n');
printf('                     MÉTODO DE TANTEO                            \n');
printf('-----------------------------------------------------------------\n');

intervalos = [];
while isempty(intervalos)
    a = input('Ingrese el límite inferior a: ');
    b = input('Ingrese el límite superior b: ');
    incremento = input('Ingrese el incremento: ');

    if b <= a || incremento <= 0
        printf('Error: debe cumplirse a < b e incremento > 0.\n\n');
        continue;
    end

    intervalos = metodo_tanteo(f, a, b, incremento);

    if isempty(intervalos)
        printf('\nNo se encontraron cambios de signo. Pruebe con otro intervalo o incremento.\n\n');
    end
end

num_raices = size(intervalos, 1);
printf('\nSe encontraron %d intervalo(s) con raíz:\n', num_raices);
for i = 1:num_raices
    printf('  Raíz %d: [%.4f, %.4f]\n', i, intervalos(i, 1), intervalos(i, 2));
end

% 3. Gráfica de la función
printf('\n-> Generando gráfica de f(x) en [%.2f, %.2f]...\n', a, b);
graficar_funcion(f, a, b, f_str);

% 4. Parámetros del método
printf('\n-----------------------------------------------------------------\n');
tol = 0;
while tol <= 0
    tol = input('Ingrese la cota de error E (ej. 0.001): ');
end

max_iter = 100;
entrada = input('Máximo de iteraciones (Enter = 100): ', 's');
if ~isempty(entrada) && str2double(entrada) > 0
    max_iter = round(str2double(entrada));
end

% 5. Validación y cálculo de cada raíz
raices = zeros(num_raices, 1);
for i = 1:num_raices
    a_i = intervalos(i, 1);
    b_i = intervalos(i, 2);

    printf('\n=================================================================\n');
    printf('  RAÍZ %d: INTERVALO [%.4f, %.4f]\n', i, a_i, b_i);
    printf('=================================================================\n');

    if ~validar_condiciones(f, a_i, b_i)
        printf('\nNo se cumplen las condiciones del método. Se omite este intervalo.\n');
        raices(i) = NaN;
        continue;
    end

    %Metodo de intervalo medio
    tic;
    [raices(i), iter, n_teorico] = metodo_intervalo_medio(f, a_i, b_i, tol, max_iter);
    tiempo = toc;

    % Si |f| creció respecto de los extremos, el cambio de signo era una
    % discontinuidad (ej. 1/x en x = 0) y no una raíz

    if abs(f(raices(i))) > max(abs(f(a_i)), abs(f(b_i)))
        printf('\n[NO CUMPLE] |f(x)| crece cerca de x = %.6f: hay una discontinuidad, no una raíz.\n', raices(i));
        raices(i) = NaN;
        continue;
    end

    printf('\nResultado:\n');
    printf('  Raíz aproximada:      x = %.6f\n', raices(i));
    printf('  Residuo f(x):         %.8f\n', f(raices(i)));
    printf('  Iteraciones teóricas: %d\n', n_teorico);
    printf('  Iteraciones reales:   %d\n', iter);
    printf('  Tiempo de cómputo:    %.6f s\n', tiempo);
end

printf('\n=================================================================\n');
printf('                       RESUMEN DE RAÍCES                         \n');
printf('=================================================================\n');
for i = 1:num_raices
    printf('  x%d = %.6f\n', i, raices(i));
end

% 6. Gráfica con las raíces marcadas
if any(isfinite(raices))
    graficar_funcion(f, a, b, f_str, raices);
    printf('\n-> Gráfica actualizada con las raíces marcadas en rojo.\n');
end

% =========================================================================
% INTERPOLACIÓN INVERSA - FÓRMULA LINEAL (NEWTON-GREGORY)
% Métodos Numéricos / Métodos Computacionales
%
% Características:
%   1. Carga de la tabla de valores (x, y) equidistantes por teclado.
%   2. Validación de las condiciones de aplicabilidad del método.
%   3. Tabla de diferencias finitas y búsqueda del intervalo [x_i, x_i+1]
%      que contiene al valor de y buscado.
%   4. Cálculo de x mediante la fórmula de interpolación inversa lineal.
%   5. Gráfica de la función interpolada con el punto hallado.
% =========================================================================

1; % Declaración de script en GNU Octave

% -------------------------------------------------------------------------
% 1. Tabla de diferencias finitas hacia adelante
% -------------------------------------------------------------------------
function D = calcular_tabla_diferencias(y)
    n = length(y);
    D = zeros(n, n);
    D(:, 1) = y(:);
    for j = 2:n
        for i = 1:(n - j + 1)
            D(i, j) = D(i + 1, j - 1) - D(i, j - 1);
        end
    end
end

% -------------------------------------------------------------------------
% 2. Validación de las condiciones de aplicabilidad del método
% -------------------------------------------------------------------------
function [cumple, indice] = validar_condiciones(x, y, y_buscado)
    n = length(x);
    printf('\n=================================================================\n');
    printf('        VALIDACIÓN DE LAS CONDICIONES DEL MÉTODO                 \n');
    printf('=================================================================\n');

    h_valores = diff(x);
    c1_equidistante = all(abs(h_valores - h_valores(1)) < 1e-9);
    printf('1. Los valores de x deben ser equidistantes (paso h constante)\n');
    printf('   Pasos h encontrados: %s\n', mat2str(h_valores, 6));
    if c1_equidistante
        printf('   [CUMPLE] El paso h = %.6g es constante.\n', h_valores(1));
    else
        printf('   [NO CUMPLE] El paso entre los valores de x no es constante:\n');
        printf('               la formula de Newton-Gregory no es aplicable.\n');
    end

    c2_rango = (y_buscado >= min(y)) && (y_buscado <= max(y));
    printf('\n2. El valor buscado debe estar dentro del rango de la tabla\n');
    printf('   (de lo contrario seria extrapolacion, no interpolacion)\n');
    printf('   Rango de y: [%.6g, %.6g]   |   y buscado = %.6g\n', min(y), max(y), y_buscado);
    if c2_rango
        printf('   [CUMPLE] El valor buscado esta dentro del rango de la tabla.\n');
    else
        printf('   [NO CUMPLE] El valor buscado esta fuera del rango de la tabla.\n');
    end

    indice = 0;
    c3_intervalo = false;
    if c2_rango
        for i = 1:n-1
            if (y_buscado - y(i)) * (y_buscado - y(i + 1)) <= 0
                indice = i;
                break;
            end
        end
        c3_intervalo = (indice > 0) && (abs(y(indice + 1) - y(indice)) > 1e-12);
        printf('\n3. El intervalo encontrado no debe tener Delta y nulo\n');
        printf('   (de lo contrario habria division por cero en la formula)\n');
        if indice > 0
            printf('   Intervalo elegido: [x_%d, x_%d] = [%.6g, %.6g]\n', ...
                indice - 1, indice, x(indice), x(indice + 1));
            printf('   y(x_%d) = %.6g   |   y(x_%d) = %.6g\n', ...
                indice - 1, y(indice), indice, y(indice + 1));
        end
        if c3_intervalo
            printf('   [CUMPLE] Delta y del intervalo elegido es distinto de cero.\n');
        else
            printf('   [NO CUMPLE] No se encontro un intervalo valido para interpolar.\n');
        end
    else
        printf('\n3. El intervalo encontrado no debe tener Delta y nulo\n');
        printf('   [OMITIDO] No corresponde buscar intervalo: el valor esta fuera de rango.\n');
    end

    cumple = c1_equidistante && c2_rango && c3_intervalo;
    printf('=================================================================\n');
end

% -------------------------------------------------------------------------
% 3. Interpolación inversa lineal
% -------------------------------------------------------------------------
function [x_calculado, detalle] = interpolacion_inversa_lineal(x, D, indice, y_buscado)
    % De la formula de Newton-Gregory Ascendente truncada al primer orden,
    % P(x) = y0 + (Delta y0 / h) * (x - x0) = y_buscado, se despeja x:
    %   x = x0 + h * (y_buscado - y0) / Delta y0
    h = x(2) - x(1);
    x0 = x(indice);
    y0 = D(indice, 1);
    delta_y0 = D(indice, 2);
    x_calculado = x0 + h * (y_buscado - y0) / delta_y0;
    detalle = struct('h', h, 'x0', x0, 'y0', y0, 'delta_y0', delta_y0);
end

% =========================================================================
% PROGRAMA PRINCIPAL
% =========================================================================
clc;
printf('=================================================================\n');
printf('         INTERPOLACION INVERSA - FORMULA LINEAL                  \n');
printf('=================================================================\n\n');

printf('Ejemplo practico (TP5, tabla de valores de coseno):\n');
printf('  x = [15 25 35 45 55 65]\n');
printf('  y = [0.965926 0.906308 0.819152 0.707107 0.573576 0.422618]\n');
printf('  Se busca el valor de x para el cual y = 0.90728517\n\n');

% Valores por defecto (ejemplo del enunciado): se usan si se presiona Enter
x_defecto = [15 25 35 45 55 65];
y_defecto = [0.965926 0.906308 0.819152 0.707107 0.573576 0.422618];
y_buscado_defecto = 0.90728517;

x_datos = input('Ingrese el vector de x equidistantes (Enter = [15 25 35 45 55 65]): ');
if isempty(x_datos)
    x_datos = x_defecto;
    printf('  -> Se usa x por defecto.\n');
end
y_datos = input('Ingrese el vector de y = f(x) (Enter = [0.965926 0.906308 0.819152 0.707107 0.573576 0.422618]): ');
if isempty(y_datos)
    y_datos = y_defecto;
    printf('  -> Se usa y por defecto.\n');
end
y_buscado = input('Ingrese el valor de y para el cual se busca x (Enter = 0.90728517): ');
if isempty(y_buscado)
    y_buscado = y_buscado_defecto;
    printf('  -> Se usa y buscado por defecto.\n');
end

[cumple, indice] = validar_condiciones(x_datos, y_datos, y_buscado);
if ~cumple
    error('No se cumplen las condiciones necesarias para aplicar la interpolacion inversa lineal.');
end

n = length(x_datos);
D = calcular_tabla_diferencias(y_datos);
disp('Tabla de diferencias finitas hacia adelante:');
printf('%8s %10s', 'x', 'y');
for k = 1:n-1
    printf('  %10s', sprintf('D^%dy', k));
end
printf('\n');
for i = 1:n
    printf('%8.4g %10.6f', x_datos(i), D(i, 1));
    for j = 2:(n - i + 1)
        printf('  %+10.6f', D(i, j));
    end
    printf('\n');
end

tic;
[x_calculado, detalle] = interpolacion_inversa_lineal(x_datos, D, indice, y_buscado);
tiempo_computo = toc;

printf('\n=================================================================\n');
printf('                  DESARROLLO DE LA FORMULA                        \n');
printf('=================================================================\n');
printf('Intervalo elegido: [x_%d, x_%d] = [%.6g, %.6g]\n', indice - 1, indice, x_datos(indice), x_datos(indice + 1));
printf('h        = %.6g\n', detalle.h);
printf('x0       = %.6g\n', detalle.x0);
printf('y0       = %.6g\n', detalle.y0);
printf('Delta y0 = %.6g\n', detalle.delta_y0);
printf('\n  x = x0 + h * (y_buscado - y0) / Delta y0\n');
printf('  x = %.6g + %.6g * (%.6g - %.6g) / %.6g\n', detalle.x0, detalle.h, y_buscado, detalle.y0, detalle.delta_y0);
printf('\n>>> RESULTADO: x = %.6f\n', x_calculado);
printf('Tiempo de computo: %.6f segundos\n', tiempo_computo);
printf('=================================================================\n');

% Grafico
figure('Name', 'Interpolacion inversa lineal');
x_fino = linspace(x_datos(1), x_datos(end), 200);
y_fino = interp1(x_datos, y_datos, x_fino, 'spline');
plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5); hold on;
plot(x_datos, y_datos, 'ko', 'MarkerFaceColor', 'k');
plot(x_datos(indice:indice + 1), y_datos(indice:indice + 1), 'g-', 'LineWidth', 2);
plot(x_calculado, y_buscado, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
xlabel('x'); ylabel('y');
legend('f(x) interpolada', 'Datos', 'Recta de interpolacion lineal', ...
    sprintf('x = %.4f  (y = %.4f)', x_calculado, y_buscado), 'Location', 'best');
title('Interpolacion inversa lineal');
grid on;

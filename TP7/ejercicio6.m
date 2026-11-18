1; % script con funciones locales

function yp = f_ejercicio6(x, y)
  % Ecuacion diferencial: y' = 3x + 3y
  yp = 3 * x + 3 * y;
end

function y_exacta = solucion_exacta_ejercicio6(x)
  % Solucion exacta: y = (4/3)*e^(3x) - x - 1/3
  y_exacta = (4 / 3) * exp(3 * x) - x - 1 / 3;
end

function [tabla, iteraciones] = metodo_euler_modificado(x0, y0, h, n_pasos, E)
  % Metodo Modificado de Euler (predictor-corrector) con criterio de corte E
  tabla = zeros(n_pasos + 1, 3); % columnas: x, y, y'
  iteraciones = zeros(n_pasos, 1);
  x = x0; y = y0;
  yp = f_ejercicio6(x, y);
  tabla(1, :) = [x, y, yp];
  for i = 1:n_pasos
    x_sig = x + h;
    P_y = y + yp * h;
    P_yp = f_ejercicio6(x_sig, P_y);
    C_y = y + ((yp + P_yp) / 2) * h;
    C_yp = f_ejercicio6(x_sig, C_y);
    iter = 1;
    while abs(C_y - P_y) >= E
      P_y = C_y;
      P_yp = C_yp;
      C_y = y + ((yp + P_yp) / 2) * h;
      C_yp = f_ejercicio6(x_sig, C_y);
      iter = iter + 1;
      if iter > 100
        break;
      end
    end
    x = x_sig; y = C_y; yp = C_yp;
    tabla(i + 1, :) = [x, y, yp];
    iteraciones(i) = iter;
  end
end

function [y_nuevo, yp_nuevo, P_y] = paso_milne(x, y, yp, h, i)
  % Metodo de Milne (predictor-corrector), corrigiendo dos veces:
  % P(y_i+1) = y_i-3 + (4h/3)*(2*y'_i - y'_i-1 + 2*y'_i-2)
  % C(y_i+1) = y_i-1 + (h/3)*(y'_i-1 + 4*y'_i + P(y'_i+1))
  x_nuevo = x(i + 1) + h;

  P_y = y(i - 2) + (4 * h / 3) * (2 * yp(i + 1) - yp(i) + 2 * yp(i - 1));
  P_yp = f_ejercicio6(x_nuevo, P_y);

  C_y = y(i) + (h / 3) * (yp(i) + 4 * yp(i + 1) + P_yp);
  C_yp = f_ejercicio6(x_nuevo, C_y);

  C1_y = y(i) + (h / 3) * (yp(i) + 4 * yp(i + 1) + C_yp);
  C1_yp = f_ejercicio6(x_nuevo, C1_y);

  y_nuevo = C1_y;
  yp_nuevo = C1_yp;
end

function imprimir_tabla(tabla)
  printf('%6s %10s %12s %12s %14s %12s\n', 'i', 'x_i', 'y_i', "y'_i", 'y_i (exacta)', 'Error abs.');
  printf('---------------------------------------------------------------------\n');
  for i = 1:size(tabla, 1)
    y_exacta = solucion_exacta_ejercicio6(tabla(i, 1));
    printf('%6d %10.4f %12.6f %12.6f %14.6f %12.6f\n', i - 1, tabla(i, 1), tabla(i, 2), tabla(i, 3), ...
      y_exacta, abs(tabla(i, 2) - y_exacta));
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 6: y' = 3x + 3y ; Metodo Modificado de Euler y Metodo de Milne
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 6 - EULER MODIFICADO Y METODO DE MILNE');
disp('============================================================');
printf("\nEcuacion diferencial: y' = 3x + 3y , con y(0) = 1\n");

y0 = input('Ingrese y0 (ej: 1): ');
E = input('Ingrese la cota de error E para el Metodo Modificado (ej: 0.001): ');

% --- a) Euler Modificado con h=0.1 ---
h1 = 0.1;
n1 = round(0.3 / h1);
printf('\n>>> a) METODO MODIFICADO DE EULER en (0 ; 0.3) con h=%g <<<\n', h1);
[tabla_h1, iter_h1] = metodo_euler_modificado(0, y0, h1, n1, E);
imprimir_tabla(tabla_h1);

% --- a) Euler Modificado con h=0.05 ---
h2 = 0.05;
n2 = round(0.3 / h2);
printf('\n>>> a) METODO MODIFICADO DE EULER en (0 ; 0.3) con h=%g <<<\n', h2);
[tabla_h2, iter_h2] = metodo_euler_modificado(0, y0, h2, n2, E);
imprimir_tabla(tabla_h2);

% --- b) Metodo de Milne para x=0.20 y x=0.25, usando h=0.05 como arranque ---
printf('\n>>> b) METODO DE MILNE para hallar y en x=0.20 y x=0.25 <<<\n');
printf('Se usan como valores de arranque los primeros 4 puntos (x=0, 0.05, 0.10, 0.15)\n');
printf('obtenidos en el item a) con h=%g.\n', h2);

x = tabla_h2(1:4, 1)';
y = tabla_h2(1:4, 2)';
yp = tabla_h2(1:4, 3)';

[y4, yp4, P_y4] = paso_milne(x, y, yp, h2, 3);
x4 = x(4) + h2;
printf('\nPara x=%.4g:\n', x4);
printf('P(y) = %.6f\n', P_y4);
printf('C^1(y) [segunda correccion] = %.6f\n', y4);
printf('>>> RESULTADO: y(%.4g) = %.6f  |  y exacta = %.6f  |  Error abs. = %.6f\n', ...
  x4, y4, solucion_exacta_ejercicio6(x4), abs(y4 - solucion_exacta_ejercicio6(x4)));

x = [x, x4]; y = [y, y4]; yp = [yp, yp4];

[y5, yp5, P_y5] = paso_milne(x, y, yp, h2, 4);
x5 = x(5) + h2;
printf('\nPara x=%.4g:\n', x5);
printf('P(y) = %.6f\n', P_y5);
printf('C^1(y) [segunda correccion] = %.6f\n', y5);
printf('>>> RESULTADO: y(%.4g) = %.6f  |  y exacta = %.6f  |  Error abs. = %.6f\n', ...
  x5, y5, solucion_exacta_ejercicio6(x5), abs(y5 - solucion_exacta_ejercicio6(x5)));

x = [x, x5]; y = [y, y5]; yp = [yp, yp5];

% --- c) Errores en cada paso de integracion ---
printf('\n>>> c) ERRORES EN CADA PASO DE INTEGRACION (Metodo de Milne) <<<\n');
printf('%6s %12s %12s %14s %12s\n', 'i', 'x_i', 'y_i', 'y_i (exacta)', 'Error abs.');
printf('-----------------------------------------------------------------\n');
for i = 1:length(x)
  y_exacta = solucion_exacta_ejercicio6(x(i));
  printf('%6d %12.6f %12.6f %14.6f %12.6f\n', i - 1, x(i), y(i), y_exacta, abs(y(i) - y_exacta));
end
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 6 - Euler Modificado y Metodo de Milne');
x_fino = linspace(0, 0.3, 200);
y_fino = solucion_exacta_ejercicio6(x_fino);
plot(x_fino, y_fino, 'k-', 'LineWidth', 1.5); hold on;
plot(tabla_h1(:, 1), tabla_h1(:, 2), 'b-o', 'LineWidth', 1.2, 'MarkerFaceColor', 'b');
plot(tabla_h2(:, 1), tabla_h2(:, 2), 'g-^', 'LineWidth', 1.2, 'MarkerFaceColor', 'g');
plot(x(5:6), y(5:6), 'r-s', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
xlabel('x'); ylabel('y');
legend('Solucion exacta', sprintf('Euler Modificado h=%g', h1), sprintf('Euler Modificado h=%g', h2), ...
  'Metodo de Milne', 'Location', 'best');
title("Solucion de y' = 3x + 3y");
grid on;

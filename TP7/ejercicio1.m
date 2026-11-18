1; % script con funciones locales

function yp = f_ejercicio1(x, y)
  % Ecuacion diferencial: y' = x^2 + y^2
  yp = x .^ 2 + y .^ 2;
end

function tabla = metodo_euler(x0, y0, h, n_pasos)
  % Metodo de Euler: x_{i+1}=x_i+h ; y_{i+1}=y_i+y'_i*h
  tabla = zeros(n_pasos + 1, 3); % columnas: x, y, y'
  x = x0; y = y0;
  for i = 0:n_pasos
    yp = f_ejercicio1(x, y);
    tabla(i + 1, :) = [x, y, yp];
    if i < n_pasos
      y = y + yp * h;
      x = x + h;
    end
  end
end

function [tabla, iteraciones] = metodo_euler_modificado(x0, y0, h, n_pasos, E)
  % Metodo Modificado de Euler (predictor-corrector) con criterio de corte E:
  % P(y_i+1) = y_i + y'_i * h
  % C(y_i+1) = y_i + [(y'_i + P(y'_i+1)) / 2] * h
  % Se repite la correccion hasta que |C_nuevo - C_anterior| < E
  tabla = zeros(n_pasos + 1, 3);
  iteraciones = zeros(n_pasos, 1);
  x = x0; y = y0;
  yp = f_ejercicio1(x, y);
  tabla(1, :) = [x, y, yp];
  for i = 1:n_pasos
    x_sig = x + h;
    P_y = y + yp * h;
    P_yp = f_ejercicio1(x_sig, P_y);
    C_y = y + ((yp + P_yp) / 2) * h;
    C_yp = f_ejercicio1(x_sig, C_y);
    iter = 1;
    while abs(C_y - P_y) >= E
      P_y = C_y;
      P_yp = C_yp;
      C_y = y + ((yp + P_yp) / 2) * h;
      C_yp = f_ejercicio1(x_sig, C_y);
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

function imprimir_tabla(tabla)
  printf('%6s %12s %12s %12s\n', 'i', 'x_i', 'y_i', "y'_i");
  printf('-------------------------------------------------\n');
  for i = 1:size(tabla, 1)
    printf('%6d %12.6f %12.6f %12.6f\n', i - 1, tabla(i, 1), tabla(i, 2), tabla(i, 3));
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 1: y' = x^2 + y^2 ; Metodo de Euler y Metodo Modificado de Euler
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 1 - METODO DE EULER Y METODO MODIFICADO DE EULER');
disp('============================================================');
printf("\nEcuacion diferencial: y' = x^2 + y^2\n");

x0 = input('Ingrese x0 (ej: 0): ');
y0 = input('Ingrese y0 (ej: 1): ');
h = input('Ingrese el paso h (ej: 0.2): ');
x_final = input('Ingrese el extremo final del intervalo (ej: 0.6): ');
E = input('Ingrese la cota de error E para el Metodo Modificado (ej: 0.001): ');

n_pasos = round((x_final - x0) / h);

% --- a) Metodo de Euler ---
printf('\n>>> a) METODO DE EULER en (%g ; %g) con h=%g <<<\n', x0, x_final, h);
tabla_euler = metodo_euler(x0, y0, h, n_pasos);
imprimir_tabla(tabla_euler);
printf('>>> RESULTADO: y(%g) = %.6f (Euler)\n', x_final, tabla_euler(end, 2));

% --- b) Metodo Modificado de Euler ---
printf('\n>>> b) METODO MODIFICADO DE EULER en (%g ; %g) con h=%g y E<%g <<<\n', x0, x_final, h, E);
[tabla_modif, iteraciones] = metodo_euler_modificado(x0, y0, h, n_pasos, E);
imprimir_tabla(tabla_modif);
printf('\nCantidad de correcciones realizadas en cada paso:\n');
for i = 1:length(iteraciones)
  printf('  Paso %d (x=%.4g -> x=%.4g): %d correccion(es)\n', i, tabla_modif(i, 1), tabla_modif(i + 1, 1), iteraciones(i));
end
printf('>>> RESULTADO: y(%g) = %.6f (Euler Modificado)\n', x_final, tabla_modif(end, 2));

printf('\n============================================================\n');
printf('Diferencia |y_modif - y_euler| en x=%g: %.6f\n', x_final, abs(tabla_modif(end, 2) - tabla_euler(end, 2)));
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 1 - Euler vs Euler Modificado');
plot(tabla_euler(:, 1), tabla_euler(:, 2), 'b-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b'); hold on;
plot(tabla_modif(:, 1), tabla_modif(:, 2), 'r-s', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
xlabel('x'); ylabel('y');
legend('Metodo de Euler', 'Metodo Modificado de Euler', 'Location', 'best');
title("Solucion de y' = x^2 + y^2");
grid on;

1; % script con funciones locales

function yp = f_ejercicio5(x, y)
  % Misma ecuacion diferencial que en los ejercicios 1 y 3: y' = x^2 + y^2
  yp = x .^ 2 + y .^ 2;
end

function [y_nuevo, yp_nuevo, P_y] = paso_milne(x, y, yp, h, i)
  % Metodo de Milne (predictor-corrector), corrigiendo dos veces:
  % P(y_i+1) = y_i-3 + (4h/3)*(2*y'_i - y'_i-1 + 2*y'_i-2)
  % C(y_i+1) = y_i-1 + (h/3)*(y'_i-1 + 4*y'_i + P(y'_i+1))
  % Se aplica la correccion una vez mas, usando la derivada de C(y_i+1).
  x_nuevo = x(i + 1) + h;

  P_y = y(i - 2) + (4 * h / 3) * (2 * yp(i + 1) - yp(i) + 2 * yp(i - 1));
  P_yp = f_ejercicio5(x_nuevo, P_y);

  C_y = y(i) + (h / 3) * (yp(i) + 4 * yp(i + 1) + P_yp);
  C_yp = f_ejercicio5(x_nuevo, C_y);

  C1_y = y(i) + (h / 3) * (yp(i) + 4 * yp(i + 1) + C_yp);
  C1_yp = f_ejercicio5(x_nuevo, C1_y);

  y_nuevo = C1_y;
  yp_nuevo = C1_yp;
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 5: Metodo de Milne, a partir de la tabla obtenida en el
% ejercicio 3.a (Runge-Kutta de 2do orden)
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 5 - METODO DE MILNE');
disp('============================================================');
printf("\nEcuacion diferencial: y' = x^2 + y^2 (misma de los ejercicios 1 y 3)\n");
printf('Se completa la tabla con los resultados del ejercicio 3.a (Runge-Kutta de 2do orden)\n');
printf('y se aplica el Metodo de Milne para hallar y en x=0.8 y x=1.0.\n');

x = input('Ingrese el vector de x del ejercicio 3.a (ej: [0 0.2 0.4 0.6]): ');
y = input('Ingrese el vector de y del ejercicio 3.a (ej: [1 1.248 1.669456 2.510415]): ');
h = x(2) - x(1);
n = length(x);

yp = zeros(1, n);
for i = 1:n
  yp(i) = f_ejercicio5(x(i), y(i));
end

printf("\nTabla completa (x, y, y') a partir del ejercicio 3.a:\n");
printf('%6s %12s %12s %12s\n', 'i', 'x_i', 'y_i', "y'_i");
printf('-------------------------------------------------\n');
for i = 1:n
  printf('%6d %12.6f %12.6f %12.6f\n', i - 1, x(i), y(i), yp(i));
end

% --- a) Milne para x=0.8 (i=3, usa i-3..i = 0,1,2,3) ---
printf('\n>>> a) METODO DE MILNE: calculo de y en x=%.4g <<<\n', x(4) + h);
[y4, yp4, P_y4] = paso_milne(x, y, yp, h, 3);
x4 = x(4) + h;
printf('P(y4) = %.6f\n', P_y4);
printf('C(y4) = y2 + (h/3)*(y`_2 + 4*y`_3 + P(y`_4))\n');
printf('C^1(y4) [segunda correccion] = %.6f\n', y4);
printf('>>> RESULTADO: y(%.4g) = %.6f\n', x4, y4);

x = [x, x4]; y = [y, y4]; yp = [yp, yp4];
n = length(x);

% --- Milne para x=1.0 (i=4, usa i-3..i = 1,2,3,4) ---
printf('\n>>> a) METODO DE MILNE: calculo de y en x=%.4g <<<\n', x(5) + h);
[y5, yp5, P_y5] = paso_milne(x, y, yp, h, 4);
x5 = x(5) + h;
printf('P(y5) = %.6f\n', P_y5);
printf('C(y5) = y3 + (h/3)*(y`_3 + 4*y`_4 + P(y`_5))\n');
printf('C^1(y5) [segunda correccion] = %.6f\n', y5);
printf('>>> RESULTADO: y(%.4g) = %.6f\n', x5, y5);

x = [x, x5]; y = [y, y5]; yp = [yp, yp5];
n = length(x);

printf('\n============================================================\n');
printf('Tabla final (ejercicio 3.a + Metodo de Milne):\n');
printf('%6s %12s %12s %12s\n', 'i', 'x_i', 'y_i', "y'_i");
printf('-------------------------------------------------\n');
for i = 1:n
  printf('%6d %12.6f %12.6f %12.6f\n', i - 1, x(i), y(i), yp(i));
end
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 5 - Metodo de Milne');
plot(x(1:4), y(1:4), 'b-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b'); hold on;
plot(x(4:6), y(4:6), 'r-s', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
xlabel('x'); ylabel('y');
legend('Datos de partida (Runge-Kutta 2do orden, ej. 3.a)', 'Metodo de Milne', 'Location', 'best');
title("Metodo de Milne para y' = x^2 + y^2");
grid on;

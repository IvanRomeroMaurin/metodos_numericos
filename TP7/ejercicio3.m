1; % script con funciones locales

function yp = f_ejercicio3(x, y)
  % Misma ecuacion diferencial que en el ejercicio 1: y' = x^2 + y^2
  yp = x .^ 2 + y .^ 2;
end

function tabla = runge_kutta_2(x0, y0, h, n_pasos)
  % Metodo de Runge-Kutta de 2do orden:
  % k1 = h*f(x_i, y_i)
  % k2 = h*f(x_i+h, y_i+k1)
  % y_{i+1} = y_i + (1/2)*(k1+k2)
  tabla = zeros(n_pasos + 1, 4); % columnas: x, y, k1, k2
  x = x0; y = y0;
  tabla(1, :) = [x, y, NaN, NaN];
  for i = 1:n_pasos
    k1 = h * f_ejercicio3(x, y);
    k2 = h * f_ejercicio3(x + h, y + k1);
    y = y + 0.5 * (k1 + k2);
    x = x + h;
    tabla(i + 1, :) = [x, y, k1, k2];
  end
end

function tabla = runge_kutta_4(x0, y0, h, n_pasos)
  % Metodo de Runge-Kutta de 4to orden:
  % k1 = h*f(x_i, y_i)
  % k2 = h*f(x_i+h/2, y_i+k1/2)
  % k3 = h*f(x_i+h/2, y_i+k2/2)
  % k4 = h*f(x_i+h, y_i+k3)
  % y_{i+1} = y_i + (1/6)*(k1+2*k2+2*k3+k4)
  tabla = zeros(n_pasos + 1, 5); % columnas: x, y, k1, k2, k3, k4 (se guardan 5: x,y y 3 extra se imprimen aparte)
  x = x0; y = y0;
  tabla(1, :) = [x, y, NaN, NaN, NaN];
  for i = 1:n_pasos
    k1 = h * f_ejercicio3(x, y);
    k2 = h * f_ejercicio3(x + h / 2, y + k1 / 2);
    k3 = h * f_ejercicio3(x + h / 2, y + k2 / 2);
    k4 = h * f_ejercicio3(x + h, y + k3);
    y = y + (1 / 6) * (k1 + 2 * k2 + 2 * k3 + k4);
    x = x + h;
    tabla(i + 1, :) = [x, y, k1, k2, k4];
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 3: y' = x^2 + y^2 ; Runge-Kutta de 2do y 4to orden
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 3 - METODO DE RUNGE-KUTTA DE 2DO Y 4TO ORDEN');
disp('============================================================');
printf("\nEcuacion diferencial: y' = x^2 + y^2 (misma del ejercicio 1)\n");

x0 = input('Ingrese x0 (ej: 0): ');
y0 = input('Ingrese y0 (ej: 1): ');
h = input('Ingrese el paso h (ej: 0.2): ');
x_final = input('Ingrese el extremo final del intervalo (ej: 0.6): ');

n_pasos = round((x_final - x0) / h);

% --- a) Runge-Kutta de 2do orden ---
printf('\n>>> a) RUNGE-KUTTA DE 2DO ORDEN en (%g ; %g) con h=%g <<<\n', x0, x_final, h);
tabla_rk2 = runge_kutta_2(x0, y0, h, n_pasos);
printf('%6s %12s %12s %12s %12s\n', 'i', 'x_i', 'y_i', 'k1', 'k2');
printf('-----------------------------------------------------------\n');
for i = 1:size(tabla_rk2, 1)
  if i == 1
    printf('%6d %12.6f %12.6f %12s %12s\n', i - 1, tabla_rk2(i, 1), tabla_rk2(i, 2), '-', '-');
  else
    printf('%6d %12.6f %12.6f %12.6f %12.6f\n', i - 1, tabla_rk2(i, 1), tabla_rk2(i, 2), tabla_rk2(i, 3), tabla_rk2(i, 4));
  end
end
printf('>>> RESULTADO: y(%g) = %.6f (Runge-Kutta 2do orden)\n', x_final, tabla_rk2(end, 2));

% --- b) Runge-Kutta de 4to orden ---
printf('\n>>> b) RUNGE-KUTTA DE 4TO ORDEN en (%g ; %g) con h=%g <<<\n', x0, x_final, h);
tabla_rk4 = runge_kutta_4(x0, y0, h, n_pasos);
printf('%6s %12s %12s %12s %12s %12s\n', 'i', 'x_i', 'y_i', 'k1', 'k2/k3', 'k4');
printf('-------------------------------------------------------------------------\n');
for i = 1:size(tabla_rk4, 1)
  if i == 1
    printf('%6d %12.6f %12.6f %12s %12s %12s\n', i - 1, tabla_rk4(i, 1), tabla_rk4(i, 2), '-', '-', '-');
  else
    printf('%6d %12.6f %12.6f %12.6f %12.6f %12.6f\n', i - 1, tabla_rk4(i, 1), tabla_rk4(i, 2), tabla_rk4(i, 3), tabla_rk4(i, 4), tabla_rk4(i, 5));
  end
end
printf('>>> RESULTADO: y(%g) = %.6f (Runge-Kutta 4to orden)\n', x_final, tabla_rk4(end, 2));

% --- c) Comparacion de 3.a (RK2) con 1.b (Euler Modificado) ---
printf('\n>>> c) COMPARACION ENTRE RUNGE-KUTTA 2DO ORDEN Y EULER MODIFICADO (ejercicio 1.b) <<<\n');
E_modif = input('Ingrese la cota de error E usada en el Metodo Modificado de Euler del ejercicio 1 (ej: 0.001): ');
tabla_euler_modif = zeros(n_pasos + 1, 3);
x = x0; y = y0;
yp = f_ejercicio3(x, y);
tabla_euler_modif(1, :) = [x, y, yp];
for i = 1:n_pasos
  x_sig = x + h;
  P_y = y + yp * h;
  P_yp = f_ejercicio3(x_sig, P_y);
  C_y = y + ((yp + P_yp) / 2) * h;
  C_yp = f_ejercicio3(x_sig, C_y);
  iter_c = 1;
  while abs(C_y - P_y) >= E_modif
    P_y = C_y;
    P_yp = C_yp;
    C_y = y + ((yp + P_yp) / 2) * h;
    C_yp = f_ejercicio3(x_sig, C_y);
    iter_c = iter_c + 1;
    if iter_c > 100
      break;
    end
  end
  x = x_sig; y = C_y; yp = C_yp;
  tabla_euler_modif(i + 1, :) = [x, y, yp];
end
printf('%6s %12s %16s %18s %14s\n', 'i', 'x_i', 'y_i (RK 2do ord.)', 'y_i (Euler modif.)', 'Dif. abs.');
printf('------------------------------------------------------------------------\n');
for i = 1:size(tabla_rk2, 1)
  printf('%6d %12.6f %16.6f %18.6f %14.6f\n', i - 1, tabla_rk2(i, 1), tabla_rk2(i, 2), tabla_euler_modif(i, 2), ...
    abs(tabla_rk2(i, 2) - tabla_euler_modif(i, 2)));
end
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 3 - Runge-Kutta 2do y 4to orden');
plot(tabla_rk2(:, 1), tabla_rk2(:, 2), 'b-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b'); hold on;
plot(tabla_rk4(:, 1), tabla_rk4(:, 2), 'g-^', 'LineWidth', 1.5, 'MarkerFaceColor', 'g');
plot(tabla_euler_modif(:, 1), tabla_euler_modif(:, 2), 'r-s', 'LineWidth', 1.2, 'MarkerFaceColor', 'r');
xlabel('x'); ylabel('y');
legend('Runge-Kutta 2do orden', 'Runge-Kutta 4to orden', 'Euler Modificado (ej. 1.b)', 'Location', 'best');
title("Solucion de y' = x^2 + y^2");
grid on;

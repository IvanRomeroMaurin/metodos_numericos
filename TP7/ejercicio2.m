1; % script con funciones locales

function Pp = f_ejercicio2(t, P, gamma, tau)
  % Ecuacion diferencial del crecimiento poblacional: P' = gamma*P - tau*P^2
  Pp = gamma .* P - tau .* P .^ 2;
end

function P_exacta = solucion_exacta_ejercicio2(t, gamma, tau, P0)
  % Solucion exacta: P(t) = gamma / (tau + (gamma/P0 - tau) * exp(-gamma*t))
  P_exacta = gamma ./ (tau + (gamma / P0 - tau) .* exp(-gamma .* t));
end

function tabla = metodo_euler_poblacion(t0, P0, h, n_pasos, gamma, tau)
  % Metodo de Euler: t_{i+1}=t_i+h ; P_{i+1}=P_i+P'_i*h
  tabla = zeros(n_pasos + 1, 3); % columnas: t, P, P'
  t = t0; P = P0;
  for i = 0:n_pasos
    Pp = f_ejercicio2(t, P, gamma, tau);
    tabla(i + 1, :) = [t, P, Pp];
    if i < n_pasos
      P = P + Pp * h;
      t = t + h;
    end
  end
end

function imprimir_tabla(tabla, P_exacta)
  printf('%6s %10s %12s %12s %14s %12s\n', 'i', 't_i', 'P_i', "P'_i", 'P_i (exacta)', 'Error abs.');
  printf('---------------------------------------------------------------------\n');
  for i = 1:size(tabla, 1)
    printf('%6d %10.4f %12.6f %12.6f %14.6f %12.6f\n', i - 1, tabla(i, 1), tabla(i, 2), tabla(i, 3), ...
      P_exacta(i), abs(tabla(i, 2) - P_exacta(i)));
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 2: crecimiento poblacional P' = gamma*P - tau*P^2
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 2 - CRECIMIENTO POBLACIONAL (METODO DE EULER)');
disp('============================================================');
printf("\nEcuacion diferencial: P'(t) = gamma*P(t) - tau*P(t)^2\n");

gamma = input('Ingrese la tasa de nacimiento gamma (ej: 3): ');
tau = input('Ingrese la mortalidad tau (ej: 0.1): ');
P0 = input('Ingrese la poblacion inicial P0 (ej: 5): ');
t0 = input('Ingrese t0 (ej: 0): ');
t_final = input('Ingrese el extremo final del intervalo (ej: 2): ');

% --- a) Metodo de Euler con h=0.5 ---
h1 = 0.5;
n1 = round((t_final - t0) / h1);
tabla_h1 = metodo_euler_poblacion(t0, P0, h1, n1, gamma, tau);
P_exacta_h1 = solucion_exacta_ejercicio2(tabla_h1(:, 1), gamma, tau, P0);
printf('\n>>> a) METODO DE EULER en (%g ; %g) con h=%g <<<\n', t0, t_final, h1);
imprimir_tabla(tabla_h1, P_exacta_h1);
printf('>>> RESULTADO: P(%g) = %.6f (h=%g)\n', t_final, tabla_h1(end, 2), h1);

% --- a) Metodo de Euler con h=0.25 ---
h2 = 0.25;
n2 = round((t_final - t0) / h2);
tabla_h2 = metodo_euler_poblacion(t0, P0, h2, n2, gamma, tau);
P_exacta_h2 = solucion_exacta_ejercicio2(tabla_h2(:, 1), gamma, tau, P0);
printf('\n>>> a) METODO DE EULER en (%g ; %g) con h=%g <<<\n', t0, t_final, h2);
imprimir_tabla(tabla_h2, P_exacta_h2);
printf('>>> RESULTADO: P(%g) = %.6f (h=%g)\n', t_final, tabla_h2(end, 2), h2);

% --- b) Comparacion con la solucion exacta ---
printf('\n>>> b) COMPARACION CON LA SOLUCION EXACTA EN t=%g <<<\n', t_final);
P_exacta_final = solucion_exacta_ejercicio2(t_final, gamma, tau, P0);
printf('P(%g) exacta             = %.6f\n', t_final, P_exacta_final);
printf('P(%g) Euler h=%-5g       = %.6f   |  Error abs. = %.6f\n', t_final, h1, tabla_h1(end, 2), abs(tabla_h1(end, 2) - P_exacta_final));
printf('P(%g) Euler h=%-5g       = %.6f   |  Error abs. = %.6f\n', t_final, h2, tabla_h2(end, 2), abs(tabla_h2(end, 2) - P_exacta_final));
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 2 - Crecimiento poblacional');
t_fino = linspace(t0, t_final, 200);
P_fino = solucion_exacta_ejercicio2(t_fino, gamma, tau, P0);
plot(t_fino, P_fino, 'k-', 'LineWidth', 1.5); hold on;
plot(tabla_h1(:, 1), tabla_h1(:, 2), 'b-o', 'LineWidth', 1.2, 'MarkerFaceColor', 'b');
plot(tabla_h2(:, 1), tabla_h2(:, 2), 'r-s', 'LineWidth', 1.2, 'MarkerFaceColor', 'r');
xlabel('t'); ylabel('P(t)');
legend('Solucion exacta', sprintf('Euler h=%g', h1), sprintf('Euler h=%g', h2), 'Location', 'best');
title('Crecimiento poblacional: P` = \gamma P - \tau P^2');
grid on;

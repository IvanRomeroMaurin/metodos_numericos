1; % script con funciones locales

function yp = f_ejercicio4(y, k)
  % Ecuacion diferencial: dy/dt = -k*sqrt(y)  (nivel de agua en el tanque)
  yp = -k * sqrt(max(y, 0));
end

function t_exacto = tiempo_vaciado_exacto(y0, k)
  % Solucion exacta (variables separables): 2*sqrt(y) = 2*sqrt(y0) - k*t
  % El tanque se vacia (y=0) en t = 2*sqrt(y0)/k
  t_exacto = 2 * sqrt(y0) / k;
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 4 (complementario): vaciado de un tanque cilindrico
% dy/dt = -k*sqrt(y) ; Metodo de Euler
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 4 - VACIADO DE UN TANQUE (METODO DE EULER)');
disp('============================================================');
printf('\nEcuacion diferencial: dy/dt = -k*sqrt(y)\n');

k = input('Ingrese la constante k (ej: 0.06): ');
y0 = input('Ingrese el nivel inicial del tanque y0, en metros (ej: 3): ');
h = input('Ingrese el paso h, en minutos (ej: 0.5): ');

t = 0; y = y0;
t_vals = t; y_vals = y; yp_vals = f_ejercicio4(y, k);
t_vaciado = NaN;
max_pasos = 10000;
paso = 0;
while y > 1e-9 && paso < max_pasos
  yp = f_ejercicio4(y, k);
  y_siguiente = y + yp * h;
  if y_siguiente <= 0
    % El tanque se vacia dentro de este paso: se estima el instante
    % de cruce suponiendo la tasa de variacion constante en el tramo.
    t_vaciado = t + y / abs(yp);
    y = 0; t = t + h;
    t_vals(end + 1) = t; y_vals(end + 1) = y; yp_vals(end + 1) = 0;
    break;
  end
  y = y_siguiente;
  t = t + h;
  t_vals(end + 1) = t; y_vals(end + 1) = y; yp_vals(end + 1) = f_ejercicio4(y, k);
  paso = paso + 1;
end

printf('\n>>> a) METODO DE EULER con h=%g minutos <<<\n', h);
printf('%6s %12s %12s %14s\n', 'i', 't_i (min)', 'y_i (m)', "y'_i (m/min)");
printf('-----------------------------------------------------\n');
for i = 1:length(t_vals)
  printf('%6d %12.4f %12.6f %14.6f\n', i - 1, t_vals(i), y_vals(i), yp_vals(i));
end

t_exacto = tiempo_vaciado_exacto(y0, k);
printf('\n============================================================\n');
printf('>>> RESULTADO: tiempo estimado de vaciado (Euler) = %.4f minutos\n', t_vaciado);
printf('>>> Tiempo de vaciado segun la solucion exacta     = %.4f minutos\n', t_exacto);
printf('>>> Error absoluto                                 = %.4f minutos\n', abs(t_vaciado - t_exacto));
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 4 - Vaciado del tanque');
t_fino = linspace(0, t_exacto, 200);
y_fino = max((sqrt(y0) - (k / 2) * t_fino) .^ 2, 0);
plot(t_fino, y_fino, 'k-', 'LineWidth', 1.5); hold on;
plot(t_vals, y_vals, 'b-o', 'LineWidth', 1.2, 'MarkerFaceColor', 'b');
plot(t_vaciado, 0, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 9);
xlabel('t (min)'); ylabel('y (m)');
legend('Solucion exacta', 'Metodo de Euler', sprintf('Vaciado estimado t=%.2f min', t_vaciado), 'Location', 'best');
title('Vaciado de un tanque cilindrico: dy/dt = -k sqrt(y)');
grid on;

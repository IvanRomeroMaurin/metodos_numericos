1; % script con funciones locales

function [y_eval, L] = interpolacion_lagrange(x_nodos, y_nodos, x_eval)
  % P_n(x) = suma y_i * L_i(x),  L_i(x) = prod_{j~=i} (x-x_j)/(x_i-x_j)
  n = length(x_nodos);
  L = zeros(n, 1);
  y_eval = 0;
  for i = 1:n
    numerador = 1.0;
    denominador = 1.0;
    for j = 1:n
      if j ~= i
        numerador = numerador * (x_eval - x_nodos(j));
        denominador = denominador * (x_nodos(i) - x_nodos(j));
      end
    end
    L(i) = numerador / denominador;
    y_eval = y_eval + y_nodos(i) * L(i);
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 2: interpolacion de Lagrange aplicada al censo de EE.UU.
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 2 - INTERPOLACION DE LAGRANGE (CENSO DE POBLACION)');
disp('============================================================');

anios = input("\nIngrese el vector de anios censales (ej: [1940 1950 1960 1970 1980 1990]): ");
poblacion = input('Ingrese el vector de poblacion en miles de habitantes (ej: [132165 151326 179323 203302 226542 249633]): ');
anio_objetivo = input('Ingrese el anio a interpolar (ej: 1965): ');

tic;
[pob_interp, L] = interpolacion_lagrange(anios, poblacion, anio_objetivo);
tiempo_proceso = toc;

printf('\n>>> Contribucion de cada nodo (Li(%g)) <<<\n', anio_objetivo);
printf('%6s %8s %14s %10s %16s\n', 'Nodo', 'Anio', 'Poblacion', 'L_i', 'y_i * L_i');
for i = 1:length(anios)
  printf('%6d %8d %14.3f %10.6f %16.3f\n', i - 1, anios(i), poblacion(i), L(i), poblacion(i) * L(i));
end

printf('\n============================================================\n');
printf(' RESULTADOS OBTENIDOS\n');
printf('============================================================\n');
printf(' -> Poblacion interpolada en %d: %.3f miles de habitantes (%.0f hab.)\n', anio_objetivo, pob_interp, pob_interp * 1000);

poblacion_real = input("\nIngrese la poblacion real conocida en miles (ej: 189703, Enter para omitir): ");
if ~isempty(poblacion_real)
  error_absoluto = abs(poblacion_real - pob_interp);
  error_relativo = error_absoluto / poblacion_real * 100;
  printf(' -> Poblacion real              : %.3f miles de habitantes\n', poblacion_real);
  printf(' -> Error absoluto              : %.3f miles de habitantes\n', error_absoluto);
  printf(' -> Error relativo porcentual   : %.4f %%\n', error_relativo);
end
printf(' -> Tiempo de proceso: %.6f segundos\n', tiempo_proceso);
printf('============================================================\n');

figure('Name', 'Ejercicio 2 - Censo de poblacion');
x_fino = linspace(min(anios), max(anios), 200);
y_fino = zeros(size(x_fino));
for k = 1:length(x_fino)
  y_fino(k) = interpolacion_lagrange(anios, poblacion, x_fino(k));
end
plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5); hold on;
plot(anios, poblacion, 'ko', 'MarkerFaceColor', 'k');
plot(anio_objetivo, pob_interp, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 9);
if ~isempty(poblacion_real)
  plot(anio_objetivo, poblacion_real, 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', 9);
  legend('Polinomio de Lagrange', 'Censos oficiales', 'Lagrange (interpolado)', 'Valor real', 'Location', 'best');
else
  legend('Polinomio de Lagrange', 'Censos oficiales', 'Lagrange (interpolado)', 'Location', 'best');
end
xlabel('Anio'); ylabel('Poblacion [miles de habitantes]');
title('Censo de poblacion de EE.UU. e interpolacion de Lagrange');
grid on;

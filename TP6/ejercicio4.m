1; % script con funciones locales

function area = trapecio_compuesto(x, y)
  n = length(x);
  h = x(2) - x(1);
  area = (h / 2) * (y(1) + y(n) + 2 * sum(y(2:n-1)));
end

function area = simpson_un_tercio(x, y)
  n = length(x);
  if mod(n - 1, 2) ~= 0
    error('Simpson 1/3 requiere una cantidad par de intervalos.');
  end
  h = x(2) - x(1);
  extremos = y(1) + y(n);
  impares = sum(y(2:2:n-1));
  pares = sum(y(3:2:n-1));
  area = (h / 3) * (extremos + 4 * impares + 2 * pares);
end

function area = simpson_tres_octavos(x, y)
  % Regla de Simpson 3/8: A = (3h/8) * [y0 + 3y1 + 3y2 + y3]. Requiere exactamente 3 intervalos.
  n = length(x);
  if n ~= 4
    error('Simpson 3/8 requiere exactamente 3 intervalos (4 puntos).');
  end
  h = x(2) - x(1);
  area = (3 * h / 8) * (y(1) + 3 * y(2) + 3 * y(3) + y(4));
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 4: misma integral del ejercicio 3, combinando las dos formulas
% de Simpson (3/8 en los primeros 3 intervalos + 1/3 en los restantes, que
% deben sumar una cantidad par). Se recalculan ambos casos para comparar.
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 4 - INTEGRAL COMBINANDO SIMPSON 1/3 Y SIMPSON 3/8');
disp('============================================================');

x_datos = input("\nIngrese el vector de x equidistantes (ej: [12 13 14 15 16 17]): ");
y_datos = input('Ingrese el vector de y = f(x) (ej: [0.96262 0.94718 0.93108 0.92221 0.91181 0.90151]): ');
h = x_datos(2) - x_datos(1);
n_intervalos = length(x_datos) - 1;
printf('\nPaso h = %g,  cantidad de intervalos = %d\n', h, n_intervalos);

if mod(n_intervalos, 3) ~= 0 && mod(n_intervalos - 3, 2) ~= 0
  error('Esta combinacion necesita poder separar 3 intervalos (Simpson 3/8) y que el resto sea par (Simpson 1/3).');
end

% --- a) Metodo del ejercicio anterior: Simpson 1/3 (tramo par) + Trapecio (resto) ---
printf('\n>>> a) Metodo del ejercicio anterior (Simpson 1/3 + Trapecio en el resto) <<<\n');
n_par = n_intervalos - mod(n_intervalos, 2);
indices_pares = 1:(n_par + 1);
area_simpson13_previo = simpson_un_tercio(x_datos(indices_pares), y_datos(indices_pares));
if n_par < n_intervalos
  area_trapecio_resto = trapecio_compuesto(x_datos(n_par+1:end), y_datos(n_par+1:end));
else
  area_trapecio_resto = 0;
end
area_metodo_anterior = area_simpson13_previo + area_trapecio_resto;
printf('  Simpson 1/3 (intervalos [0..%d])            -> A = %.6f\n', n_par, area_simpson13_previo);
if n_par < n_intervalos
  printf('  Trapecio    (intervalo  [%d..%d])             -> A = %.6f\n', n_par, n_intervalos, area_trapecio_resto);
end
printf('>>> RESULTADO (metodo anterior): Integral aproximada = %.6f\n', area_metodo_anterior);

% --- b) Combinacion de las dos formulas de Simpson: 3/8 (3 intervalos) + 1/3 (el resto, par) ---
printf('\n>>> b) Combinacion de Simpson 3/8 (primeros 3 intervalos) y Simpson 1/3 (el resto) <<<\n');
x_tramo1 = x_datos(1:4);
y_tramo1 = y_datos(1:4);
area_simpson38 = simpson_tres_octavos(x_tramo1, y_tramo1);
printf('  Simpson 3/8 (intervalos [0..3], x=%g a %g)   -> A = %.6f\n', x_tramo1(1), x_tramo1(end), area_simpson38);

x_tramo2 = x_datos(4:end);
y_tramo2 = y_datos(4:end);
area_simpson13_resto = simpson_un_tercio(x_tramo2, y_tramo2);
printf('  Simpson 1/3 (intervalos [3..%d], x=%g a %g)  -> A = %.6f\n', n_intervalos, x_tramo2(1), x_tramo2(end), area_simpson13_resto);

area_combinada = area_simpson38 + area_simpson13_resto;
printf('>>> RESULTADO (combinada): Integral aproximada = %.6f\n', area_combinada);

printf('\n============================================================\n');
printf(' COMPARACION DE AMBOS CASOS\n');
printf('============================================================\n');
printf(' -> Metodo del ejercicio anterior (Simpson 1/3 + Trapecio): %.6f\n', area_metodo_anterior);
printf(' -> Combinacion de las dos formulas de Simpson (3/8 + 1/3): %.6f\n', area_combinada);
printf(' -> Diferencia entre ambos resultados                     : %.6f\n', abs(area_metodo_anterior - area_combinada));
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 4 - Combinacion de formulas de Simpson');
x_fino = linspace(x_datos(1), x_datos(end), 200);
y_fino = interp1(x_datos, y_datos, x_fino, 'spline');
plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5); hold on;
plot(x_datos, y_datos, 'ko', 'MarkerFaceColor', 'k');
xline_x = x_datos(4) * ones(1, 2);
plot(xline_x, ylim(), 'r--', 'LineWidth', 1);
xlabel('x'); ylabel('y');
legend('f(x) interpolada', 'Datos', 'Division Simpson 3/8 | Simpson 1/3', 'Location', 'best');
title(sprintf('Metodo anterior = %.6f   |   Combinada (3/8+1/3) = %.6f', area_metodo_anterior, area_combinada));
grid on;

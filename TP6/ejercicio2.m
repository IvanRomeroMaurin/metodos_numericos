1; % script con funciones locales

function area = trapecio_compuesto(x, y)
  % Regla de los Trapecios compuesta: A = h/2 * [(y0+yn) + 2*suma(interiores)]
  n = length(x);
  h = x(2) - x(1);
  area = (h / 2) * (y(1) + y(n) + 2 * sum(y(2:n-1)));
end

function area = simpson_un_tercio(x, y)
  % Regla de Simpson 1/3: A = h/3 * [E + 4*I + 2*P], con E=extremos,
  % I=suma de ordenadas impares interiores, P=suma de ordenadas pares interiores.
  % Requiere una cantidad PAR de intervalos (cantidad IMPAR de puntos).
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
  % Regla de Simpson 3/8: A = (3h/8) * [y0 + 3y1 + 3y2 + y3]. Requiere exactamente 3 intervalos (4 puntos).
  n = length(x);
  if n ~= 4
    error('Simpson 3/8 requiere exactamente 3 intervalos (4 puntos).');
  end
  h = x(2) - x(1);
  area = (3 * h / 8) * (y(1) + 3 * y(2) + 3 * y(3) + y(4));
end

function [area_total, detalle] = integral_combinada(x, y)
  % Combina Simpson 3/8 (bloques de 3 intervalos) y Simpson 1/3 (bloques de
  % 2 intervalos) para aprovechar todos los datos de la tabla; si sobra un
  % unico intervalo suelto, ese tramo final se resuelve con Trapecios.
  n_intervalos = length(x) - 1;
  bloques = [];
  restante = n_intervalos;
  % Se prioriza dejar un resto par (multiplo de 2) usando bloques de a 3.
  while restante > 0
    if restante == 1
      bloques(end + 1) = 1; % trapecio para el ultimo intervalo suelto
      restante = 0;
    elseif mod(restante, 2) == 0
      bloques(end + 1) = 2;
      restante = restante - 2;
    else
      bloques(end + 1) = 3;
      restante = restante - 3;
    end
  end

  area_total = 0;
  detalle = {};
  indice_inicio = 1;
  for k = 1:length(bloques)
    tamanio = bloques(k);
    indice_fin = indice_inicio + tamanio;
    x_bloque = x(indice_inicio:indice_fin);
    y_bloque = y(indice_inicio:indice_fin);
    if tamanio == 3
      area_bloque = simpson_tres_octavos(x_bloque, y_bloque);
      metodo = 'Simpson 3/8';
    elseif tamanio == 2
      area_bloque = simpson_un_tercio(x_bloque, y_bloque);
      metodo = 'Simpson 1/3';
    else
      area_bloque = trapecio_compuesto(x_bloque, y_bloque);
      metodo = 'Trapecio (resto)';
    end
    detalle{end + 1} = sprintf('%-16s intervalos [%d..%d] (x=%g a %g) -> A = %.6f', ...
      metodo, indice_inicio - 1, indice_fin - 1, x_bloque(1), x_bloque(end), area_bloque);
    area_total = area_total + area_bloque;
    indice_inicio = indice_fin;
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 2: integracion numerica combinando Trapecios y Simpson
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 2 - INTEGRACION NUMERICA (TRAPECIOS Y SIMPSON)');
disp('============================================================');

x_datos = input("\nIngrese el vector de x equidistantes (ej: [0 0.1 0.2 0.3 0.4 0.5]): ");
y_datos = input('Ingrese el vector de y = f(x) (ej: [0.0 0.15 0.3 0.55 0.73 0.81]): ');
h = x_datos(2) - x_datos(1);
n_intervalos = length(x_datos) - 1;
printf('\nPaso h = %g,  cantidad de intervalos = %d\n', h, n_intervalos);

% --- a) Trapecios (siempre aplicable, sirve de referencia) ---
area_trapecio = trapecio_compuesto(x_datos, y_datos);
printf('\n>>> a) Regla de los Trapecios (todos los intervalos) <<<\n');
printf('>>> RESULTADO: Integral aproximada = %.6f\n', area_trapecio);

% --- b) Simpson 1/3 puro, si la cantidad de intervalos es par ---
if mod(n_intervalos, 2) == 0
  area_simpson13 = simpson_un_tercio(x_datos, y_datos);
  printf('\n>>> b) Regla de Simpson 1/3 (todos los intervalos, cantidad par) <<<\n');
  printf('>>> RESULTADO: Integral aproximada = %.6f\n', area_simpson13);
else
  printf('\n>>> b) Simpson 1/3 puro no aplica: la cantidad de intervalos (%d) es impar <<<\n', n_intervalos);
end

% --- c) Combinacion de formulas para aprovechar todos los datos ---
printf('\n>>> c) Combinacion de formulas (Simpson 3/8 + Simpson 1/3, segun corresponda) <<<\n');
[area_combinada, detalle] = integral_combinada(x_datos, y_datos);
for i = 1:length(detalle)
  printf('  %s\n', detalle{i});
end
printf('>>> RESULTADO: Integral aproximada (combinada) = %.6f\n', area_combinada);

printf('\n============================================================\n');
printf(' COMPARACION DE METODOS\n');
printf('============================================================\n');
printf(' -> Trapecios (todos los intervalos) : %.6f\n', area_trapecio);
printf(' -> Combinacion de formulas de Simpson: %.6f\n', area_combinada);
printf(' -> Diferencia entre ambos resultados : %.6f\n', abs(area_trapecio - area_combinada));
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 2 - Integracion numerica');
x_fino = linspace(x_datos(1), x_datos(end), 200);
y_fino = interp1(x_datos, y_datos, x_fino, 'spline');
area(x_fino, y_fino, 'FaceColor', [0.8 0.9 1]); hold on;
plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5);
plot(x_datos, y_datos, 'ko', 'MarkerFaceColor', 'k');
xlabel('t'); ylabel('i(t)');
legend('Area aproximada', 'f(x) interpolada', 'Datos', 'Location', 'best');
title(sprintf('Integracion combinada: A = %.6f', area_combinada));
grid on;

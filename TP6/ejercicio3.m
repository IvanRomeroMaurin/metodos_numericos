1; % script con funciones locales

function area = trapecio_compuesto(x, y)
  % Regla de los Trapecios compuesta: A = h/2 * [(y0+yn) + 2*suma(interiores)]
  n = length(x);
  h = x(2) - x(1);
  area = (h / 2) * (y(1) + y(n) + 2 * sum(y(2:n-1)));
end

function area = simpson_un_tercio(x, y)
  % Regla de Simpson 1/3: A = h/3 * [E + 4*I + 2*P]. Requiere una cantidad
  % PAR de intervalos (cantidad IMPAR de puntos).
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

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 3: con la misma tabla del ejercicio 1, calcular la integral
% seleccionando adecuadamente entre Trapecios y Simpson. Si la cantidad
% de intervalos es impar, se usa Simpson 1/3 en el mayor tramo par posible
% y Trapecios en el unico intervalo que queda suelto.
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 3 - INTEGRACION SELECCIONANDO TRAPECIO O SIMPSON');
disp('============================================================');

x_datos = input("\nIngrese el vector de x equidistantes (ej: [12 13 14 15 16 17]): ");
y_datos = input('Ingrese el vector de y = f(x) (ej: [0.96262 0.94718 0.93108 0.92221 0.91181 0.90151]): ');
h = x_datos(2) - x_datos(1);
n_intervalos = length(x_datos) - 1;
printf('\nPaso h = %g,  cantidad de intervalos = %d\n', h, n_intervalos);

% --- a) Trapecios en todo el intervalo (referencia) ---
area_trapecio_total = trapecio_compuesto(x_datos, y_datos);
printf('\n>>> a) Regla de los Trapecios (todos los intervalos, de referencia) <<<\n');
printf('>>> RESULTADO: Integral aproximada = %.6f\n', area_trapecio_total);

% --- b) Seleccion adecuada: Simpson 1/3 en el mayor tramo par + Trapecio en lo que sobra ---
printf('\n>>> b) Seleccion adecuada de formulas <<<\n');
if mod(n_intervalos, 2) == 0
  area_seleccionada = simpson_un_tercio(x_datos, y_datos);
  printf('  La cantidad de intervalos es PAR: se aplica Simpson 1/3 a toda la tabla.\n');
  printf('  Simpson 1/3 (intervalos [0..%d])           -> A = %.6f\n', n_intervalos, area_seleccionada);
else
  n_par = n_intervalos - 1;
  indices_pares = 1:(n_par + 1);
  area_simpson = simpson_un_tercio(x_datos(indices_pares), y_datos(indices_pares));
  area_trapecio_resto = trapecio_compuesto(x_datos(n_par+1:end), y_datos(n_par+1:end));
  area_seleccionada = area_simpson + area_trapecio_resto;
  printf('  La cantidad de intervalos es IMPAR: se aplica Simpson 1/3 a los primeros\n');
  printf('  %d intervalos (cantidad par) y Trapecio al ultimo intervalo que sobra.\n', n_par);
  printf('  Simpson 1/3   (intervalos [0..%d], x=%g a %g) -> A = %.6f\n', ...
    n_par, x_datos(1), x_datos(n_par+1), area_simpson);
  printf('  Trapecio      (intervalo  [%d..%d], x=%g a %g) -> A = %.6f\n', ...
    n_par, n_intervalos, x_datos(n_par+1), x_datos(end), area_trapecio_resto);
end
printf('>>> RESULTADO: Integral aproximada (seleccion adecuada) = %.6f\n', area_seleccionada);

printf('\n============================================================\n');
printf(' COMPARACION DE METODOS\n');
printf('============================================================\n');
printf(' -> Trapecios (todos los intervalos)  : %.6f\n', area_trapecio_total);
printf(' -> Seleccion adecuada (Simpson+Trap.) : %.6f\n', area_seleccionada);
printf(' -> Diferencia entre ambos resultados  : %.6f\n', abs(area_trapecio_total - area_seleccionada));
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 3 - Integral con seleccion de formula');
x_fino = linspace(x_datos(1), x_datos(end), 200);
y_fino = interp1(x_datos, y_datos, x_fino, 'spline');
area(x_fino, y_fino, 'FaceColor', [0.85 1 0.85]); hold on;
plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5);
plot(x_datos, y_datos, 'ko', 'MarkerFaceColor', 'k');
xlabel('x'); ylabel('y');
legend('Area aproximada', 'f(x) interpolada', 'Datos', 'Location', 'best');
title(sprintf('Integral [%g,%g]: A = %.6f', x_datos(1), x_datos(end), area_seleccionada));
grid on;

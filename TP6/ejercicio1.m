1; % script con funciones locales

function D = calcular_tabla_diferencias(y)
  % Construye la tabla de diferencias finitas hacia adelante (Delta^k y_i).
  n = length(y);
  D = zeros(n, n);
  D(:, 1) = y(:);
  for j = 2:n
    for i = 1:(n - j + 1)
      D(i, j) = D(i + 1, j - 1) - D(i, j - 1);
    end
  end
end

function [derivada, terminos] = derivada_primera_ascendente_extremo(D, h)
  % Formula de la catedra en u=0 (apoyada en x0):
  % h*f'(x0) = Delta y0 - (1/2) Delta^2 y0 + (1/3) Delta^3 y0 - (1/4) Delta^4 y0 + ...
  n = size(D, 1);
  % La catedra trabaja esta serie hasta el termino de orden 4 (el mismo
  % limite que usa en la formula general para u arbitrario).
  orden_maximo = min(4, n - 1);
  terminos = zeros(orden_maximo, 1);
  suma = 0;
  for k = 1:orden_maximo
    delta_k_y0 = D(1, k + 1);
    termino = ((-1) ^ (k + 1) / k) * delta_k_y0;
    terminos(k) = termino;
    suma = suma + termino;
  end
  derivada = suma / h;
end

function [derivada, terminos] = derivada_primera_ascendente_u(D, h, u)
  % Formula general de la catedra (apoyada en x0, para cualquier u=(x-x0)/h):
  % h*f'(x0+hu) = Delta y0 + Delta^2y0*(2u-1)/2 + Delta^3y0*(3u^2-6u+2)/6
  %               + Delta^4y0*(4u^3-18u^2+22u-6)/24
  % Los coeficientes solo estan definidos por la catedra hasta el orden 4.
  n = size(D, 1);
  orden_maximo = min(4, n - 1);
  terminos = zeros(orden_maximo, 1);
  suma = 0;
  for k = 1:orden_maximo
    delta_k_y0 = D(1, k + 1);
    if k == 1
      coeficiente = 1;
    elseif k == 2
      coeficiente = (2 * u - 1) / 2;
    elseif k == 3
      coeficiente = (3 * u ^ 2 - 6 * u + 2) / 6;
    else
      coeficiente = (4 * u ^ 3 - 18 * u ^ 2 + 22 * u - 6) / 24;
    end
    termino = delta_k_y0 * coeficiente;
    terminos(k) = termino;
    suma = suma + termino;
  end
  derivada = suma / h;
end

function [segunda_derivada, terminos] = segunda_derivada_descendente_extremo(D, h)
  % Formula de la catedra en v=0 (apoyada en xn):
  % h^2*f''(xn) = nabla^2 f(xn) + nabla^3 f(xn) + (11/12) nabla^4 f(xn) + ...
  % Los coeficientes solo estan definidos por la catedra hasta el orden 4.
  n = size(D, 1);
  pesos = [1, 1, 11 / 12];
  orden_maximo = min(4, n - 1);
  terminos = zeros(orden_maximo - 1, 1);
  suma = 0;
  for k = 2:orden_maximo
    nabla_k = D(n - k, k + 1);
    termino = pesos(k - 1) * nabla_k;
    terminos(k - 1) = termino;
    suma = suma + termino;
  end
  segunda_derivada = suma / h ^ 2;
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 1: derivacion numerica mediante las formulas de Newton-Gregory
% (Ascendente apoyada en el primer punto, Descendente apoyada en el ultimo)
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 1 - DERIVACION NUMERICA (NEWTON-GREGORY)');
disp('============================================================');

x_datos = input("\nIngrese el vector de x equidistantes (ej: [12 13 14 15 16 17]): ");
y_datos = input('Ingrese el vector de y = f(x) (ej: [0.96262 0.94718 0.93108 0.92221 0.91181 0.90151]): ');
h = x_datos(2) - x_datos(1);
n = length(x_datos);

printf('\nPaso h = %g\n', h);
D = calcular_tabla_diferencias(y_datos);
disp('Tabla de diferencias finitas hacia adelante:');
printf('%8s %10s', 'x', 'y');
for k = 1:n-1, printf('  %10s', sprintf('D^%dy', k)); end
printf('\n');
for i = 1:n
  printf('%8.4g %10.6f', x_datos(i), D(i, 1));
  for j = 2:(n - i + 1), printf('  %+10.6f', D(i, j)); end
  printf('\n');
end

% --- b) f'(x0) con Newton-Gregory Ascendente (u=0) ---
printf('\n>>> b) Derivada primera en x0=%g con Newton-Gregory Ascendente (u=0) <<<\n', x_datos(1));
[derivada_x0, terminos_b] = derivada_primera_ascendente_extremo(D, h);
acumulado = 0;
for k = 1:length(terminos_b)
  acumulado = acumulado + terminos_b(k);
  printf('  Termino orden %d = %+.8f  -->  h*f` acumulado = %.8f\n', k, terminos_b(k), acumulado);
end
printf('>>> RESULTADO: f`(%g) = %.8f\n', x_datos(1), derivada_x0);

% --- c) f'(x_eval) con la formula general (u != 0) ---
x_eval = input(sprintf("\nIngrese el valor de x para evaluar f' con la formula general (ej: %g): ", x_datos(1) + 0.4 * h));
u_eval = (x_eval - x_datos(1)) / h;
[derivada_xeval, terminos_c] = derivada_primera_ascendente_u(D, h, u_eval);
printf('\n>>> c) Derivada primera en x=%g con Newton-Gregory Ascendente (u=%.4f) <<<\n', x_eval, u_eval);
acumulado = 0;
for k = 1:length(terminos_c)
  acumulado = acumulado + terminos_c(k);
  printf('  Termino orden %d = %+.8f  -->  h*f` acumulado = %.8f\n', k, terminos_c(k), acumulado);
end
printf('>>> RESULTADO: f`(%g) = %.8f\n', x_eval, derivada_xeval);
printf('>>> Diferencia entre f`(%g) y f`(%g): %.8f\n', x_datos(1), x_eval, abs(derivada_x0 - derivada_xeval));

% --- d) f''(xn) con Newton-Gregory Descendente (v=0) ---
printf('\n>>> d) Derivada segunda en xn=%g con Newton-Gregory Descendente (v=0) <<<\n', x_datos(n));
[segunda_derivada_xn, terminos_d] = segunda_derivada_descendente_extremo(D, h);
acumulado = 0;
for k = 1:length(terminos_d)
  acumulado = acumulado + terminos_d(k);
  printf('  Termino orden %d = %+.8f  -->  h^2*f`` acumulado = %.8f\n', k + 1, terminos_d(k), acumulado);
end
printf('>>> RESULTADO: f``(%g) = %.8f\n', x_datos(n), segunda_derivada_xn);
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 1 - Derivacion numerica');
x_fino = linspace(x_datos(1), x_datos(n), 200);
y_fino = interp1(x_datos, y_datos, x_fino, 'spline');
recta_tangente = y_datos(1) + derivada_x0 * (x_fino - x_datos(1));
plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5); hold on;
plot(x_fino, recta_tangente, 'g--', 'LineWidth', 1.2);
plot(x_datos, y_datos, 'ko', 'MarkerFaceColor', 'k');
plot(x_datos(1), y_datos(1), 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 9);
plot(x_eval, interp1(x_datos, y_datos, x_eval, 'spline'), 'm^', 'MarkerFaceColor', 'm', 'MarkerSize', 9);
ylim([min(y_fino) - 0.01, max(y_fino) + 0.01]);
xlabel('x'); ylabel('y');
legend('f(x) interpolada', sprintf('Recta tangente en x0 (pend.=%.4f)', derivada_x0), 'Nodos', ...
  sprintf('x0=%g', x_datos(1)), sprintf('x=%g', x_eval), 'Location', 'best');
title('Derivacion numerica: Newton-Gregory');
grid on;

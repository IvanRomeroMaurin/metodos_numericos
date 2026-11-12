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

function [y_interp, terminos] = newton_gregory_ascendente(x_vec, D, x_eval)
  % P(x) = y0 + u*Dy0 + [u(u-1)/2!]*D^2y0 + ...  con u = (x - x0)/h
  h = x_vec(2) - x_vec(1);
  x0 = x_vec(1);
  u = (x_eval - x0) / h;
  n = length(x_vec);

  y_interp = D(1, 1);
  terminos = zeros(n, 1);
  terminos(1) = y_interp;
  u_prod = 1.0;
  for k = 1:(n - 1)
    u_prod = u_prod * (u - (k - 1)) / k;
    termino = u_prod * D(1, k + 1);
    terminos(k + 1) = termino;
    y_interp = y_interp + termino;
  end
end

function [y_interp, terminos] = newton_gregory_descendente(x_vec, D, x_eval)
  % P(x) = yn + v*Dyn + [v(v+1)/2!]*D^2yn + ...  con v = (x - xn)/h
  h = x_vec(2) - x_vec(1);
  n = length(x_vec);
  xn = x_vec(n);
  v = (x_eval - xn) / h;

  y_interp = D(n, 1);
  terminos = zeros(n, 1);
  terminos(1) = y_interp;
  v_prod = 1.0;
  for k = 1:(n - 1)
    v_prod = v_prod * (v + (k - 1)) / k;
    nabla_k = D(n - k, k + 1);
    termino = v_prod * nabla_k;
    terminos(k + 1) = termino;
    y_interp = y_interp + termino;
  end
end

function x_calc = interpolacion_inversa_lineal(x0, h, y0, delta_y0, y_target)
  % De P(x) = y0 + (Dy0/h)*(x - x0) = y_target, se despeja x.
  x_calc = x0 + h * (y_target - y0) / delta_y0;
end

function x_calc = interpolacion_inversa_cuadratica(x0, h, y0, delta_y0, delta2_y0, y_target)
  % De P(x) = y0 + (Dy0/h)(x-x0) + (D2y0/(2h^2))(x-x0)(x-x1) = y_target
  % resulta una ecuacion cuadratica en x que se resuelve con la formula general.
  x1 = x0 + h;
  A = delta2_y0 / (2 * h^2);
  B = delta_y0 / h;
  coef2 = A;
  coef1 = B - A * (x0 + x1);
  coef0 = y0 - B * x0 + A * x0 * x1 - y_target;
  raices = roots([coef2, coef1, coef0]);
  [~, idx] = min(abs(raices - x0));
  x_calc = raices(idx);
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 1: interpolacion en intervalos regularmente espaciados
% Newton-Gregory Ascendente, Descendente e Interpolacion Inversa
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 1 - NEWTON-GREGORY E INTERPOLACION INVERSA');
disp('============================================================');

x_datos = input("\nIngrese el vector de x equidistantes (ej: [15 25 35 45 55 65]): ");
y_datos = input('Ingrese el vector de y = f(x) (ej: [0.965926 0.906308 0.819152 0.707107 0.573576 0.422618]): ');
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

% --- a) Newton-Gregory Ascendente ---
x_eval_a = input("\nIngrese el valor de x a interpolar con Newton-Gregory Ascendente (ej: 17): ");
[y_a, terminos_a] = newton_gregory_ascendente(x_datos, D, x_eval_a);
u_a = (x_eval_a - x_datos(1)) / h;
printf('\n>>> a) Newton-Gregory Ascendente (u = (x-x0)/h = %.4f) <<<\n', u_a);
acumulado = 0;
for k = 1:n
  acumulado = acumulado + terminos_a(k);
  printf('  Termino orden %d = %+.6f  -->  suma parcial = %.6f\n', k - 1, terminos_a(k), acumulado);
end
printf('>>> RESULTADO: y(%g) = %.8f\n', x_eval_a, y_a);

% --- b) Newton-Gregory Descendente ---
x_eval_b = input("\nIngrese el valor de x a interpolar con Newton-Gregory Descendente (ej: 60): ");
[y_b, terminos_b] = newton_gregory_descendente(x_datos, D, x_eval_b);
v_b = (x_eval_b - x_datos(n)) / h;
printf('\n>>> b) Newton-Gregory Descendente (v = (x-xn)/h = %.4f) <<<\n', v_b);
acumulado = 0;
for k = 1:n
  acumulado = acumulado + terminos_b(k);
  printf('  Termino orden %d = %+.6f  -->  suma parcial = %.6f\n', k - 1, terminos_b(k), acumulado);
end
printf('>>> RESULTADO: y(%g) = %.8f\n', x_eval_b, y_b);

% --- c) Interpolacion inversa lineal y cuadratica ---
y_target = input("\nIngrese el valor de y para la interpolacion inversa (ej: 0.90728517): ");
indice = 0;
for i = 1:n-1
  if (y_target - y_datos(i)) * (y_target - y_datos(i + 1)) <= 0
    indice = i;
    break;
  end
end
if indice == 0
  error('El valor de y no se encuentra dentro del rango de la tabla.');
end
printf('\n>>> c) Interpolacion Inversa (y = %.8f, intervalo [%g, %g]) <<<\n', y_target, x_datos(indice), x_datos(indice + 1));

x_lineal = interpolacion_inversa_lineal(x_datos(indice), h, y_datos(indice), D(indice, 2), y_target);
printf('  Inversa Lineal    : x = %.6f\n', x_lineal);

x_cuadratica = interpolacion_inversa_cuadratica(x_datos(indice), h, y_datos(indice), D(indice, 2), D(indice, 3), y_target);
printf('  Inversa Cuadratica: x = %.6f\n', x_cuadratica);

printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 1 - Newton-Gregory e Inversa');
x_fino = linspace(x_datos(1), x_datos(n), 200);
y_fino = zeros(size(x_fino));
for k = 1:length(x_fino)
  y_fino(k) = newton_gregory_ascendente(x_datos, D, x_fino(k));
end
plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5); hold on;
plot(x_datos, y_datos, 'ko', 'MarkerFaceColor', 'k');
plot(x_eval_a, y_a, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 9);
plot(x_eval_b, y_b, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 9);
plot(x_cuadratica, y_target, 'm^', 'MarkerFaceColor', 'm', 'MarkerSize', 9);
xlabel('x'); ylabel('y');
legend('Polinomio interpolante', 'Nodos', sprintf('Ascendente x=%g', x_eval_a), ...
  sprintf('Descendente x=%g', x_eval_b), sprintf('Inversa y=%.4f', y_target), 'Location', 'best');
title('Interpolacion de Newton-Gregory');
grid on;

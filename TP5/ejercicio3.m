1; % script con funciones locales

function [y_eval, L] = interpolacion_lagrange(x_nodos, y_nodos, x_eval)
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

function [P_coefs, L_coefs] = forma_explicita_lagrange(x_nodos, y_nodos)
  % Obtiene los coeficientes canonicos de cada base L_i(x) = prod_{j~=i}(x-x_j)/(x_i-x_j)
  % y del polinomio global P(x) = suma y_i * L_i(x), en potencias decrecientes de x.
  n = length(x_nodos);
  L_coefs = zeros(n, n);
  P_coefs = zeros(1, n);
  for i = 1:n
    numerador = 1;
    denominador = 1.0;
    for j = 1:n
      if j ~= i
        numerador = conv(numerador, [1, -x_nodos(j)]);
        denominador = denominador * (x_nodos(i) - x_nodos(j));
      end
    end
    L_coefs(i, :) = numerador / denominador;
    P_coefs = P_coefs + y_nodos(i) * L_coefs(i, :);
  end
end

function imprimir_polinomio(coefs, nombre)
  n = length(coefs);
  printf('%s(x) = ', nombre);
  for i = 1:n
    grado = n - i;
    if i == 1
      signo = '';
      if coefs(i) < 0, signo = '-'; end
    else
      if coefs(i) >= 0, signo = ' + '; else, signo = ' - '; end
    end
    if grado > 1
      printf('%s%.5f*x^%d', signo, abs(coefs(i)), grado);
    elseif grado == 1
      printf('%s%.5f*x', signo, abs(coefs(i)));
    else
      printf('%s%.5f', signo, abs(coefs(i)));
    end
  end
  printf('\n');
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 3: polinomio interpolante de Lagrange en forma explicita
% (nodos no equidistantes)
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 3 - POLINOMIO DE LAGRANGE (FORMA EXPLICITA)');
disp('============================================================');

x_datos = input("\nIngrese el vector de x (no necesariamente equidistantes, ej: [0 0.4 0.75 1.5 2.0]): ");
y_datos = input('Ingrese el vector de y (ej: [1 1.63246 1.86603 2.22474 2.41421]): ');

tic;
[P_coefs, L_coefs] = forma_explicita_lagrange(x_datos, y_datos);
tiempo_proceso = toc;

printf('\n>>> a) Forma explicita de cada polinomio base L_i(x) <<<\n');
for i = 1:length(x_datos)
  imprimir_polinomio(L_coefs(i, :), sprintf('L_%d', i - 1));
end
printf('\n>>> Polinomio interpolante global <<<\n');
imprimir_polinomio(P_coefs, 'P');

x_eval_1 = input("\nIngrese el primer valor de x a interpolar (ej: 1): ");
y_eval_1 = polyval(P_coefs, x_eval_1);
printf('>>> RESULTADO: P(%g) = %.6f\n', x_eval_1, y_eval_1);

x_eval_2 = input("\nIngrese el segundo valor de x a interpolar (ej: 0.45): ");
y_eval_2 = polyval(P_coefs, x_eval_2);
printf('>>> RESULTADO: P(%g) = %.6f\n', x_eval_2, y_eval_2);

printf('\nTiempo de proceso: %.6f segundos\n', tiempo_proceso);
printf('============================================================\n');

figure('Name', 'Ejercicio 3 - Polinomio de Lagrange');
x_fino = linspace(min(x_datos), max(x_datos), 200);
y_fino = polyval(P_coefs, x_fino);
plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5); hold on;
plot(x_datos, y_datos, 'ko', 'MarkerFaceColor', 'k');
plot(x_eval_1, y_eval_1, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 9);
plot(x_eval_2, y_eval_2, 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', 9);
xlabel('x'); ylabel('y');
legend('Polinomio P(x)', 'Nodos', sprintf('P(%g)=%.4f', x_eval_1, y_eval_1), ...
  sprintf('P(%g)=%.4f', x_eval_2, y_eval_2), 'Location', 'best');
title('Polinomio interpolante de Lagrange');
grid on;

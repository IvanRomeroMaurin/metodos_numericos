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

function DD = diferencias_divididas(x_nodos, y_nodos)
  % Tabla de diferencias divididas de Newton: DD(i,1)=y_i,
  % DD(i,j) = (DD(i+1,j-1) - DD(i,j-1)) / (x(i+j-1) - x(i))
  n = length(x_nodos);
  DD = zeros(n, n);
  DD(:, 1) = y_nodos(:);
  for j = 2:n
    for i = 1:(n - j + 1)
      DD(i, j) = (DD(i + 1, j - 1) - DD(i, j - 1)) / (x_nodos(i + j - 1) - x_nodos(i));
    end
  end
end

function [parciales, terminos] = newton_progresivo(x_nodos, DD, x_eval)
  % Construye el polinomio de Newton por diferencias divididas en el orden
  % dado de los nodos, agregando un termino de grado creciente por paso
  % (interpolacion progresiva). parciales(k) = P_(k-1)(x_eval).
  n = length(x_nodos);
  parciales = zeros(n, 1);
  terminos = zeros(n, 1);
  producto = 1.0;
  acumulado = DD(1, 1);
  parciales(1) = acumulado;
  terminos(1) = acumulado;
  for k = 1:(n - 1)
    producto = producto * (x_eval - x_nodos(k));
    termino = DD(1, k + 1) * producto;
    terminos(k + 1) = termino;
    acumulado = acumulado + termino;
    parciales(k + 1) = acumulado;
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 4: densidad del sodio - Lagrange vs Interpolacion Parabolica
% Progresiva (diferencias divididas de Newton, construidas termino a
% termino en el orden de los nodos dado)
% ===================================================================
clear; clc; close all;
disp('============================================================');
disp(' EJERCICIO 4 - DENSIDAD DEL SODIO: LAGRANGE Y PARABOLICA PROGRESIVA');
disp('============================================================');

T_datos = input("\nIngrese el vector de temperaturas (ej: [102 245 327 423 565]): ");
rho_datos = input('Ingrese el vector de densidades (ej: [0.564642 0.644218 0.717356 0.783327 0.853329]): ');
T_eval = input('Ingrese la temperatura a interpolar (ej: 275): ');

% --- a) Formula de Lagrange (global, con todos los nodos) ---
tic;
[rho_lagrange, L] = interpolacion_lagrange(T_datos, rho_datos, T_eval);
tiempo_lagrange = toc;

printf('\n>>> a) Formula de Lagrange (global) <<<\n');
printf('%6s %8s %12s %10s\n', 'Nodo', 'T', 'rho', 'L_i(%g)');
for i = 1:length(T_datos)
  printf('%6d %8.4g %12.6f %10.6f\n', i - 1, T_datos(i), rho_datos(i), L(i));
end
printf('>>> RESULTADO: rho(%g) = %.6f g/cm3 (tiempo %.6f s)\n', T_eval, rho_lagrange, tiempo_lagrange);

% --- b) Interpolacion parabolica progresiva ---
tic;
DD = diferencias_divididas(T_datos, rho_datos);
[parciales, terminos] = newton_progresivo(T_datos, DD, T_eval);
tiempo_parabolica = toc;

printf('\n>>> b) Interpolacion Parabolica Progresiva (diferencias divididas) <<<\n');
printf('%6s %14s %14s\n', 'Grado', 'Termino', 'P_k(%g)' );
for k = 1:length(parciales)
  printf('%6d %+14.8f %14.8f\n', k - 1, terminos(k), parciales(k));
end
rho_parabola = parciales(3);
error_estimado = abs(parciales(4) - parciales(3));
printf('\n>>> La "parabola" usa los 3 primeros nodos: P2(%g) = %.6f g/cm3\n', T_eval, rho_parabola);
printf('>>> Error estimado (magnitud del siguiente termino): %.6f g/cm3 (%.4f %%)\n', ...
  error_estimado, error_estimado / abs(rho_parabola) * 100);
printf('Tiempo de proceso: %.6f segundos\n', tiempo_parabolica);

% --- c) Comparacion ---
printf('\n============================================================\n');
printf(' COMPARACION Y CONCLUSIONES\n');
printf('============================================================\n');
printf(' -> Lagrange (global, %d nodos)        : rho = %.6f g/cm3\n', length(T_datos), rho_lagrange);
printf(' -> Parabolica progresiva (3 nodos)     : rho = %.6f g/cm3\n', rho_parabola);
printf(' -> Diferencia entre ambos metodos      : %.6f g/cm3\n', abs(rho_lagrange - rho_parabola));
printf('============================================================\n');

% --- Grafico ---
figure('Name', 'Ejercicio 4 - Densidad del sodio');
T_fino = linspace(min(T_datos), max(T_datos), 200);
rho_fino = zeros(size(T_fino));
for k = 1:length(T_fino)
  rho_fino(k) = interpolacion_lagrange(T_datos, rho_datos, T_fino(k));
end
plot(T_fino, rho_fino, 'b-', 'LineWidth', 1.5); hold on;
plot(T_datos, rho_datos, 'ko', 'MarkerFaceColor', 'k');
plot(T_eval, rho_lagrange, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 9);
plot(T_eval, rho_parabola, 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', 9);
xlabel('Temperatura [C]'); ylabel('Densidad [g/cm3]');
legend('Lagrange global', 'Datos experimentales', sprintf('Lagrange(%g)', T_eval), ...
  sprintf('Parabolica(%g)', T_eval), 'Location', 'best');
title('Densidad del sodio vs temperatura');
grid on;

% =========================================================================
% GUÍA DE LABORATORIO N° 3 - EJERCICIO 1
% Tanque esférico: profundidad h para V = 30 m^3 (R = 3 m)
% V = pi * h^2 * (3*R - h) / 3  -->  f(h) = pi * h^2 * (3 - h/3) - 30 = 0
% =========================================================================

clear; clc;
lib = libreria_tp3();

f = @(h) pi * (h.^2) .* (3 - h./3) - 30;

printf('=================================================================\n');
printf('   EJERCICIO 1: TANQUE ESFÉRICO (Búsqueda de Raíces f(h) = 0)    \n');
printf('=================================================================\n\n');
printf('f(h) = pi * h^2 * (3 - h/3) - 30 = 0,  con 0 <= h <= 6 m\n\n');

% a) Gráfica
figure(1);
fplot(f, [0, 6], 'b-', 'LineWidth', 2);
hold on; grid on;
line([0, 6], [0, 0], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5);
xlabel('Profundidad h [metros]');
ylabel('f(h)');
title('Ejercicio 1: f(h) = \pi h^2 (3 - h/3) - 30');
legend('f(h)', 'f(h) = 0', 'Location', 'NorthWest');

% b) Tanteo
printf('-----------------------------------------------------------------\n');
printf('b) Separación de raíces por Método de Tanteo\n');
printf('-----------------------------------------------------------------\n');

paso = 0.5;
entrada = input('Ingrese el incremento para tanteo (Enter = 0.5): ', 's');
if ~isempty(entrada) && str2double(entrada) > 0
    paso = str2double(entrada);
end

intervalos = lib.tanteo(f, 0, 6, paso, true);
if isempty(intervalos)
    error('No se encontraron cambios de signo en [0, 6] con el paso dado.');
end

a_raiz = intervalos(1, 1);
b_raiz = intervalos(1, 2);
printf('\n-> Raíz separada en el intervalo: [%.4f, %.4f]\n\n', a_raiz, b_raiz);

% c) Intervalo medio e interpolación lineal
printf('-----------------------------------------------------------------\n');
printf('c) Aproximación de la raíz con E < 0.001\n');
printf('-----------------------------------------------------------------\n');

tol = 0.001;
entrada = input('Ingrese cota de error admisible (Enter = 0.001): ', 's');
if ~isempty(entrada) && str2double(entrada) > 0
    tol = str2double(entrada);
end

tic;
[h_bis, iter_bis, ~, n_teorico] = lib.intervalo_medio(f, a_raiz, b_raiz, tol, 100, true);
t_bis = toc;

printf('\nResultado Intervalo Medio:\n');
printf('  Profundidad estimada: h = %.6f m\n', h_bis);
printf('  Residuo f(h):          %.8e\n', f(h_bis));
printf('  Iteraciones teóricas: %d\n', n_teorico);
printf('  Iteraciones reales:   %d\n', iter_bis);
printf('  Tiempo de cómputo:    %.6f s\n\n', t_bis);

tic;
[h_rf, iter_rf] = lib.interpolacion_lineal(f, a_raiz, b_raiz, tol, 100, true);
t_rf = toc;

printf('\nResultado Interpolación Lineal:\n');
printf('  Profundidad estimada: h = %.6f m\n', h_rf);
printf('  Residuo f(h):          %.8e\n', f(h_rf));
printf('  Iteraciones reales:   %d\n', iter_rf);
printf('  Tiempo de cómputo:    %.6f s\n\n', t_rf);

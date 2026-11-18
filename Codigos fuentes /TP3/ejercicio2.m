clear; clc;

% Librería de métodos numéricos
lib = libreria_tp3();

% Definición de la función de utilidad y sus derivadas
P   = @(x) 8.*x + 0.3.*(x.^2) - 0.0013.*(x.^3) - 372;
dP  = @(x) 8 + 0.6.*x - 0.0039.*(x.^2);
d2P = @(x) 0.6 - 0.0078.*x;

% Inciso a: Gráfica con fplot
figure(2);
fplot(P, [0, 300], 'b-', 'LineWidth', 2);
hold on; grid on;
line([0, 300], [0, 0], 'Color', 'r', 'LineStyle', '--');
xlabel('Cantidad de impresoras (x)');
ylabel('Utilidad P(x)');
title('P(x) = 8x + 0.3x^2 - 0.0013x^3 - 372');

% Separación de raíces por Método de Tanteo
printf('\n--- Método de Tanteo ---\n');
a_tanteo = input('Ingrese el límite inferior para tanteo a: ');
b_tanteo = input('Ingrese el límite superior para tanteo b: ');
paso     = input('Ingrese el incremento/paso para tanteo: ');

intervalos_encontrados = lib.tanteo(P, a_tanteo, b_tanteo, paso, true);

printf('\nIntervalos donde se encuentran las raíces:\n');
for i = 1:size(intervalos_encontrados, 1)
    printf('  Raíz %d: [%.4f, %.4f]\n', i, intervalos_encontrados(i, 1), intervalos_encontrados(i, 2));
end

% Inciso b: Newton-Raphson
printf('\n--- Método de Newton-Raphson ---\n');
tol = input('Ingrese la cota de error: ');

% Raíz 1: Intervalo [24, 26]
printf('\n--- Intervalo [24, 26] ---\n');
[cumple1, x0_1] = lib.fourier(P, dP, d2P, 24, 26, true);
[raiz_1, iter_1] = lib.newton_raphson(P, dP, x0_1, tol, 100, true);
printf('\nRaíz 1 aproximada: %.6f (iteraciones: %d)\n', raiz_1, iter_1);

% Raíz 2: Intervalo [250, 252]
printf('\n--- Intervalo [250, 252] ---\n');
[cumple2, x0_2] = lib.fourier(P, dP, d2P, 250, 252, true);
[raiz_2, iter_2] = lib.newton_raphson(P, dP, x0_2, tol, 100, true);
printf('\nRaíz 2 aproximada: %.6f (iteraciones: %d)\n', raiz_2, iter_2);

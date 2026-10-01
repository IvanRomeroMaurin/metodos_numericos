% =========================================================================
% GUÍA DE LABORATORIO N° 3 - EJERCICIO 1
% Tanque esférico: cálculo de profundidad h para V = 30 m^3 (R = 3 m)
% Métodos Computacionales
% =========================================================================

clear; clc;
printf('=================================================================\n');
printf('   EJERCICIO 1: TANQUE ESFÉRICO (Búsqueda de Raíces f(h) = 0)    \n');
printf('=================================================================\n\n');

% Cargamos la librería de métodos numéricos
lib = libreria_tp3();

% -------------------------------------------------------------------------
% Definición del modelo físico y matemático
% -------------------------------------------------------------------------
% Fórmula de volumen: V = pi * h^2 * (3*R - h) / 3
% Con R = 3 m y V = 30 m^3:
% f(h) = pi * h^2 * (3 - h/3) - 30 = 0
R = 3;       % Radio en metros
V_obj = 30;  % Volumen objetivo en m^3

f = @(h) pi * (h.^2) .* (3 - h./3) - V_obj;

printf('Modelo matemático:\n');
printf('  f(h) = pi * h^2 * (3 - h/3) - 30 = 0\n');
printf('  Rango físico válido de profundidad: 0 <= h <= 2*R  -->  [0, 6] metros\n\n');

% -------------------------------------------------------------------------
% Inciso a: Evaluación gráfica con fplot
% -------------------------------------------------------------------------
printf('-----------------------------------------------------------------\n');
printf('a) Evaluación gráfica de la función con fplot\n');
printf('-----------------------------------------------------------------\n');
try
    figure(1);
    fplot(f, [0, 6], 'b-', 'LineWidth', 2);
    hold on;
    grid on;
    line([0, 6], [0, 0], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5);
    xlabel('Profundidad h [metros]');
    ylabel('f(h)');
    title('Ejercicio 1: f(h) = \pi h^2 (3 - h/3) - 30');
    legend('f(h)', 'f(h) = 0 (Eje de corte)', 'Location', 'NorthWest');
    printf('-> Gráfico generado en la Figura 1. Se observa corte cerca de h in [2, 3].\n\n');
catch err
    printf('-> Nota sobre entorno gráfico: %s\n\n', err.message);
end

% -------------------------------------------------------------------------
% Inciso b: Separación de raíces con el Método de Tanteo
% -------------------------------------------------------------------------
printf('-----------------------------------------------------------------\n');
printf('b) Separación de raíces por Método de Tanteo\n');
printf('-----------------------------------------------------------------\n');

paso = 0.5;
try
    paso_input = input('Ingrese el incremento/paso para tanteo (Enter para valor por defecto 0.5): ', 's');
    if ~isempty(paso_input)
        val = str2double(paso_input);
        if ~isnan(val) && val > 0
            paso = val;
        end
    end
catch
    % En caso de entorno sin TTY interactivo
end
printf('Ejecutando tanteo en [0, 6] con incremento delta_h = %.4f...\n', paso);

intervalos_encontrados = lib.tanteo(f, 0, 6, paso, true);

if isempty(intervalos_encontrados)
    error('No se encontraron cambios de signo en [0, 6] con el paso dado.');
end

a_raiz = intervalos_encontrados(1, 1);
b_raiz = intervalos_encontrados(1, 2);
printf('\n-> Raíz separada con éxito en el intervalo: [%.4f, %.4f]\n\n', a_raiz, b_raiz);

% -------------------------------------------------------------------------
% Inciso c: Aproximación con Intervalo Medio e Interpolación Lineal (E < 0.001)
% -------------------------------------------------------------------------
printf('-----------------------------------------------------------------\n');
printf('c) Aproximación de la raíz con E < 0.001\n');
printf('-----------------------------------------------------------------\n');

tol = 0.001;
try
    tol_input = input('Ingrese cota de error admisible (Enter para 0.001): ', 's');
    if ~isempty(tol_input)
        val_tol = str2double(tol_input);
        if ~isnan(val_tol) && val_tol > 0
            tol = val_tol;
        end
    end
catch
    % En caso de entorno sin TTY interactivo
end

% --- Método de Intervalo Medio (Bisección) ---
tic;
[h_bis, iter_bis, tabla_bis, n_teorico] = lib.intervalo_medio(f, a_raiz, b_raiz, tol, 100, true);
t_bis = toc;

printf('\nResultado Intervalo Medio:\n');
printf('  Profundidad estimada: h = %.6f m\n', h_bis);
printf('  Residuo f(h):          %.8e\n', f(h_bis));
printf('  Iteraciones teóricas: %d\n', n_teorico);
printf('  Iteraciones reales:   %d\n', iter_bis);
printf('  Tiempo de cómputo:    %.6f s\n\n', t_bis);

% --- Método de Interpolación Lineal (Regula Falsi) ---
tic;
[h_rf, iter_rf, tabla_rf] = lib.interpolacion_lineal(f, a_raiz, b_raiz, tol, 100, true);
t_rf = toc;

printf('\nResultado Interpolación Lineal:\n');
printf('  Profundidad estimada: h = %.6f m\n', h_rf);
printf('  Residuo f(h):          %.8e\n', f(h_rf));
printf('  Iteraciones reales:   %d\n', iter_rf);
printf('  Tiempo de cómputo:    %.6f s\n\n', t_rf);

% -------------------------------------------------------------------------
% Inciso d: Comparación de métodos y conclusiones
% -------------------------------------------------------------------------
printf('-----------------------------------------------------------------\n');
printf('d) Cuadro comparativo de métodos y conclusiones\n');
printf('-----------------------------------------------------------------\n');

printf('%-24s | %-12s | %-14s | %-12s | %-12s\n', ...
       'Método', 'Raíz h [m]', 'Residuo f(h)', 'Iteraciones', 'Tiempo [s]');
printf('%s\n', repmat('-', 1, 85));
printf('%-24s | %12.6f | %14.6e | %12d | %12.6f\n', ...
       'Intervalo Medio', h_bis, f(h_bis), iter_bis, t_bis);
printf('%-24s | %12.6f | %14.6e | %12d | %12.6f\n', ...
       'Interpolación Lineal', h_rf, f(h_rf), iter_rf, t_rf);
printf('%s\n\n', repmat('-', 1, 85));

printf('Conclusiones:\n');
printf('1. Convergencia: El Método de Interpolación Lineal converge en menos iteraciones\n');
printf('   (%d vs %d) gracias a que aproxima la pendiente con la recta secante, reduciendo\n', iter_rf, iter_bis);
printf('   el intervalo de forma más eficiente que la simple división a la mitad.\n');
printf('2. Robustez: Ambos métodos son cerrados (bracketing) y garantizan convergencia\n');
printf('   debido a que se verificó previamente el Teorema de Bolzano en [%.2f, %.2f].\n', a_raiz, b_raiz);
printf('3. Significado físico: La profundidad requerida para acumular 30 m^3 de líquido\n');
printf('   en el tanque de radio R = 3 m es de aproximadamente h = %.4f metros.\n', h_rf);

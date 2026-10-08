% =========================================================================
% GUÍA DE LABORATORIO N° 3 - EJERCICIO 2
% Puntos de equilibrio de utilidad P(x): Fabricación de impresoras
% Métodos Computacionales
% =========================================================================

clear; clc;
printf('=================================================================\n');
printf('   EJERCICIO 2: PUNTOS DE EQUILIBRIO - UTILIDAD DE IMPRESORAS    \n');
printf('=================================================================\n\n');

% Cargamos la librería de métodos numéricos
lib = libreria_tp3();

% -------------------------------------------------------------------------
% Definición del modelo económico y matemático
% -------------------------------------------------------------------------
% P(x) = 8*x + 0.3*x^2 - 0.0013*x^3 - 372
% Derivadas analíticas:
% dP(x)  = 8 + 0.6*x - 0.0039*x^2
% d2P(x) = 0.6 - 0.0078*x

P   = @(x) 8.*x + 0.3.*(x.^2) - 0.0013.*(x.^3) - 372;
dP  = @(x) 8 + 0.6.*x - 0.0039.*(x.^2);
d2P = @(x) 0.6 - 0.0078.*x;

printf('Función de Utilidad mensual:\n');
printf('  P(x)   = 8x + 0.3x^2 - 0.0013x^3 - 372\n');
printf("  P'(x)  = 8 + 0.6x - 0.0039x^2\n");
printf("  P''(x) = 0.6 - 0.0078x\n\n");

% -------------------------------------------------------------------------
% Inciso a: Evaluación gráfica con fplot
% -------------------------------------------------------------------------
printf('-----------------------------------------------------------------\n');
printf('a) Evaluación gráfica de la función de utilidad con fplot\n');
printf('-----------------------------------------------------------------\n');

try
    figure(2);
    fplot(P, [0, 300], 'b-', 'LineWidth', 2);
    hold on;
    grid on;
    line([0, 300], [0, 0], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5);
    
    % Destacar zonas de raíces con rectángulos o líneas
    line([24, 26], [0, 0], 'Color', [0 0.5 0], 'LineWidth', 3);
    line([250, 252], [0, 0], 'Color', [0.8 0 0.8], 'LineWidth', 3);
    
    xlabel('Cantidad de impresoras producidas y vendidas (x)');
    ylabel('Utilidad total P(x) [$]');
    title('Ejercicio 2: P(x) = 8x + 0.3x^2 - 0.0013x^3 - 372');
    legend('P(x)', 'P(x) = 0 (Equilibrio)', 'Raíz 1 in [24, 26]', 'Raíz 2 in [250, 252]', 'Location', 'North');
    
    printf('-> Gráfico generado en la Figura 2.\n');
    printf('   - Se observan claramente dos cortes con el eje horizontal (P(x) = 0).\n');
    printf('   - Entre las dos raíces (aprox. 25 a 251 impresoras), P(x) > 0 (zona de ganancia).\n');
    printf('   - Fuera de ese rango, la empresa incurre en pérdidas (P(x) < 0).\n\n');
catch err
    printf('-> Nota sobre entorno gráfico: %s\n\n', err.message);
end

% -------------------------------------------------------------------------
% Inciso b: Análisis de Fourier y Newton-Raphson para los dos puntos
% -------------------------------------------------------------------------
printf('-----------------------------------------------------------------\n');
printf('b) Análisis de Condiciones de Fourier y Método de Newton-Raphson\n');
printf('-----------------------------------------------------------------\n');

tol = 1e-3;
try
    tol_input = input('Ingrese cota de error admisible (Enter para 1e-3): ', 's');
    if ~isempty(tol_input)
        val_tol = str2double(tol_input);
        if ~isnan(val_tol) && val_tol > 0
            tol = val_tol;
        end
    end
catch
    % En caso de ejecución automatizada
end
printf('Cota de error fijada en E < %.6e\n\n', tol);

% =========================================================================
% PUNTO DE EQUILIBRIO 1: Intervalo [24, 26]
% =========================================================================
printf('*****************************************************************\n');
printf('   PUNTO DE EQUILIBRIO 1: Intervalo [24, 26]                     \n');
printf('*****************************************************************\n');

[cumple1, x0_1, info1] = lib.fourier(P, dP, d2P, 24, 26, true);

printf('Ejecutando Newton-Raphson con x0 = %.4f (sugerido por Fourier)...\n', x0_1);
tic;
[raiz_1, iter_1, tabla_1] = lib.newton_raphson(P, dP, x0_1, tol, 100, true);
t_1 = toc;

printf('\nResultado Raíz 1:\n');
printf('  x1 aproximado:       %.6f impresoras\n', raiz_1);
printf('  Utilidad P(x1):      %.8e $\n', P(raiz_1));
printf('  Iteraciones:         %d\n', iter_1);
printf('  Tiempo de cómputo:   %.6f s\n\n', t_1);

% =========================================================================
% PUNTO DE EQUILIBRIO 2: Intervalo [250, 252]
% =========================================================================
printf('*****************************************************************\n');
printf('   PUNTO DE EQUILIBRIO 2: Intervalo [250, 252]                   \n');
printf('*****************************************************************\n');

[cumple2, x0_2, info2] = lib.fourier(P, dP, d2P, 250, 252, true);

printf('Ejecutando Newton-Raphson con x0 = %.4f (sugerido por Fourier)...\n', x0_2);
tic;
[raiz_2, iter_2, tabla_2] = lib.newton_raphson(P, dP, x0_2, tol, 100, true);
t_2 = toc;

printf('\nResultado Raíz 2:\n');
printf('  x2 aproximado:       %.6f impresoras\n', raiz_2);
printf('  Utilidad P(x2):      %.8e $\n', P(raiz_2));
printf('  Iteraciones:         %d\n', iter_2);
printf('  Tiempo de cómputo:   %.6f s\n\n', t_2);

% -------------------------------------------------------------------------
% Resumen general y conclusiones
% -------------------------------------------------------------------------
printf('=================================================================\n');
printf('                    RESUMEN Y CONCLUSIONES                       \n');
printf('=================================================================\n');
printf('%-18s | %-16s | %-16s | %-12s | %-12s\n', ...
       'Punto Equilibrio', 'Raíz x [unid]', 'Residuo P(x)', 'Iteraciones', 'Tiempo [s]');
printf('%s\n', repmat('-', 1, 85));
printf('%-18s | %16.6f | %16.6e | %12d | %12.6f\n', ...
       '1 (Umbral mínimo)', raiz_1, P(raiz_1), iter_1, t_1);
printf('%-18s | %16.6f | %16.6e | %12d | %12.6f\n', ...
       '2 (Límite máximo)', raiz_2, P(raiz_2), iter_2, t_2);
printf('%s\n\n', repmat('-', 1, 85));

printf('Conclusiones teóricas y prácticas:\n');
printf('1. Condiciones de Fourier:\n');
printf("   - En [24, 26]: dP(x) > 0 y d2P(x) > 0. P(26)*d2P(26) > 0 => x0 = 26.\n");
printf("   - En [250, 252]: dP(x) < 0 y d2P(x) < 0. P(252)*d2P(252) > 0 => x0 = 252.\n");
printf('   - Al cumplir todas las condiciones, Newton-Raphson converge de manera monótona\n');
printf('     y cuadrática en poquísimas iteraciones (%d y %d respectivamente).\n\n', iter_1, iter_2);

printf('2. Interpretación Económica:\n');
printf('   - Primer punto de equilibrio: x1 ≈ %.2f impresoras.\n', raiz_1);
printf('     La compañía debe producir al menos 26 impresoras/mes para salir de pérdidas\n');
printf('     y comenzar a tener ganancias.\n');
printf('   - Segundo punto de equilibrio: x2 ≈ %.2f impresoras.\n', raiz_2);
printf('     Si produce más de 250 impresoras/mes, los costos de saturación y capacidad\n');
printf('     vuelven a generar pérdidas.\n');
printf('   - Rango óptimo de rentabilidad: 26 <= x <= 250 impresoras al mes.\n');

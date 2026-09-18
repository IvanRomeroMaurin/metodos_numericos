printf('=== EJERCICIO 4: Raices de x^2 + 62.10x + 1 = 0 ===\n\n');

lib = libreria_tp2();
rd  = @(x) lib.redondear(x, 4);

tic;

x1_exacto = -0.01610723;
x2_exacto = -62.08390;

a = 1;
b = 62.10;
c = 1;

% --- INCISO A: Formula estandar con redondeo a 4 digitos ---
printf('--- INCISO A: Formula estandar ---\n\n');

b_cuad    = rd(b^2);
cuatro_ac = rd(4 * a * c);
D         = rd(b_cuad - cuatro_ac);
raiz_D    = rd(sqrt(D));

num_x1 = rd(-b + raiz_D);
x1_a   = rd(num_x1 / (2*a));

num_x2 = rd(-b - raiz_D);
x2_a   = rd(num_x2 / (2*a));

[ea_x1_a, er_x1_a, erp_x1_a] = lib.error(x1_exacto, x1_a);
[ea_x2_a, er_x2_a, erp_x2_a] = lib.error(x2_exacto, x2_a);

printf('x1 = %.4f  |  Ea = %.2e  |  Er = %.6f\n', x1_a, ea_x1_a, er_x1_a);
printf('x2 = %.4f  |  Ea = %.2e  |  Er = %.6f\n\n', x2_a, ea_x2_a, er_x2_a);

% --- INCISO B: Formula racionalizada con redondeo a 4 digitos ---
% x1 = 2c / (-b - sqrt(D))
% x2 = 2c / (-b + sqrt(D))
printf('--- INCISO B: Formula racionalizada ---\n\n');

den_x1b = rd(-b - raiz_D);
x1_b    = rd((2*c) / den_x1b);

den_x2b = rd(-b + raiz_D);
x2_b    = rd((2*c) / den_x2b);

[ea_x1_b, er_x1_b, erp_x1_b] = lib.error(x1_exacto, x1_b);
[ea_x2_b, er_x2_b, erp_x2_b] = lib.error(x2_exacto, x2_b);

printf('x1 = %.4f  |  Ea = %.2e  |  Er = %.6f\n', x1_b, ea_x1_b, er_x1_b);
printf('x2 = %.4f  |  Ea = %.2e  |  Er = %.6f\n\n', x2_b, ea_x2_b, er_x2_b);

% --- Comparacion final ---
printf('=== Comparacion de errores relativos ===\n\n');
printf('     | Formula Estandar | Formula Racionalizada\n');
printf('-----+------------------+---------------------\n');
printf(' x1  |  Er = %.6f   |  Er = %.6f\n', er_x1_a, er_x1_b);
printf(' x2  |  Er = %.6f   |  Er = %.6f\n\n', er_x2_a, er_x2_b);

tiempo = toc;
printf('Tiempo de proceso: %.6f segundos\n', tiempo);

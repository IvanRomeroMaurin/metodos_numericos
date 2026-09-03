% Modelo Matemático:
% Error Absoluto: Ea = |p - p*|
% Error Relativo: Er = Ea / |p|
% Error Relativo Porcentual: Er_porc = Er * 100

% Ejercicio 1: Cálculo de error absoluto y relativo
printf('--- Ejercicio 1: Cálculo de errores en aproximaciones ---\n\n');

tic;

% Inciso a: p = pi, p* = 22/7
p_a = pi;
p_ast_a = 22/7;
ea_a = abs(p_a - p_ast_a);
er_a = ea_a / abs(p_a);

% Inciso b: p = pi, p* = 3.1416
p_b = pi;
p_ast_b = 3.1416;
ea_b = abs(p_b - p_ast_b);
er_b = ea_b / abs(p_b);

% Inciso c: p = e, p* = 2.718
p_c = exp(1);
p_ast_c = 2.718;
ea_c = abs(p_c - p_ast_c);
er_c = ea_c / abs(p_c);

% Inciso d: p = sqrt(2), p* = 1.414
p_d = sqrt(2);
p_ast_d = 1.414;
ea_d = abs(p_d - p_ast_d);
er_d = ea_d / abs(p_d);

% Inciso e: p = e^10, p* = 22000
p_e = exp(10);
p_ast_e = 22000;
ea_e = abs(p_e - p_ast_e);
er_e = ea_e / abs(p_e);

% Inciso f: p = 8!, p* = 39900
p_f = factorial(8);
p_ast_f = 39900;
ea_f = abs(p_f - p_ast_f);
er_f = ea_f / abs(p_f);

tiempo = toc;

% Mostramos los resultados
printf('a) p = pi, p* = 22/7:\n');
printf('   Ea: %.6f | Er: %.6f (%.4f%%)\n\n', ea_a, er_a, er_a * 100);

printf('b) p = pi, p* = 3.1416:\n');
printf('   Ea: %.6f | Er: %.6f (%.4f%%)\n\n', ea_b, er_b, er_b * 100);

printf('c) p = e, p* = 2.718:\n');
printf('   Ea: %.6f | Er: %.6f (%.4f%%)\n\n', ea_c, er_c, er_c * 100);

printf('d) p = sqrt(2), p* = 1.414:\n');
printf('   Ea: %.6f | Er: %.6f (%.4f%%)\n\n', ea_d, er_d, er_d * 100);

printf('e) p = e^10, p* = 22000:\n');
printf('   Ea: %.4f | Er: %.6f (%.4f%%)\n\n', ea_e, er_e, er_e * 100);

printf('f) p = 8!, p* = 39900:\n');
printf('   Ea: %.4f | Er: %.6f (%.4f%%)\n\n', ea_f, er_f, er_f * 100);

printf('Tiempo de proceso: %.6f segundos\n', tiempo);

% Ejercicio 5 - Evaluacion de polinomio con aritmetica de 3 digitos
% f(x) = x^3 - 6x^2 + 3x - 0.149  en  x = 4.71

lib = libreria_tp2();

% Alias para truncar y redondear a 3 cifras significativas
% La libreria trabaja con cifras significativas (equivalente a sin normalizar)
tr3 = @(v) lib.truncar(v, 3);
rd3 = @(v) lib.redondear(v, 3);

tic;

val = 4.71;

% =========================================================
% INCISO A: Forma directa
% =========================================================

% -- Valor exacto --
ex_x2 = val^2;
ex_x3 = val^3;
ex_6x2 = 6 * ex_x2;
ex_3x  = 3 * val;
ex_fx  = ex_x3 - ex_6x2 + ex_3x - 0.149;

% -- Truncado a 3 digitos --
a2_t  = tr3(val^2);
a3_t  = tr3(val * a2_t);
b2_t  = tr3(6 * a2_t);
b3_t  = tr3(3 * val);
fx_t  = tr3( tr3( tr3(a3_t - b2_t) + b3_t ) - 0.149 );

% -- Redondeado a 3 digitos --
a2_r  = rd3(val^2);
a3_r  = rd3(val * a2_r);
b2_r  = rd3(6 * a2_r);
b3_r  = rd3(3 * val);
fx_r  = rd3( rd3( rd3(a3_r - b2_r) + b3_r ) - 0.149 );

% Tabla de resultados
printf('%-12s %6s %9s %9s %9s %9s %9s\n', '', 'x', 'x^2', 'x^3', '6x^2', '3x', 'f(x)');
printf('%s\n', repmat('-', 1, 67));
printf('%-12s %6.2f %9.5f %9.5f %9.5f %9.5f %9.5f\n', 'Exacto',     val, ex_x2, ex_x3, ex_6x2, ex_3x, ex_fx);
printf('%-12s %6.2f %9.3f %9.3f %9.3f %9.3f %9.3f\n', 'Truncado',   val, a2_t,  a3_t,  b2_t,  b3_t,  fx_t);
printf('%-12s %6.2f %9.3f %9.3f %9.3f %9.3f %9.3f\n', 'Redondeado', val, a2_r,  a3_r,  b2_r,  b3_r,  fx_r);
printf('%s\n\n', repmat('-', 1, 67));

% Errores inciso A
[Ea_t, Er_t, ~] = lib.error(ex_fx, fx_t);
[Ea_r, Er_r, ~] = lib.error(ex_fx, fx_r);

printf('Errores - Forma directa:\n');
printf('  Truncado:   Ea=%.5f  Er=%.5f\n', Ea_t, Er_t);
printf('  Redondeado: Ea=%.5f  Er=%.5f\n\n', Ea_r, Er_r);

% =========================================================
% INCISO B: Forma anidada - metodo de Horner
%   f(x) = ((x - 6) * x + 3) * x - 0.149
% Menos operaciones intermedias => menos error acumulado
% =========================================================

% -- Truncado --
h1_t  = tr3(val - 6);
h2_t  = tr3(h1_t * val);
h3_t  = tr3(h2_t + 3);
h4_t  = tr3(h3_t * val);
fh_t  = tr3(h4_t - 0.149);

% -- Redondeado --
h1_r  = rd3(val - 6);
h2_r  = rd3(h1_r * val);
h3_r  = rd3(h2_r + 3);
h4_r  = rd3(h3_r * val);
fh_r  = rd3(h4_r - 0.149);

[Ea_ht, Er_ht, ~] = lib.error(ex_fx, fh_t);
[Ea_hr, Er_hr, ~] = lib.error(ex_fx, fh_r);

printf('Errores - Forma anidada (Horner):\n');
printf('  Truncado:   f(x)=%.3f  Ea=%.5f  Er=%.5f\n', fh_t, Ea_ht, Er_ht);
printf('  Redondeado: f(x)=%.3f  Ea=%.5f  Er=%.5f\n\n', fh_r, Ea_hr, Er_hr);

tiempo = toc;
printf('Tiempo de proceso: %.6f segundos\n', tiempo);

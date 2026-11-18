% Modelo Matemático:
% Aritmética de punto flotante a 3 dígitos con truncamiento tr(x):
% Operación en máquina: x (+) y = tr( tr(x) + tr(y) )
% Error Absoluto: Ea = |p - p*|
% Error Relativo: Er = Ea / |p|

% Ejercicio 3: Cálculos con truncamiento a 3 dígitos
printf('--- Ejercicio 3: Aritmética con truncamiento a 3 dígitos ---\n\n');

lib = libreria_tp2();
% Creamos un alias tr(x) para truncar a 3 dígitos directamente
tr = @(x) lib.truncar(x, 3);

tic;

% 1. Valores exactos (a 5 decimales)
p = [133.92100, 132.50100, 1.67300, 1.67300, 0.28571];

% 2. Operaciones con aritmética de máquina de 3 dígitos (truncamiento)
p_ast = [
    tr( tr(133) + tr(0.921) ),                   % a) 133 + 0.921
    tr( tr(133) - tr(0.499) ),                   % b) 133 - 0.499
    tr( tr(tr(121) - tr(119)) - tr(0.327) ),     % c) (121 - 119) - 0.327
    tr( tr(tr(121) - tr(0.327)) - tr(119) ),     % d) (121 - 0.327) - 119
    tr( tr(2/9) * tr(9/7) )                      % e) (2/9) * (9/7)
];

titulos = {
    '133 + 0.921',
    '133 - 0.499',
    '(121 - 119) - 0.327',
    '(121 - 0.327) - 119',
    '(2/9) * (9/7)'
};
letras = ['a', 'b', 'c', 'd', 'e'];

% 3. Cálculo de errores y muestra de resultados
for i = 1:length(p)
    [ea, er, er_porc] = lib.error(p(i), p_ast(i));
    
    printf('%c) %-22s -> Exacto: %9.5f | Aprox: %7.3f | Ea: %7.5f | Er: %8.6f (%6.4f%%)\n', ...
           letras(i), titulos{i}, p(i), p_ast(i), ea, er, er_porc);
end

tiempo = toc;
printf('\nTiempo de proceso: %.6f segundos\n', tiempo);

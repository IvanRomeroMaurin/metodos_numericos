% Modelo Matemático:
% Aritmética de punto flotante a 3 dígitos con redondeo fl(x):
% Operación en máquina: x (+) y = fl( fl(x) + fl(y) )
% Error Absoluto: Ea = |p - p*|
% Error Relativo: Er = Ea / |p|

% Ejercicio 2: Cálculos con redondeo a 3 dígitos
printf('--- Ejercicio 2: Aritmética con redondeo a 3 dígitos ---\n\n');

lib = libreria_tp2();
% Creamos un alias fl(x) para redondear a 3 dígitos directamente
fl = @(x) lib.redondear(x, 3);

tic;

% 1. Valores exactos (a 5 decimales)
p = [133.92100, 132.50100, 1.67300, 1.67300, 0.28571];

% 2. Operaciones con aritmética de máquina de 3 dígitos
p_ast = [
    fl( fl(133) + fl(0.921) ),                   % a) 133 + 0.921
    fl( fl(133) - fl(0.499) ),                   % b) 133 - 0.499
    fl( fl(fl(121) - fl(119)) - fl(0.327) ),     % c) (121 - 119) - 0.327
    fl( fl(fl(121) - fl(0.327)) - fl(119) ),     % d) (121 - 0.327) - 119
    fl( fl(2/9) * fl(9/7) )                      % e) (2/9) * (9/7)
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

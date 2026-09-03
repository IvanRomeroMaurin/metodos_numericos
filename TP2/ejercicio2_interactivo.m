% Ejercicio 2 - Versión Interactiva
% Aritmética de punto flotante a 3 dígitos con redondeo fl(x):
% Operación en máquina: x (+) y = fl( fl(x) + fl(y) )

printf('--- Ejercicio 2: Modo Interactivo (Redondeo a 3 dígitos) ---\n\n');

lib = libreria_tp2();
fl = @(x) lib.redondear(x, 3); % Alias para redondear a 3 dígitos

% Ingreso de datos
x = input('Ingrese el primer valor (x): ');
y = input('Ingrese el segundo valor (y): ');
printf('Operaciones disponibles:\n 1: Suma (+)\n 2: Resta (-)\n 3: Multiplicación (*)\n 4: División (/)\n');
op = input('Seleccione la operación (1-4): ');

% Variables para resultados
p = 0;
p_ast = 0;
op_str = '';

% Cálculo según la operación seleccionada
if op == 1
    p = x + y;
    p_ast = fl( fl(x) + fl(y) );
    op_str = '+';
elseif op == 2
    p = x - y;
    p_ast = fl( fl(x) - fl(y) );
    op_str = '-';
elseif op == 3
    p = x * y;
    p_ast = fl( fl(x) * fl(y) );
    op_str = '*';
elseif op == 4
    if y == 0
        error('Error matemático: No se puede dividir por cero.');
    end
    p = x / y;
    p_ast = fl( fl(x) / fl(y) );
    op_str = '/';
else
    error('Opción no válida. Debe seleccionar un número del 1 al 4.');
end

% Cálculo de errores
[ea, er, er_porc] = lib.error(p, p_ast);

% Muestra de resultados
printf('\n================ RESULTADOS ================\n');
printf('Operación        : %g %s %g\n', x, op_str, y);
printf('--------------------------------------------\n');
printf('Valor Exacto (p) : %9.5f\n', p);
printf('Valor Aprox (p*) : %9.5f\n', p_ast);
printf('Error Absoluto   : %9.5f\n', ea);
printf('Error Relativo   : %9.5f (%.4f%%)\n', er, er_porc);
printf('============================================\n');

% Modelo Matemático (Sucesión de Fibonacci):
% Sea F = {F_1, F_2, ..., F_N} con N = 200.
% Casos base:  F_1 = 0,  F_2 = 1
% Recurrencia: F_i = F_{i-1} + F_{i-2}  para i = 3, 4, ..., N

% Definimos la cantidad de términos
N = 200;

% Pre-asignamos memoria para el vector (buena práctica para rendimiento)
fib = zeros(1, N);

% Inicializamos los dos primeros términos de la sucesión
fib(1) = 0;
fib(2) = 1;

% Calculamos los siguientes términos mediante un bucle
for i = 3:N
    fib(i) = fib(i-1) + fib(i-2);
end

% Mostramos los resultados (por ejemplo, los primeros 10 y los últimos 5)
disp('Primeros 20 números de Fibonacci:');
disp(fib(1:20));

disp('Los 200 números de Fibonacci:');
disp(fib(1:N));
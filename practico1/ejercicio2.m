% Modelo Matemático:
% La suma de los elementos pares es: S = sum_{i=1}^{N} (X_i) para todo X_i tal que (X_i mod 2 == 0)

% Ejercicio 2: Suma de números pares entre 200 números positivos
printf('--- Ejercicio 2: Suma de números pares entre 200 números positivos ---\n\n');

function resultado = sumar_pares(valores)
    suma = 0;
    for i = 1:length(valores)
        if mod(valores(i), 2) == 0
            suma = suma + valores(i);
        end
        valores(i)
    end
    resultado = suma;
end

% Generamos 200 números enteros positivos aleatorios entre 1 y 1000
N = 200;
valores = randi([1, 1000], 1, N);

tic;
resultado = sumar_pares(valores);
tiempo = toc;

printf('Se generaron %d números enteros positivos de prueba.\n', N);
printf('Suma de los valores que son pares: %d\n', resultado);
printf('Tiempo de proceso: %.6f segundos\n', tiempo);

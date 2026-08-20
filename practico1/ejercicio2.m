% Ejercicio 2: Suma de números pares entre 200 números positivos
printf('--- Ejercicio 2: Suma de números pares entre 200 números positivos ---\n\n');

function resultado = sumar_pares(valores)
    suma = 0;
    for i = 1:length(valores)
        if mod(valores(i), 2) == 0
            suma = suma + valores(i);
        end
    end
    resultado = suma;
end

% Generamos 200 números enteros positivos aleatorios entre 1 y 1000
N = 200;
valores = randi([1, 1000], 1, N);

resultado = sumar_pares(valores);

printf('Se generaron %d números enteros positivos de prueba.\n', N);
printf('Suma de los valores que son pares: %d\n', resultado);

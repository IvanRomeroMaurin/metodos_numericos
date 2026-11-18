% Modelo Matemático:
% Sea X_i > 0 para i = 1..N. La suma total es: S = sum_{i=1}^N (X_i)

N_valores = input('Ingrese la cantidad de valores a ingresar: '); 

suma_simple = 0;
tic;
for i = 1:N_valores
    valor = input(sprintf('Ingrese el valor %d: ', i));
    while (valor <= 0)
        fprintf('El valor debe ser mayor a 0.\n');
        valor = input(sprintf('Ingrese el valor %d.0: ', i));
    endwhile
    suma_simple = suma_simple + valor;
end
tiempo = toc;

printf('Suma directa de los %d números ingresados: %.2f\n', N_valores, suma_simple);
printf('Tiempo de proceso: %.6f segundos\n', tiempo);


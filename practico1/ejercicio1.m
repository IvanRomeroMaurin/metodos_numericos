
N_valores = input('Ingrese la cantidad de valores a ingresar: '); 

suma_simple = 0;
for i = 1:N_valores
    valor = input(sprintf('Ingrese el valor %d: ', i));
    suma_simple = suma_simple + valor;
end

printf('Suma directa de los %d números ingresados: %.4f\n', N_valores, suma_simple);


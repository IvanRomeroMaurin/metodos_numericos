% Modelo Matemático Ejercicio 5:
% e = sum_{k=0}^{N} (1 / k!) = 1 + 1/1! + 1/2! + 1/3! + ... + 1/N!
% donde por definición 0! = 1.

n = input('Ingrese la cantidad de términos: ');

if n <= 0
    printf("Error: la cantidad de términos debe ser un número mayor a 0.\n")
    return
endif

tic;
e = 1;
fact = 1;

for i = 1:n
    fact = fact * i;
    e = e + (1/fact);
end
tiempo = toc;


printf('Valor aproximado de e con %d términos: %.8f\n', n, e);
printf('Tiempo de proceso: %.6f segundos\n', tiempo);
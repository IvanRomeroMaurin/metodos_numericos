% Modelo Matemático Ejercicio 8 (Serie de Taylor para e^x):
% e^x = sum_{i=0}^{n-1} [ (x^i) / i! ] = 1 + x + x^2/2! + x^3/3! + ... + x^(n-1)/(n-1)!

1;

n =  input("Ingrese los terminos a calcular: ");
x = input("Ingrese el numero del exponente x: ");

if n <= 0
    printf("Error el numero de  terminos debe ser mayor a 0.");
    return
endif

suma = 0;
for i = 0:(n-1)
    termino = (x^i) / factorial(i);
    suma = suma + termino;
endfor

printf("La suma de los primeros %d terminos de la serie es: %f \n", n, suma);
  


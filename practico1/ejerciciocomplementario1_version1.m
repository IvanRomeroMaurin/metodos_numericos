tic;
i = 0;
resultado  = 0;

while (resultado != 1/17)
    i = i + 1;
    resultado = ((-1)^i)/(2*i+1);
endwhile
tiempo = toc;

printf("La cantidad de terminos que tiene la sucesion es de %d\n", i);
printf('Tiempo de proceso: %.6f segundos\n', tiempo);

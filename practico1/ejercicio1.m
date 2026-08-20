
N_valores = 10; 


valores_simples = 1 + rand(1, N_valores) * 99;


suma_simple = 0;
for i = 1:N_valores
    suma_simple = suma_simple + valores_simples(i);
end

printf('Suma directa de los %d números aleatorios: %.4f\n', N_valores, suma_simple);


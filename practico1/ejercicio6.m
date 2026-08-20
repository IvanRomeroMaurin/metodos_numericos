% Modelo Matemático Ejercicio 6 (Serie de Leibniz para Pi):
% Pi se aproxima como el producto de 4 por una serie alternada de impares:
% Pi = 4 * sum_{k=0}^{inf} [ (-1)^k / (2*k + 1) ]
% Pi = 4 * (1 - 1/3 + 1/5 - 1/7 + 1/9 - ...)
%
% Condición de parada (tolerancia para d decimales exactos):
% error = |Pi_aproximado - pi| < 10^(-d)

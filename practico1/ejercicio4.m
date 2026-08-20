% Modelo Matemático (Ejercicio 4):
% Enunciado: 5x + 3x^2 = 3x + 1
% Reordenando a la forma estándar ax^2 + bx + c = 0:
% 3x^2 + 2x - 1 = 0
% Coeficientes: a = 3, b = 2, c = -1

a = 3;
b = 2;
c = -1;

discriminante = b^2 - 4*a*c;

if (discriminante >= 0)
    x1 = (-b + sqrt(discriminante)) / (2*a);
    x2 = (-b - sqrt(discriminante)) / (2*a); % Signo menos (-) para la segunda raíz
    fprintf('Las raíces son: x1 = %.2f y x2 = %.2f\n', x1, x2);
else
    fprintf('La ecuación no tiene raíces reales\n');
endif

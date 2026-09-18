---
name: octave-interpolacion
description: >-
  Métodos de interpolación polinómica y aproximación en Octave: Polinomio de Lagrange,
  Diferencias Divididas de Newton, evaluación con Horner, funciones nativas (polyfit, polyval, interp1)
  y trazadores cúbicos (splines).
---

# Interpolación y Ajuste de Curvas en Octave

Guía para implementar algoritmos clásicos de interpolación polinómica y utilizar las funciones nativas de Octave para aproximación de funciones y graficación.

---

## 1. Polinomio de Interpolación de Lagrange

Dados $n+1$ puntos $(x_0, y_0), (x_1, y_1), \dots, (x_n, y_n)$:

$$P(x) = \sum_{i=0}^n y_i L_i(x), \quad L_i(x) = \prod_{j=0, j \neq i}^n \frac{x - x_j}{x_i - x_j}$$

### Evaluación directa de Lagrange en un punto (o vector de puntos):
```octave
function y_eval = lagrange_eval(x_nodos, y_nodos, x_eval)
  n = length(x_nodos);
  y_eval = zeros(size(x_eval));

  for i = 1:n
    % Base de Lagrange L_i
    L = ones(size(x_eval));
    for j = 1:n
      if j ~= i
        L = L .* (x_eval - x_nodos(j)) / (x_nodos(i) - x_nodos(j));
      end
    end
    y_eval = y_eval + y_nodos(i) * L;
  end
end
```

---

## 2. Polinomio de Newton (Diferencias Divididas)

Forma:
$$P(x) = a_0 + a_1(x - x_0) + a_2(x - x_0)(x - x_1) + \dots + a_n(x - x_0)\dots(x - x_{n-1})$$

donde $a_k = f[x_0, x_1, \dots, x_k]$.

### Tabla de Diferencias Divididas:
```octave
function [coefs, tabla] = newton_dif_divididas(x, y)
  n = length(x);
  tabla = zeros(n, n);
  tabla(:, 1) = y(:);

  for j = 2:n
    for i = 1:n - j + 1
      tabla(i, j) = (tabla(i+1, j-1) - tabla(i, j-1)) / (x(i + j - 1) - x(i));
    end
  end

  coefs = tabla(1, :);  % Primera fila contiene los a_k
end
```

### Evaluación Eficiente (Forma Anidada / Horner):
```octave
function y_eval = newton_eval(coefs, x_nodos, x_eval)
  n = length(coefs);
  y_eval = coefs(n) * ones(size(x_eval));

  for i = n-1:-1:1
    y_eval = y_eval .* (x_eval - x_nodos(i)) + coefs(i);
  end
end
```

---

## 3. Funciones Nativas de Octave

Para validar tus algoritmos de clase o resolver problemas de ajuste rápido:

### `polyfit` y `polyval` (Polinomios en base canónica)
```octave
% Ajustar un polinomio de grado n
p = polyfit(x, y, grado);

% Evaluar el polinomio en nuevos puntos
y_est = polyval(p, x_nuevo);
```

### `interp1` (Interpolación 1D)
Permite interpolar con distintos métodos:
```octave
y_lin = interp1(x, y, x_eval, 'linear');
y_spline = interp1(x, y, x_eval, 'spline');
y_pchip = interp1(x, y, x_eval, 'pchip');  % Hermite cúbico preserva monotonía
```

### `spline` (Trazadores cúbicos)
```octave
y_cubico = spline(x, y, x_eval);
```

---

## 4. Visualización Completa: Nodos vs Curva Interpolante

```octave
% Datos de ejemplo
x_nodos = [0, 1, 2, 4, 5];
y_nodos = [1, 3, 2, 5, 4];

% Puntos para una curva suave
x_fino = linspace(min(x_nodos), max(x_nodos), 200);
y_lagrange = lagrange_eval(x_nodos, y_nodos, x_fino);

figure(1); clf;
plot(x_fino, y_lagrange, 'b-', 'LineWidth', 2, 'DisplayName', 'Polinomio Interpolante');
hold on;
plot(x_nodos, y_nodos, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', 'Nodos (x_i, y_i)');
grid on;
xlabel('x');
ylabel('y');
title('Interpolación Polinómica');
legend('Location', 'best');
hold off;
```

---

## 5. Fenómeno de Runge y Nodos de Chebyshev

* Al aumentar el grado del polinomio con nodos equiespaciados, pueden ocurrir oscilaciones salvajes en los extremos (Fenómeno de Runge).
* Para minimizar el error de interpolación en $[-1, 1]$, se utilizan los **nodos de Chebyshev**:
  $$x_k = \cos\left(\frac{2k - 1}{2n} \pi\right), \quad k = 1, \dots, n$$

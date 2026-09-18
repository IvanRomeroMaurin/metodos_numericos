---
name: octave-integracion
description: >-
  Integración y diferenciación numérica en Octave: Regla del Trapecio (simple y compuesta),
  Simpson 1/3 y 3/8, Cuadratura de Gauss-Legendre, diferencias finitas y funciones nativas (trapz, quad, integral).
---

# Integración y Diferenciación Numérica en Octave

Guía práctica para implementar cuadraturas numéricas y cálculo de derivadas por diferencias finitas en Octave.

---

## 1. Regla del Trapecio

Aproxima el área bajo la curva mediante trapecios.

### Trapecio Compuesto
Divide el intervalo $[a, b]$ en $n$ subintervalos de ancho $h = \frac{b - a}{n}$:

$$I \approx \frac{h}{2} \left[ f(a) + 2 \sum_{i=1}^{n-1} f(x_i) + f(b) \right]$$

```octave
function I = trapecio_compuesto(f, a, b, n)
  h = (b - a) / n;
  x = linspace(a, b, n + 1);
  y = f(x);

  % Suma ponderada
  I = (h / 2) * (y(1) + 2 * sum(y(2:end-1)) + y(end));
end
```

---

## 2. Regla de Simpson 1/3

Aproxima la función por parábolas de segundo grado.
* **Requisito para Simpson Compuesto:** $n$ debe ser **par** ($n+1$ puntos impares).

$$I \approx \frac{h}{3} \left[ f(a) + 4 \sum_{i \text{ impar}} f(x_i) + 2 \sum_{i \text{ par}} f(x_i) + f(b) \right]$$

```octave
function I = simpson13_compuesto(f, a, b, n)
  if mod(n, 2) ~= 0
    error('El número de subintervalos n debe ser par para Simpson 1/3.');
  end

  h = (b - a) / n;
  x = linspace(a, b, n + 1);
  y = f(x);

  suma_impares = sum(y(2:2:end-1));  % Coeficiente 4
  suma_pares   = sum(y(3:2:end-2));  % Coeficiente 2

  I = (h / 3) * (y(1) + 4 * suma_impares + 2 * suma_pares + y(end));
end
```

---

## 3. Regla de Simpson 3/8

Útil cuando el número de intervalos $n$ es múltiplo de 3 (aproxima con polinomios cúbicos):

$$I \approx \frac{3h}{8} [f(x_0) + 3f(x_1) + 3f(x_2) + f(x_3)]$$

```octave
function I = simpson38_simple(f, a, b)
  h = (b - a) / 3;
  x = a:h:b;
  y = f(x);
  I = (3 * h / 8) * (y(1) + 3*y(2) + 3*y(3) + y(4));
end
```

---

## 4. Cuadratura de Gauss-Legendre (2 y 3 Puntos)

Óptima para funciones suaves (máximo grado de exactitud polinomial con la menor cantidad de evaluaciones).

Transforma $[a, b] \to [-1, 1]$ mediante el cambio de variable:
$$x = \frac{b - a}{2} t + \frac{a + b}{2}, \quad dx = \frac{b - a}{2} dt$$

```octave
function I = gauss_legendre(f, a, b, puntos)
  switch puntos
    case 2
      % Nodos y pesos para n = 2
      t = [-1/sqrt(3), 1/sqrt(3)];
      w = [1, 1];
    case 3
      % Nodos y pesos para n = 3
      t = [-sqrt(3/5), 0, sqrt(3/5)];
      w = [5/9, 8/9, 5/9];
    otherwise
      error('Usar 2 o 3 puntos.');
  end

  % Cambio de variable
  x = ((b - a) / 2) * t + ((a + b) / 2);
  I = ((b - a) / 2) * sum(w .* f(x));
end
```

---

## 5. Funciones Nativas de Octave

* **Para vectores tabulados $(x, y)$:**
  ```octave
  I = trapz(x, y);  % Regla del trapecio sobre datos discretos
  ```
* **Para funciones continuas anónimas:**
  ```octave
  f = @(x) exp(-x.^2);
  I = quad(f, 0, 1);       % Cuadratura adaptativa de Simpson
  % o bien:
  I = integral(f, 0, 1);   % Cuadratura global adaptativa
  ```

---

## 6. Diferenciación Numérica por Diferencias Finitas

| Método | Fórmula | Error de truncamiento |
|--------|---------|-----------------------|
| **Adelantada** | $f'(x) \approx \frac{f(x + h) - f(x)}{h}$ | $O(h)$ |
| **Atrasada** | $f'(x) \approx \frac{f(x) - f(x - h)}{h}$ | $O(h)$ |
| **Centrada** | $f'(x) \approx \frac{f(x + h) - f(x - h)}{2h}$ | $O(h^2)$ *(mayor precisión)* |
| **Segunda derivada** | $f''(x) \approx \frac{f(x + h) - 2f(x) + f(x - h)}{h^2}$ | $O(h^2)$ |

```octave
% Función centrado para primera derivada
derivada_centrada = @(f, x, h) (f(x + h) - f(x - h)) / (2 * h);

% Segunda derivada centrada
segunda_derivada = @(f, x, h) (f(x + h) - 2*f(x) + f(x - h)) / (h^2);
```

---
name: octave-sistemas-lineales
description: >-
  Métodos directos e iterativos para sistemas de ecuaciones lineales Ax = b:
  Eliminación Gaussiana (simple y con pivoteo parcial), descomposición LU,
  sustitución hacia atrás, Jacobi y Gauss-Seidel en Octave.
---

# Sistemas de Ecuaciones Lineales en Octave ($A x = b$)

Guía de implementación de métodos directos e iterativos para resolver sistemas de ecuaciones lineales en Octave sin depender de toolboxes externas.

---

## 1. Verificación Rápida con Operadores Nativos

Octave resuelve sistemas lineales directamente usando el operador backslash `\`:

```octave
A = [4, 1, 2;
     2, 5, 1;
     1, 1, 4];
b = [16; 19; 13];

% Solución exacta/nativa
x_nativo = A \ b;
```

---

## 2. Sustitución Hacia Atrás (Back-Substitution)

Para una matriz triangular superior $U$:

$$x_i = \frac{b_i - \sum_{j=i+1}^n u_{ij} x_j}{u_{ii}}$$

```octave
function x = sustitucion_regresiva(U, b)
  n = length(b);
  x = zeros(n, 1);

  for i = n:-1:1
    if abs(U(i, i)) < eps
      error('Matriz singular: elemento diagonal nulo.');
    end
    suma = U(i, i+1:n) * x(i+1:n);
    x(i) = (b(i) - suma) / U(i, i);
  end
end
```

---

## 3. Eliminación Gaussiana Simple

Transforma $[A | b]$ en un sistema triangular superior escalonado:

```octave
function x = eliminacion_gaussiana(A, b)
  n = length(b);
  Ab = [A, b];  % Matriz aumentada

  for k = 1:n-1
    for i = k+1:n
      factor = Ab(i, k) / Ab(k, k);
      Ab(i, k:end) = Ab(i, k:end) - factor * Ab(k, k:end);
    end
  end

  % Resolver el sistema triangular superior resultante
  x = sustitucion_regresiva(Ab(:, 1:n), Ab(:, n+1));
end
```

---

## 4. Eliminación Gaussiana con Pivoteo Parcial

**¿Por qué usarlo?** Evita divisiones por cero y minimiza el error de redondeo intercambiando la fila actual con la fila que tenga el coeficiente de mayor valor absoluto en la columna del pivote.

```octave
function x = gauss_pivoteo_parcial(A, b)
  n = length(b);
  Ab = [A, b];

  for k = 1:n-1
    % Buscar fila con el pivote máximo en la columna k
    [max_val, p] = max(abs(Ab(k:n, k)));
    pivote_idx = k + p - 1;

    if max_val < eps
      error('El sistema no tiene solución única (matriz singular).');
    end

    % Swap de filas si es necesario
    if pivote_idx ~= k
      Ab([k, pivote_idx], :) = Ab([pivote_idx, k], :);
    end

    % Eliminación
    for i = k+1:n
      factor = Ab(i, k) / Ab(k, k);
      Ab(i, k:end) = Ab(i, k:end) - factor * Ab(k, k:end);
    end
  end

  x = sustitucion_regresiva(Ab(:, 1:n), Ab(:, n+1));
end
```

---

## 5. Descomposición LU ($A = L \cdot U$)

Factoriza $A$ de modo que $L y = b$ (sustitución progresiva) y luego $U x = y$ (sustitución regresiva).

### Descomposición LU básica (Doolittle, $L_{ii} = 1$):
```octave
function [L, U] = factorizacion_lu(A)
  n = size(A, 1);
  L = eye(n);
  U = A;

  for k = 1:n-1
    for i = k+1:n
      factor = U(i, k) / U(k, k);
      L(i, k) = factor;
      U(i, k:n) = U(i, k:n) - factor * U(k, k:n);
    end
  end
end
```

*En Octave nativo:* `[L, U, P] = lu(A);` donde $P \cdot A = L \cdot U$.

---

## 6. Métodos Iterativos: Jacobi y Gauss-Seidel

* **Condición de convergencia:** Si $A$ es **estrictamente diagonal dominante**, ambos convergen desde cualquier punto inicial:
  $$|a_{ii}| > \sum_{j \neq i} |a_{ij}| \quad \forall i$$

### Método de Jacobi
Todos los componentes de $x^{(k+1)}$ se calculan usando los valores del paso anterior $x^{(k)}$:

```octave
function [x, k] = jacobi(A, b, x0, tol, max_iter)
  n = length(b);
  x = x0;
  x_nuevo = zeros(n, 1);

  for k = 1:max_iter
    for i = 1:n
      suma = A(i, :) * x - A(i, i) * x(i);
      x_nuevo(i) = (b(i) - suma) / A(i, i);
    end

    % Criterio de parada con norma infinito
    if norm(x_nuevo - x, inf) / max(norm(x_nuevo, inf), eps) < tol
      x = x_nuevo;
      return;
    end
    x = x_nuevo;
  end
end
```

### Método de Gauss-Seidel
Utiliza inmediatamente los valores actualizados de la iteración en curso:

```octave
function [x, k] = gauss_seidel(A, b, x0, tol, max_iter)
  n = length(b);
  x = x0;

  for k = 1:max_iter
    x_ant = x;
    for i = 1:n
      suma = A(i, :) * x - A(i, i) * x(i);
      x(i) = (b(i) - suma) / A(i, i);
    end

    if norm(x - x_ant, inf) / max(norm(x, inf), eps) < tol
      return;
    end
  end
end
```

---

## 7. Buenas Prácticas y Consejos

* **Verificación de matriz diagonal dominante:**
  ```octave
  diag_dom = all(2 * abs(diag(A)) > sum(abs(A), 2));
  ```
* **Cálculo de error de residuo:**
  ```octave
  residuo = norm(b - A * x);
  ```
* **Normas útiles:**
  * `norm(v, inf)`: máximo valor absoluto (norma Chebyshev).
  * `norm(v, 2)`: norma euclídea clásica.

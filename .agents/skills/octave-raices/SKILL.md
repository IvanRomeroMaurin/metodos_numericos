---
name: octave-raices
description: >-
  Algoritmos y buenas prácticas para resolución de ecuaciones no lineales (f(x) = 0):
  Bisección, Regula Falsi, Punto Fijo, Newton-Raphson, Secante, criterios de parada
  y formato de tabla de iteraciones en Octave.
---

# Resolución de Ecuaciones No Lineales en Octave (f(x) = 0)

Guía práctica para implementar métodos numéricos de búsqueda de raíces con impresión prolija de iteraciones y control de convergencia.

---

## 1. Criterios de Parada

Siempre se deben combinar tres controles:
1. **Error absoluto entre pasos:** $|x_{k+1} - x_k| < \text{tol}$
2. **Error relativo aproximado:** $\frac{|x_{k+1} - x_k|}{|x_{k+1}|} < \text{tol}$ (evitar división por 0 si $x_{k+1} \approx 0$)
3. **Residuo de la función:** $|f(x_k)| < \text{tol}$
4. **Iteraciones máximas:** para evitar bucles infinitos por divergencia o ciclos.

```octave
function fin = cumple_parada(x_ant, x_act, fx_act, tol)
  fin = (abs(fx_act) < tol) || ...
        (abs(x_act - x_ant) < tol) || ...
        (abs(x_act) > eps && abs(x_act - x_ant) / abs(x_act) < tol);
end
```

---

## 2. Método de Bisección

* **Requisito:** $f(a) \cdot f(b) < 0$ (Teorema de Bolzano).
* **Número teórico de iteraciones:** $n \ge \frac{\ln(b - a) - \ln(\text{tol})}{\ln(2)}$.

```octave
function [c, k, tabla] = biseccion(f, a, b, tol, max_iter)
  if f(a) * f(b) >= 0
    error('El intervalo [a, b] no encierra un cambio de signo.');
  end

  printf('%-4s | %-12s | %-12s | %-12s | %-12s | %-12s\n', ...
         'k', 'a', 'b', 'c', 'f(c)', 'Error Rel');
  printf('%s\n', repmat('-', 1, 75));

  tabla = [];
  c_ant = a;

  for k = 1:max_iter
    c = (a + b) / 2;
    fc = f(c);
    err_rel = abs(c - c_ant) / abs(c);

    printf('%4d | %12.6f | %12.6f | %12.6f | %12.4e | %12.4e\n', ...
           k, a, b, c, fc, err_rel);

    tabla = [tabla; k, a, b, c, fc, err_rel];

    if abs(fc) < tol || (k > 1 && (b - a) / 2 < tol)
      return;
    end

    if f(a) * fc < 0
      b = c;
    else
      a = c;
    end
    c_ant = c;
  end
  warning('Se alcanzó el número máximo de iteraciones.');
end
```

---

## 3. Método de Regula Falsi (Falsa Posición)

Acelera la convergencia usando la recta secante en vez del punto medio:

$$c = b - \frac{f(b)(b - a)}{f(b) - f(a)}$$

```octave
function [c, k] = regula_falsi(f, a, b, tol, max_iter)
  fa = f(a); fb = f(b);
  if fa * fb >= 0
    error('f(a) y f(b) deben tener distinto signo.');
  end

  c_ant = a;
  for k = 1:max_iter
    c = b - fb * (b - a) / (fb - fa);
    fc = f(c);

    if abs(fc) < tol || abs(c - c_ant) < tol
      return;
    end

    if fa * fc < 0
      b = c; fb = fc;
    else
      a = c; fa = fc;
    end
    c_ant = c;
  end
end
```

---

## 4. Método de Newton-Raphson

Convergencia cuadrática cerca de una raíz simple:

$$x_{k+1} = x_k - \frac{f(x_k)}{f'(x_k)}$$

```octave
function [x, k] = newton_raphson(f, df, x0, tol, max_iter)
  x = x0;
  printf('%-4s | %-14s | %-14s | %-14s\n', 'k', 'x_k', 'f(x_k)', 'df(x_k)');
  printf('%s\n', repmat('-', 1, 55));

  for k = 1:max_iter
    fx = f(x);
    dfx = df(x);

    printf('%4d | %14.8f | %14.4e | %14.4e\n', k-1, x, fx, dfx);

    if abs(fx) < tol
      return;
    end

    if abs(dfx) < eps
      error('Derivada cercana a cero en x = %f', x);
    end

    x_nuevo = x - fx / dfx;
    if abs(x_nuevo - x) < tol
      x = x_nuevo;
      return;
    end
    x = x_nuevo;
  end
  warning('No convergió en %d iteraciones.', max_iter);
end
```

---

## 5. Método de la Secante

No requiere analíticamente la derivada $f'(x)$; aproxima la pendiente con los últimos dos puntos:

$$x_{k+1} = x_k - f(x_k) \frac{x_k - x_{k-1}}{f(x_k) - f(x_{k-1})}$$

```octave
function [x, k] = secante(f, x0, x1, tol, max_iter)
  f0 = f(x0);
  f1 = f(x1);

  for k = 1:max_iter
    if abs(f1 - f0) < eps
      error('División por cero en la secante.');
    end

    x2 = x1 - f1 * (x1 - x0) / (f1 - f0);
    f2 = f(x2);

    if abs(f2) < tol || abs(x2 - x1) < tol
      x = x2;
      return;
    end

    x0 = x1; f0 = f1;
    x1 = x2; f1 = f2;
  end
  x = x1;
end
```

---

## 6. Método de Punto Fijo

Transforma $f(x) = 0 \iff x = g(x)$.
* **Condición suficiente de convergencia:** $|g'(x)| < 1$ en un entorno de la raíz.

```octave
function [x, k] = punto_fijo(g, x0, tol, max_iter)
  x = x0;
  for k = 1:max_iter
    x_nuevo = g(x);
    if abs(x_nuevo - x) < tol
      x = x_nuevo;
      return;
    end
    x = x_nuevo;
  end
end
```

---

## 7. Tabla Comparativa

| Método | Orden de Conv. | Evaluaciones/paso | Requiere derivada | Robustez |
|--------|----------------|-------------------|-------------------|----------|
| **Bisección** | Lineal ($1$) | 1 ($f$) | No | Muy alta (siempre converge) |
| **Regula Falsi** | Lineal ($1$) | 1 ($f$) | No | Alta |
| **Secante** | Superlineal ($\approx 1.62$) | 1 ($f$) | No | Media (sensible a $x_0, x_1$) |
| **Newton-Raphson** | Cuadrática ($2$) | 2 ($f, f'$) | Sí | Media (sensible a $x_0$) |

---
name: octave-edo
description: >-
  Resolución numérica de EDOs (Problemas de Valor Inicial) en Octave:
  Método de Euler, Heun (Euler modificado), Runge-Kutta 4 (RK4), sistemas de EDOs
  y solvers nativos (ode45, lsode).
---

# Ecuaciones Diferenciales Ordinarias (EDO) en Octave

Guía para resolver Problemas de Valor Inicial (PVI) del tipo:
$$y' = f(t, y), \quad y(t_0) = y_0$$

---

## 1. Método de Euler (Primer Orden)

Aproximación por la recta tangente:
$$y_{i+1} = y_i + h \cdot f(t_i, y_i)$$

```octave
function [t, y] = euler(f, tspan, y0, n)
  t0 = tspan(1); tf = tspan(2);
  h = (tf - t0) / n;

  t = linspace(t0, tf, n + 1)';
  y = zeros(n + 1, length(y0));
  y(1, :) = y0;

  for i = 1:n
    y(i+1, :) = y(i, :) + h * f(t(i), y(i, :));
  end
end
```

---

## 2. Método de Heun (Euler Modificado / Predictor-Corrector)

Orden 2. Corrige la pendiente promediando los dos extremos:
* **Predictor:** $\tilde{y}_{i+1} = y_i + h \cdot f(t_i, y_i)$
* **Corrector:** $y_{i+1} = y_i + \frac{h}{2} [f(t_i, y_i) + f(t_{i+1}, \tilde{y}_{i+1})]$

```octave
function [t, y] = heun(f, tspan, y0, n)
  t0 = tspan(1); tf = tspan(2);
  h = (tf - t0) / n;

  t = linspace(t0, tf, n + 1)';
  y = zeros(n + 1, length(y0));
  y(1, :) = y0;

  for i = 1:n
    k1 = f(t(i), y(i, :));
    y_pred = y(i, :) + h * k1;
    k2 = f(t(i+1), y_pred);
    y(i+1, :) = y(i, :) + (h / 2) * (k1 + k2);
  end
end
```

---

## 3. Método de Runge-Kutta de 4º Orden (RK4)

Estándar de la industria para métodos explícitos (error local $O(h^5)$, global $O(h^4)$):

$$y_{i+1} = y_i + \frac{h}{6} (k_1 + 2k_2 + 2k_3 + k_4)$$

```octave
function [t, y] = rk4(f, tspan, y0, n)
  t0 = tspan(1); tf = tspan(2);
  h = (tf - t0) / n;

  t = linspace(t0, tf, n + 1)';
  y = zeros(n + 1, length(y0));
  y(1, :) = y0;

  for i = 1:n
    ti = t(i);
    yi = y(i, :);

    k1 = f(ti, yi);
    k2 = f(ti + h/2, yi + (h/2) * k1);
    k3 = f(ti + h/2, yi + (h/2) * k2);
    k4 = f(ti + h,   yi + h * k3);

    y(i+1, :) = yi + (h / 6) * (k1 + 2*k2 + 2*k3 + k4);
  end
end
```

---

## 4. Solvers Nativos de Octave (`ode45`)

Para verificar resultados o resolver ecuaciones rígidas/adaptativas:

```octave
% Definir la función diferencial: @(t, y)
f = @(t, y) -2 * y + 4 * exp(-t);

% Intervalo y condición inicial
tspan = [0, 5];
y0 = 1;

% Resolución adaptativa con Runge-Kutta-Fehlberg
[t_sol, y_sol] = ode45(f, tspan, y0);

% Graficación
plot(t_sol, y_sol, 'b-', 'LineWidth', 2);
grid on;
xlabel('Tiempo t');
ylabel('y(t)');
title('Solución numérica con ode45');
```

---

## 5. Sistemas de EDOs y EDOs de Orden Superior

Cualquier EDO de orden $n$ se transforma en un sistema de $n$ ecuaciones de primer orden:

**Ejemplo:** Oscilador armónico $y'' + 0.5 y' + 4 y = 0$
* Sea $u_1 = y$, $u_2 = y'$:
  $$\begin{cases} u_1' = u_2 \\ u_2' = -4 u_1 - 0.5 u_2 \end{cases}$$

```octave
% Vector de derivadas u' = [u1'; u2']
f_sistema = @(t, u) [u(2); -4 * u(1) - 0.5 * u(2)];

% Condiciones iniciales: [y(0), y'(0)]
u0 = [2; 0];
tspan = [0, 10];

[t, u] = ode45(f_sistema, tspan, u0);

% u(:, 1) es la posición, u(:, 2) es la velocidad
plot(t, u(:, 1), 'b-', t, u(:, 2), 'r--');
legend('Posición y(t)', 'Velocidad y''(t)');
grid on;
```

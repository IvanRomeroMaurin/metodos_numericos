---
name: octave-debug
description: >-
  Comandos de debugging y visualización en Octave: cómo inspeccionar variables,
  usar disp y printf, graficar con plot/figure, y medir rendimiento con tic/toc.
  Incluye técnicas para detectar errores numéricos y NaN/Inf.
---

# Debugging y Visualización en Octave

## Inspección de variables

```octave
x = 3.14;

disp(x)           % imprime el valor sin etiqueta
disp('mensaje')   % imprime un string

x                 % sin punto y coma: imprime automáticamente con etiqueta
whos              % lista todas las variables con tipo y tamaño
who               % lista solo los nombres
class(x)          % tipo de dato: 'double', 'char', 'logical', etc.
size(v)           % dimensiones de un vector/matriz
length(v)         % largo del mayor dimensión
```

## printf para depuración

```octave
% Útil para ver valores en cada iteración
for i = 1:5
  y = i^2;
  printf('i=%d  y=%f\n', i, y);
end

% Ver valores intermedios con etiqueta
printf('discriminante = %.6f\n', D);
printf('raiz_D = %.6f\n', raiz_D);
```

## Detectar valores problemáticos

```octave
isnan(x)    % true si x es NaN (resultado inválido, ej: 0/0)
isinf(x)    % true si x es Inf (ej: 1/0)
isfinite(x) % true si x es un número real finito

% Revisar si hay NaNs en un vector
any(isnan(v))
```

## Gráficos básicos

### Plot de una función
```octave
x = linspace(0, 2*pi, 100);  % 100 puntos entre 0 y 2π
y = sin(x);

figure;          % abre una ventana nueva
plot(x, y);
xlabel('x');
ylabel('sin(x)');
title('Función seno');
grid on;
```

### Múltiples curvas
```octave
figure;
plot(x, sin(x), 'b-', 'LineWidth', 2);   % azul, línea sólida
hold on;
plot(x, cos(x), 'r--', 'LineWidth', 2);  % rojo, línea punteada
legend('sin(x)', 'cos(x)');
grid on;
hold off;
```

### Graficar error vs iteración
```octave
errores = [0.5, 0.2, 0.08, 0.01, 0.003];

figure;
semilogy(errores, 'o-');   % escala logarítmica en Y
xlabel('Iteración');
ylabel('Error');
title('Convergencia');
grid on;
```

## Medición de rendimiento

```octave
tic;
% ... código a medir ...
tiempo = toc;
printf('Tiempo de proceso: %.6f segundos\n', tiempo);
```

## Errores comunes y cómo leerlos

| Mensaje | Causa probable |
|---|---|
| `undefined symbol 'x'` | Variable no definida antes de usarla |
| `nonconformant arguments` | Dimensiones incompatibles en operación matricial |
| `invalid call to script` | Llamaste un script con `()` como si fuera función |
| `warning: division by zero` | División entre cero → resultado `Inf` |
| resultado `NaN` | Operación `0/0`, `Inf - Inf`, `sqrt(-1)`, etc. |

## Tip: formatear salida para revisar resultados

```octave
format long;    % muestra 15 dígitos significativos
x = pi
format short;   % vuelve a 4 decimales (por defecto)
x = pi
```

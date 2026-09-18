---
name: octave-sintaxis
description: >-
  Guía de sintaxis básica de Octave: variables, tipos, operadores, estructuras
  de control (if, for, while), printf, input, funciones anónimas y comandos útiles
  como abs(), floor(), fix(), round(), sqrt(), factorial(), exp(), log10().
---

# Sintaxis Básica de Octave

## Variables y tipos
```octave
x = 3.14;          % número real (double por defecto)
n = 5;             % entero
s = 'hola';        % string
flag = true;       % booleano
```

## Operadores aritméticos
| Operador | Descripción |
|----------|-------------|
| `+` `-` `*` `/` | Suma, resta, multiplicación, división |
| `^` | Potencia (`x^2`) |
| `mod(a, b)` | Módulo (resto) |

## Estructuras de control

### if / elseif / else
```octave
if x > 0
  printf('positivo\n');
elseif x < 0
  printf('negativo\n');
else
  printf('cero\n');
end
```

### for
```octave
for i = 1:5
  printf('i = %d\n', i);
end

% Con paso personalizado
for k = 0:0.5:2
  printf('k = %.1f\n', k);
end
```

### while
```octave
n = 1;
while n < 10
  n = n * 2;
end
```

## Entrada y salida
```octave
x = input('Ingrese un valor: ');   % lee del usuario
printf('El valor es: %.4f\n', x); % imprime formateado
disp(x);                           % imprime sin formato
```

### Formato de printf
| Especificador | Uso |
|---|---|
| `%d` | Entero |
| `%f` | Real (por defecto 6 decimales) |
| `%.4f` | Real con 4 decimales |
| `%e` o `%.2e` | Notación científica |
| `%s` | String |
| `%g` | Elige entre %f y %e automáticamente |

## Funciones matemáticas útiles
```octave
abs(x)          % valor absoluto
sqrt(x)         % raíz cuadrada
x^n             % potencia
exp(x)          % e^x
log(x)          % logaritmo natural
log10(x)        % logaritmo base 10
floor(x)        % redondeo hacia abajo
ceil(x)         % redondeo hacia arriba
round(x)        % redondeo al más cercano
fix(x)          % truncamiento hacia cero
mod(a, b)       % módulo
factorial(n)    % n!
sign(x)         % signo: -1, 0 o 1
```

## Funciones anónimas
```octave
f  = @(x) x^2 + 1;          % función de una variable
g  = @(x, y) x + y;         % función de dos variables
rd = @(x) lib.redondear(x, 4); % alias para función de librería

% Uso
f(3)    % devuelve 10
g(2, 5) % devuelve 7
```

## Medición de tiempo
```octave
tic;
% ... código a medir ...
tiempo = toc;
printf('Tiempo: %.6f segundos\n', tiempo);
```

## Comandos de utilidad
```octave
clc;          % limpia la consola
clear;        % borra todas las variables
format long;  % muestra más decimales
format short; % vuelve al formato por defecto (4 decimales)
nargin;       % cantidad de argumentos recibidos en una función
```

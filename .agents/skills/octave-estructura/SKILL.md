---
name: octave-estructura
description: >-
  Cómo estructurar scripts y funciones en Octave: diferencia entre scripts y
  funciones, cómo definir funciones con múltiples retornos, cómo usar structs
  para agrupar funciones (patrón librería), y buenas prácticas de organización.
---

# Estructura de Scripts y Funciones en Octave

## Scripts vs Funciones

| | Script `.m` | Función `.m` |
|---|---|---|
| Primera línea | Código directo | `function ...` |
| Tiene argumentos | No | Sí |
| Tiene retorno | No | Sí |
| Cómo se llama | `nombre` | `nombre(args)` |
| Variables | Comparte workspace | Workspace propio |

## Definir una función

```octave
% archivo: mi_funcion.m
function resultado = mi_funcion(x)
  resultado = x^2 + 1;
end
```

### Múltiples valores de retorno
```octave
function [ea, er] = calcular_error(p, p_ast)
  ea = abs(p - p_ast);
  er = ea / abs(p);
end

% Uso:
[error_abs, error_rel] = calcular_error(3.14159, 3.14);
```

### Argumentos opcionales con nargin
```octave
function res = redondear(x, k, normalizar)
  if nargin < 3          % si no se pasó el 3er argumento
    normalizar = true;   % valor por defecto
  end
  % ... lógica ...
end

% Se puede llamar con 2 o 3 argumentos:
redondear(3.1416, 4)
redondear(3.1416, 4, false)
```

## Patrón librería con struct (usado en el TP2)

Agrupa funciones relacionadas en un struct para usarlas como módulo:

```octave
% archivo: mi_libreria.m
function lib = mi_libreria()
  lib.sumar    = @sumar_impl;
  lib.restar   = @restar_impl;
  lib.error    = @calcular_error;
end

function r = sumar_impl(a, b)
  r = a + b;
end

function r = restar_impl(a, b)
  r = a - b;
end

function [ea, er] = calcular_error(p, p_ast)
  ea = abs(p - p_ast);
  er = ea / abs(p);
end
```

```octave
% Uso en cualquier script:
lib = mi_libreria();
lib.sumar(3, 4)      % devuelve 7
lib.restar(10, 3)    % devuelve 7
```

## Funciones anónimas como alias

```octave
lib = libreria_tp2();

% Alias cortos para no repetir argumentos
rd4 = @(x) lib.redondear(x, 4);
tr3 = @(x) lib.truncar(x, 3);

% Uso limpio
rd4(3.14159)   % redondea a 4 dígitos
tr3(22.1841)   % trunca a 3 dígitos
```

## Buenas prácticas

- Un archivo `.m` = una función pública (con mismo nombre que el archivo)
- Las funciones auxiliares van **después** de la función principal en el mismo archivo
- Usar `%` para comentarios y `% ---` para separar secciones
- No usar `clc; clear` en funciones, solo en scripts interactivos
- Preferiir `printf` sobre `disp` para control de formato

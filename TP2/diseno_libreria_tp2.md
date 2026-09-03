# GUÍA TP2 - DISEÑO Y ARQUITECTURA DE FUNCIONES
## Modularización y Simulación de Aritmética de Máquina en Octave

---

### 1. ¿Por qué crear funciones en lugar de calcular a mano?

En lugar de resolver las operaciones en una calculadora o a mano y escribir los números resultantes fijos en el código (por ejemplo: `p_ast = 134`), creamos funciones para que **Octave simule el comportamiento del procesador** con aritmética finita de `k` dígitos.

Esto nos permite:
* Automatizar los cálculos de los Ejercicios 2, 3, 4 y 5.
* Evitar errores humanos de cálculo o redondeo intermedio.
* Tener un código modular, reutilizable y prolijo.

---

### 2. Fundamento Matemático del Punto Flotante

Cualquier número real no nulo `x` en base 10 normalizado se representa como:
```text
x = m * 10^e
```
donde:
* `e` es el exponente entero.
* `m` es la mantisa normalizada, tal que `0.1 <= |m| < 1`.

#### A. ¿Cómo obtenemos el exponente `e` y la mantisa `m` en Octave?
1. Si `x == 0`, el resultado es `0`.
2. Para `x != 0`:
   * El exponente `e` se obtiene con el logaritmo base 10:
     ```matlab
     e = floor(log10(abs(x))) + 1;
     ```
     *Ejemplo:* Para `x = 133`:
     `log10(133) = 2.1238` -> `floor(2.1238) = 2` -> `e = 2 + 1 = 3`.
   * La mantisa `m` se obtiene dividiendo por `10^e`:
     ```matlab
     m = x / (10^e);
     ```
     *Ejemplo:* `133 / 10^3 = 0.133` (la mantisa queda normalizada entre 0.1 y 1).

#### B. ¿Cómo aplicamos Redondeo a `k` dígitos?
Multiplicamos la mantisa por `10^k`, aplicamos `round()` (redondea al entero más próximo) y volvemos a dividir por `10^k`:
```matlab
m_red = round(m * (10^k)) / (10^k);
resultado = m_red * (10^e);
```
*Ejemplo con k = 3 para m = 0.133921:*
* `0.133921 * 10^3 = 133.921`
* `round(133.921) = 134`
* `134 / 10^3 = 0.134`
* Reconstrucción: `0.134 * 10^3 = 134`.

#### C. ¿Cómo aplicamos Truncamiento a `k` dígitos?
Multiplicamos la mantisa por `10^k`, aplicamos `fix()` (corte directo hacia cero sin redondear) y volvemos a dividir por `10^k`:
```matlab
m_trunc = fix(m * (10^k)) / (10^k);
resultado = m_trunc * (10^e);
```
*Ejemplo con k = 3 para m = 0.133921:*
* `fix(133.921) = 133`
* `133 / 10^3 = 0.133`
* Reconstrucción: `0.133 * 10^3 = 133`.

#### D. Cálculo de Errores
```matlab
Ea = abs(p - p_ast);
Er = Ea / abs(p);
```

---

### 3. ¿Se pueden dejar todas las funciones juntas en un solo archivo como librería?

**Sí, pero con una particularidad de cómo funciona Octave/MATLAB:**

En Octave, cuando un archivo tiene varias funciones, **solo la primera función (la principal)** es visible desde otros scripts. Las funciones que están debajo se consideran "funciones privadas / locales".

Para empaquetar todas las funciones en **un solo archivo llamado `libreria_tp2.m`** y usarlo como una verdadera librería, se usa el mecanismo estándar de **Handles de Funciones en una estructura (`struct`)**:

```matlab
% Archivo: libreria_tp2.m
function lib = libreria_tp2()
    % Retornamos una estructura con punteros/handles a las funciones
    lib.error     = @calcular_error;
    lib.redondear = @redondear_k;
    lib.truncar   = @truncar_k;
end

% --- Funciones internas ---
function [ea, er] = calcular_error(p, p_ast)
    ea = abs(p - p_ast);
    er = ea / abs(p);
end

function res = redondear_k(x, k)
    if x == 0
        res = 0;
        return;
    end
    e = floor(log10(abs(x))) + 1;
    m = x / (10^e);
    m_red = round(m * (10^k)) / (10^k);
    res = m_red * (10^e);
end

function res = truncar_k(x, k)
    if x == 0
        res = 0;
        return;
    end
    e = floor(log10(abs(x))) + 1;
    m = x / (10^e);
    m_trunc = fix(m * (10^k)) / (10^k);
    res = m_trunc * (10^e);
end
```

### 4. ¿Cómo se usaría desde cualquier ejercicio?

En `ejercicio2.m` o `ejercicio3.m`, solo haces:

```matlab
lib = libreria_tp2();  % Cargamos la librería una sola vez

% Uso de redondeo a 3 dígitos:
op1 = lib.redondear(133, 3);
op2 = lib.redondear(0.921, 3);
p_ast = lib.redondear(op1 + op2, 3);

% Uso de cálculo de error:
[ea, er] = lib.error(133.921, p_ast);
```

#### Ventajas de este enfoque:
1. **Un solo archivo adicional** (`libreria_tp2.m`) en lugar de llenar la carpeta de archivos sueltos.
2. Sintaxis súper limpia y profesional: `lib.redondear(...)`, `lib.truncar(...)`, `lib.error(...)`.
3. Totalmente compatible con GNU Octave y MATLAB.

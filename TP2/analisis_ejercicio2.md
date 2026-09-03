# GUÍA DE LABORATORIO N° 2 - MÉTODOS COMPUTACIONALES
## Análisis y Resolución - Ejercicio 2

---

### 1. Conceptos Fundamentales

#### Fórmulas de Error (en texto plano)
* **Error Absoluto (Ea):**
  ```text
  Ea = |p - p*|
  ```
  *(Diferencia en valor absoluto entre el valor exacto 'p' y el aproximado 'p*')*

* **Error Relativo (Er):**
  ```text
  Er = Ea / |p|
  ```
  *(Error absoluto dividido por el valor exacto)*

* **Error Relativo Porcentual [Er (%)]:**
  ```text
  Er(%) = Er * 100%
  ```

---

### 2. Aritmética de Punto Flotante a 3 Dígitos con Redondeo

Un número normalizado a 3 dígitos significativos en base 10 tiene la forma:
```text
± 0.d1 d2 d3 * 10^k    (donde d1 no puede ser cero)
```

**Regla de Redondeo a 3 dígitos:**
Se observa el cuarto dígito (`d4`):
* Si `d4 >= 5`: se suma 1 al tercer dígito (`d3`).
* Si `d4 < 5`: el tercer dígito (`d3`) se queda igual.

---

### 3. Resolución Paso a Paso de los Casos

#### **Caso a: 133 + 0.921**
* **Valor exacto:**
  ```text
  p = 133 + 0.921 = 133.921
  ```
* **Aritmética a 3 dígitos (normalizado con redondeo):**
  1. Normalizamos los números:
     * `133   = 0.133000 * 10^3`
     * `0.921 = 0.000921 * 10^3`  (alineando al exponente 10^3)
  2. Sumamos:
     * `(0.133 + 0.000921) * 10^3 = 0.133921 * 10^3`
  3. Redondeamos a 3 dígitos (el 4to dígito es 9 >= 5):
     * `p* = 0.134 * 10^3 = 134`
* **Errores:**
  * `Ea = |133.921 - 134| = 0.079`
  * `Er = 0.079 / 133.921 = 0.0005899`
  * `Er(%) = 0.0590%`

---

#### **Caso b: 133 - 0.499**
* **Valor exacto:**
  ```text
  p = 133 - 0.499 = 132.501
  ```
* **Aritmética a 3 dígitos (normalizado con redondeo):**
  1. Normalizamos:
     * `133   = 0.133000 * 10^3`
     * `0.499 = 0.000499 * 10^3`
  2. Restamos:
     * `(0.133 - 0.000499) * 10^3 = 0.132501 * 10^3`
  3. Redondeamos a 3 dígitos (el 4to dígito es 5 >= 5):
     * `p* = 0.133 * 10^3 = 133`
* **Errores:**
  * `Ea = |132.501 - 133| = 0.499`
  * `Er = 0.499 / 132.501 = 0.003766`
  * `Er(%) = 0.3766%`

---

#### **Caso c: (121 - 119) - 0.327**
* **Valor exacto:**
  ```text
  121 - 119 = 2
  p = 2 - 0.327 = 1.673
  ```
* **Aritmética a 3 dígitos (normalizado con redondeo):**
  1. Primer cálculo `(121 - 119)`:
     * `0.121 * 10^3 - 0.119 * 10^3 = 0.002 * 10^3`
     * Normalizado a 3 dígitos: `0.200 * 10^1 = 2`
  2. Segundo cálculo `2 - 0.327`:
     * `0.200 * 10^1 - 0.0327 * 10^1 = 0.1673 * 10^1`
  3. Redondeamos a 3 dígitos (el 4to dígito es 3 < 5):
     * `p* = 0.167 * 10^1 = 1.67`
* **Errores:**
  * `Ea = |1.673 - 1.67| = 0.003`
  * `Er = 0.003 / 1.673 = 0.001793`
  * `Er(%) = 0.1793%`

---

#### **Caso d: (121 - 0.327) - 119**
* **Valor exacto:**
  ```text
  p = 1.673   (mismo resultado matemático que el caso c)
  ```
* **Aritmética a 3 dígitos (normalizado con redondeo):**
  1. Primer cálculo `(121 - 0.327)`:
     * `0.121 * 10^3 - 0.000327 * 10^3 = 0.120673 * 10^3`
     * Redondeo a 3 dígitos (el 4to dígito es 6 >= 5):
     * Resultado parcial = `0.121 * 10^3 = 121`
     * *(Observación: el 0.327 se perdió por completo al redondear)*
  2. Segundo cálculo `121 - 119`:
     * `0.121 * 10^3 - 0.119 * 10^3 = 0.002 * 10^3`
     * Normalizado: `p* = 0.200 * 10^1 = 2`
* **Errores:**
  * `Ea = |1.673 - 2| = 0.327`
  * `Er = 0.327 / 1.673 = 0.195457`
  * `Er(%) = 19.5457%`

> **Conclusión clave entre (c) y (d):**
> En computación numérica, **la suma y resta no son asociativas**.
> En (c) restamos primero los números grandes y el error fue solo de `0.18%`.
> En (d) restamos el número pequeño al grande y el error creció a casi `20%`.

---

#### **Caso e: (2/9) * (9/7)**
* **Valor exacto:**
  ```text
  p = 2 / 7 = 0.28571   (con 5 decimales)
  ```
* **Aritmética a 3 dígitos (normalizado con redondeo):**
  1. Normalizamos cada factor a 3 dígitos:
     * `2/9 = 0.2222...` -> redondeado a 3 dígitos: `0.222 * 10^0 = 0.222`
     * `9/7 = 1.2857...` -> normalizado: `0.12857... * 10^1` -> redondeado: `0.129 * 10^1 = 1.29`
  2. Multiplicamos:
     * `0.222 * 1.29 = 0.28638 = 0.28638 * 10^0`
  3. Redondeamos el resultado a 3 dígitos (el 4to dígito es 3 < 5):
     * `p* = 0.286 * 10^0 = 0.286`
* **Errores:**
  * `Ea = |0.28571 - 0.286| = 0.00029`
  * `Er = 0.00029 / 0.28571 = 0.001015`
  * `Er(%) = 0.1015%`

---

### 4. Tabla Resumen Comparativa

| Inciso | Operación | Valor Exacto (p) | Valor Aprox (p*) | Error Absoluto (Ea) | Error Relativo (Er) | Error Relativo (%) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **a** | 133 + 0.921 | 133.92100 | 134.00000 | 0.07900 | 0.000590 | 0.0590% |
| **b** | 133 - 0.499 | 132.50100 | 133.00000 | 0.49900 | 0.003766 | 0.3766% |
| **c** | (121 - 119) - 0.327 | 1.67300 | 1.67000 | 0.00300 | 0.001793 | 0.1793% |
| **d** | (121 - 0.327) - 119 | 1.67300 | 2.00000 | 0.32700 | 0.195457 | 19.5457% |
| **e** | (2/9) * (9/7) | 0.28571 | 0.28600 | 0.00029 | 0.001015 | 0.1015% |

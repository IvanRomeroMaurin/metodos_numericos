# GUÍA DE LABORATORIO N° 2 - MÉTODOS COMPUTACIONALES
## Análisis y Resolución - Ejercicio 3

---

### 1. Aritmética de Punto Flotante a 3 Dígitos con Truncamiento

Un número normalizado a 3 dígitos significativos en base 10 tiene la forma:
```text
± 0.d1 d2 d3 * 10^k    (donde d1 no puede ser cero)
```

**Regla de Truncamiento a 3 dígitos:**
Se descartan todos los dígitos a partir del cuarto dígito (`d4`) sin importar su valor.

---

### 2. Resolución Paso a Paso de los Casos

#### **Caso a: 133 + 0.921**
* **Valor exacto:**
  ```text
  p = 133 + 0.921 = 133.921
  ```
* **Aritmética a 3 dígitos (normalizado con truncamiento):**
  1. Normalizamos los números:
     * `133   = 0.133000 * 10^3`
     * `0.921 = 0.000921 * 10^3`
  2. Sumamos:
     * `(0.133 + 0.000921) * 10^3 = 0.133921 * 10^3`
  3. Truncamos a 3 dígitos:
     * `p* = 0.133 * 10^3 = 133`
* **Errores:**
  * `Ea = |133.921 - 133| = 0.921`
  * `Er = 0.921 / 133.921 = 0.006877`
  * `Er(%) = 0.6877%`

---

#### **Caso b: 133 - 0.499**
* **Valor exacto:**
  ```text
  p = 133 - 0.499 = 132.501
  ```
* **Aritmética a 3 dígitos (normalizado con truncamiento):**
  1. Normalizamos:
     * `133   = 0.133000 * 10^3`
     * `0.499 = 0.000499 * 10^3`
  2. Restamos:
     * `(0.133 - 0.000499) * 10^3 = 0.132501 * 10^3`
  3. Truncamos a 3 dígitos:
     * `p* = 0.132 * 10^3 = 132`
* **Errores:**
  * `Ea = |132.501 - 132| = 0.501`
  * `Er = 0.501 / 132.501 = 0.003781`
  * `Er(%) = 0.3781%`

---

#### **Caso c: (121 - 119) - 0.327**
* **Valor exacto:**
  ```text
  121 - 119 = 2
  p = 2 - 0.327 = 1.673
  ```
* **Aritmética a 3 dígitos (normalizado con truncamiento):**
  1. Primer cálculo `(121 - 119)`:
     * `0.121 * 10^3 - 0.119 * 10^3 = 0.002 * 10^3`
     * Normalizado a 3 dígitos: `0.200 * 10^1 = 2`
  2. Segundo cálculo `2 - 0.327`:
     * `0.200 * 10^1 - 0.0327 * 10^1 = 0.1673 * 10^1`
  3. Truncamos a 3 dígitos:
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
* **Aritmética a 3 dígitos (normalizado con truncamiento):**
  1. Primer cálculo `(121 - 0.327)`:
     * `0.121 * 10^3 - 0.000327 * 10^3 = 0.120673 * 10^3`
     * Truncamos a 3 dígitos:
     * Resultado parcial = `0.120 * 10^3 = 120`
  2. Segundo cálculo `120 - 119`:
     * `0.120 * 10^3 - 0.119 * 10^3 = 0.001 * 10^3`
     * Normalizado: `p* = 0.100 * 10^1 = 1.0`
* **Errores:**
  * `Ea = |1.673 - 1.0| = 0.673`
  * `Er = 0.673 / 1.673 = 0.402271`
  * `Er(%) = 40.2271%`

> **Conclusión clave entre (c) y (d) y diferencia con redondeo:**
> Nuevamente se evidencia que la resta de números de magnitud similar amplifica el error de truncamiento anterior, generando una pérdida de cifras significativas muy severa en el caso d. En comparación con el ejercicio 2 (redondeo), el truncamiento genera errores mayores (40% vs 20%).

---

#### **Caso e: (2/9) * (9/7)**
* **Valor exacto:**
  ```text
  p = 2 / 7 = 0.28571   (con 5 decimales)
  ```
* **Aritmética a 3 dígitos (normalizado con truncamiento):**
  1. Normalizamos cada factor a 3 dígitos truncando:
     * `2/9 = 0.2222...` -> truncado a 3 dígitos: `0.222 * 10^0 = 0.222`
     * `9/7 = 1.2857...` -> normalizado: `0.12857... * 10^1` -> truncado: `0.128 * 10^1 = 1.28`
  2. Multiplicamos:
     * `0.222 * 1.28 = 0.28416 = 0.28416 * 10^0`
  3. Truncamos el resultado a 3 dígitos:
     * `p* = 0.284 * 10^0 = 0.284`
* **Errores:**
  * `Ea = |0.28571 - 0.284| = 0.00171`
  * `Er = 0.00171 / 0.28571 = 0.005985`
  * `Er(%) = 0.5985%`

---

### 3. Tabla Resumen Comparativa (Truncamiento vs Redondeo)

| Inciso | Valor Exacto (p) | Aprox (p*) Truncado | Error Relativo (%) Trunc | Error Relativo (%) Redond |
| :--- | :--- | :--- | :--- | :--- |
| **a** | 133.92100 | 133.000 | 0.6877% | 0.0590% |
| **b** | 132.50100 | 132.000 | 0.3781% | 0.3766% |
| **c** | 1.67300 | 1.670 | 0.1793% | 0.1793% |
| **d** | 1.67300 | 1.000 | 40.2271% | 19.5457% |
| **e** | 0.28571 | 0.284 | 0.5985% | 0.1015% |

**Conclusión Final:**
En todos los casos evaluados, el método de truncamiento arrojó errores iguales o superiores (en algunos casos, notablemente mayores, como el inciso d y el a) que el método de redondeo simétrico utilizado en el Ejercicio 2.

---
name: octave-matrices
description: >-
  Manejo de vectores y matrices en Octave: creación, indexación, operaciones
  elemento a elemento vs matriciales, funciones útiles (zeros, ones, eye, linspace,
  size, length, sum, max, min) y operaciones comunes de álgebra lineal.
---

# Vectores y Matrices en Octave

## Crear vectores

```octave
v = [1, 2, 3, 4, 5];          % vector fila
w = [1; 2; 3; 4; 5];          % vector columna
r = 1:5;                       % [1 2 3 4 5]  (rango con paso 1)
r = 1:2:9;                     % [1 3 5 7 9]  (paso 2)
r = linspace(0, 1, 5);        % [0 0.25 0.5 0.75 1]  (5 puntos equiespaciados)
```

## Crear matrices

```octave
A = [1, 2, 3;
     4, 5, 6;
     7, 8, 9];     % matriz 3x3

zeros(3, 2)        % matriz 3x2 de ceros
ones(2, 4)         % matriz 2x4 de unos
eye(3)             % matriz identidad 3x3
rand(2, 2)         % matriz 2x2 con valores aleatorios en [0,1]
```

## Indexación

```octave
v = [10, 20, 30, 40, 50];

v(1)          % primer elemento: 10  (índices empiezan en 1)
v(end)        % último elemento: 50
v(2:4)        % elementos 2 a 4: [20 30 40]
v([1,3,5])    % elementos 1, 3 y 5: [10 30 50]

A = [1,2,3; 4,5,6; 7,8,9];
A(2, 3)       % fila 2, columna 3: 6
A(1, :)       % toda la fila 1: [1 2 3]
A(:, 2)       % toda la columna 2: [2; 5; 8]
A(2:3, 1:2)   % submatriz filas 2-3, columnas 1-2
```

## Operaciones elemento a elemento vs matriciales

```octave
A = [1, 2; 3, 4];
B = [5, 6; 7, 8];

A * B        % multiplicación MATRICIAL
A .* B       % multiplicación ELEMENTO A ELEMENTO

A ^ 2        % potencia MATRICIAL (A*A)
A .^ 2       % cuadrado de CADA ELEMENTO

A / B        % división matricial (A * inv(B))
A ./ B       % división ELEMENTO A ELEMENTO
```

## Funciones útiles sobre vectores/matrices

```octave
v = [3, 1, 4, 1, 5, 9, 2];

length(v)       % cantidad de elementos: 7
size(A)         % [filas, columnas] de una matriz
size(A, 1)      % número de filas
size(A, 2)      % número de columnas
numel(A)        % total de elementos

sum(v)          % suma de todos: 25
prod(v)         % producto de todos
min(v)          % mínimo: 1
max(v)          % máximo: 9
mean(v)         % promedio
sort(v)         % ordena de menor a mayor
find(v > 3)     % índices donde se cumple la condición

% Para matrices, operan por columna por defecto:
sum(A)          % suma de cada columna
sum(A, 2)       % suma de cada fila
```

## Álgebra lineal

```octave
A = [2, 1; 5, 3];
b = [4; 7];

det(A)          % determinante
inv(A)          % inversa
A'              % transpuesta
rank(A)         % rango

x = A \ b       % resolver sistema Ax = b (más estable que inv(A)*b)
```

## Iterar sobre vectores

```octave
v = [10, 20, 30, 40];

% Opción 1: índice
for i = 1:length(v)
  printf('v(%d) = %d\n', i, v(i));
end

% Opción 2: directamente sobre valores
for val = v
  printf('val = %d\n', val);
end
```

## Construir vectores de resultados en un loop

```octave
n = 5;
errores = zeros(1, n);   % pre-alocar (más eficiente que crecer dinámicamente)

for i = 1:n
  errores(i) = 1 / i;
end

disp(errores)
```

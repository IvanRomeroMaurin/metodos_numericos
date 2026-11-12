1; % script con funciones locales

function valor_redondeado = redondear_decimales(valor, cantidad_decimales)
  % Redondea 'valor' a 'cantidad_decimales' digitos decimales (convencion de la catedra).
  % cantidad_decimales <= 0 devuelve el valor sin cambios (precision completa).
  if nargin < 2 || cantidad_decimales <= 0
    valor_redondeado = valor;
    return;
  end
  valor_redondeado = round(valor * 10 ^ cantidad_decimales) / 10 ^ cantidad_decimales;
end

function solucion = eliminacion_gauss(matriz_coeficientes, vector_b, cantidad_decimales)
  % Resuelve matriz_coeficientes * x = vector_b por Eliminacion de Gauss.
  % Formula de la catedra: a'_ij = a_ij - (a_ik * a_kj) / a_kk, redondeando
  % el termino completo a 'cantidad_decimales' digitos decimales.
  cantidad_incognitas = size(matriz_coeficientes, 1);
  matriz_aumentada = redondear_decimales([matriz_coeficientes, vector_b(:)], cantidad_decimales);

  printf('\nMatriz aumentada inicial [A|b]:\n');
  disp(matriz_aumentada);

  for etapa = 1:cantidad_incognitas-1
    pivote = matriz_aumentada(etapa, etapa);
    for fila = etapa+1:cantidad_incognitas
      factor_fila = matriz_aumentada(fila, etapa);
      matriz_aumentada(fila, etapa) = 0;
      for columna = etapa+1:cantidad_incognitas+1
        termino_reduccion = redondear_decimales((factor_fila * matriz_aumentada(etapa, columna)) / pivote, cantidad_decimales);
        matriz_aumentada(fila, columna) = redondear_decimales(matriz_aumentada(fila, columna) - termino_reduccion, cantidad_decimales);
      end
    end
    printf('-- Matriz tras la etapa %d (pivote a_%d%d = %.4g):\n', etapa, etapa, etapa, pivote);
    disp(matriz_aumentada);
  end

  solucion = zeros(cantidad_incognitas, 1);
  for fila = cantidad_incognitas:-1:1
    suma_acumulada = 0;
    for columna = fila+1:cantidad_incognitas
      suma_acumulada = redondear_decimales(suma_acumulada + redondear_decimales(matriz_aumentada(fila, columna) * solucion(columna), cantidad_decimales), cantidad_decimales);
    end
    solucion(fila) = redondear_decimales(redondear_decimales(matriz_aumentada(fila, cantidad_incognitas+1) - suma_acumulada, cantidad_decimales) / matriz_aumentada(fila, fila), cantidad_decimales);
  end
end

% ===================================================================
% PROGRAMA PRINCIPAL
% Ejercicio 1 (sistemas no homogeneos): formula alimenticia para ganado
% Resuelto con el Metodo de Eliminacion de Gauss, aritmetica de redondeo
% a 'cantidad_decimales' digitos decimales (convencion de la catedra)
% ===================================================================
clear; clc;
disp('============================================================');
disp(' EJERCICIO 1 - FORMULA ALIMENTICIA (ELIMINACION DE GAUSS)');
disp('============================================================');

matriz_coeficientes = input("\nIngrese la matriz de nutrientes por alimento A\n(ej: [80 15 35 60; 28 72 57 25; 20 20 12 20; 50 10 20 60]): ");
vector_requerimientos = input('Ingrese el vector de requerimientos diarios b (ej: [230; 180; 80; 160]): ');
vector_costos = input('Ingrese el vector de costos por kg de cada alimento (ej: [18; 5; 7; 20]): ');
cantidad_decimales = input('Ingrese la cantidad de digitos decimales a usar en el redondeo (ej: 3): ');

cantidad_alimentos = length(vector_requerimientos);
nombres_alimentos = cell(1, cantidad_alimentos);
for i = 1:cantidad_alimentos
  nombres_alimentos{i} = input(sprintf('  Nombre del alimento %d (ej: Maiz): ', i), 's');
end

tic;
solucion_aproximada = eliminacion_gauss(matriz_coeficientes, vector_requerimientos, cantidad_decimales);
tiempo_proceso = toc;

% Solucion de referencia en doble precision, para medir el efecto del redondeo
solucion_exacta = matriz_coeficientes \ vector_requerimientos(:);
costo_total_aproximado = redondear_decimales(vector_costos(:)' * solucion_aproximada, cantidad_decimales);
costo_total_exacto = vector_costos(:)' * solucion_exacta;

printf('\n============================================================\n');
printf(' RESULTADOS OBTENIDOS\n');
printf('============================================================\n');
printf('%-14s %14s %14s %12s\n', 'Alimento', sprintf('Gauss(%ddec)', cantidad_decimales), 'Exacto', 'Error abs.');
disp('------------------------------------------------------------');
for i = 1:cantidad_alimentos
  printf('%-14s %14.4f %14.6f %12.4e\n', nombres_alimentos{i}, solucion_aproximada(i), solucion_exacta(i), ...
    abs(solucion_aproximada(i) - solucion_exacta(i)));
end
disp('------------------------------------------------------------');
printf('Costo total (%d dec.) : $ %.2f\n', cantidad_decimales, costo_total_aproximado);
printf('Costo total (exacto)  : $ %.2f\n', costo_total_exacto);
printf('Error relativo (norma inf.): %.4e\n', norm(solucion_aproximada - solucion_exacta, inf) / norm(solucion_exacta, inf));

if all(solucion_aproximada > 0)
  disp('Verificacion: la formula contiene los cuatro alimentos (todas las cantidades son positivas).');
else
  disp('ALERTA: alguna cantidad resulto no positiva, revisar el planteo.');
end
printf('Tiempo de proceso: %.6f segundos\n', tiempo_proceso);
printf('============================================================\n');

figure('Name', 'Ejercicio 1 - Formula alimenticia');
subplot(1, 2, 1);
bar([solucion_aproximada, solucion_exacta]);
set(gca, 'xticklabel', nombres_alimentos);
legend(sprintf('Gauss (%d dec.)', cantidad_decimales), 'Exacto');
ylabel('Cantidad [kg]'); title('Composicion de la formula alimenticia'); grid on;

subplot(1, 2, 2);
pie(vector_costos(:)' .* solucion_aproximada');
legend(nombres_alimentos, 'Location', 'eastoutside');
title(sprintf('Distribucion de costos ($%.2f)', costo_total_aproximado));

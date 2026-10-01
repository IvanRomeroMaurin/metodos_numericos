% Ejercicio 3: Metodo de Iteracion y Aceleracion de Aitken
printf('--- Ejercicio 3: Metodo de Iteracion con Aceleracion de Aitken ---\n\n');

f = @(x) 5*x - 200*log(400/(500-x)) - 1000;
g = @(x) (1000 + 200*log(400/(500-x))) / 5;

valor_inicial      = input('Ingrese el valor inicial x0: ');
tolerancia         = input('Ingrese la cota de error: ');
usar_aitken        = input('Desea usar Aceleracion de Aitken? (1=Si, 0=No): ');

maximo_iteraciones = 100;

derivada_g = @(x) 200 / (5 * (500 - x));
printf('\nCondicion de convergencia en x0 = %.6f:\n', valor_inicial);
printf("  |g'(x0)| = %.6f ", abs(derivada_g(valor_inicial)));
if abs(derivada_g(valor_inicial)) < 1
  printf('< 1 El metodo CONVERGE en este entorno.\n\n');
else
  printf('>= 1 ADVERTENCIA: el metodo puede no converger.\n\n');
end

tic;

if usar_aitken == 0
  printf('--- Metodo de Iteracion ---\n\n');

  x = valor_inicial;
  printf('x_0 = %.6f\n\n', x);

  for iteracion = 1:maximo_iteraciones
    x_siguiente = g(x);
    error_actual = abs(x_siguiente - x);

    printf('x_%d = g(x_%d) = %.6f   E = |x_%d - x_%d| = |%.6f - %.6f| = %.8f\n', ...
           iteracion, iteracion-1, x_siguiente, iteracion, iteracion-1, x_siguiente, x, error_actual);

    x_anterior = x;
    x = x_siguiente;
    if error_actual < tolerancia
      break;
    end
  end

  printf('\nE = |x_%d - x_%d| = |%.6f - %.6f| = %.8f < %.8f  --> Criterio cumplido\n', ...
         iteracion, iteracion-1, x, x_anterior, error_actual, tolerancia);

  printf('\nRaiz aproximada: x = %.6f\n', x);
  printf('f(x) = %.8f\n', f(x));
  printf('Iteraciones: %d\n', iteracion);



else
  printf('--- Metodo de Iteracion con Aceleracion de Aitken ---\n\n');

  x = valor_inicial;
  idx = 0;
  printf('  x_%d   = %.6f\n\n', idx, x);

  for iteracion = 1:maximo_iteraciones
    x_uno = g(x);
    x_dos = g(x_uno);

    denominador = x_dos - 2*x_uno + x;
    if abs(denominador) < eps
      printf('Denominador muy pequeno, se detiene.\n');
      x = x_uno;
      break;
    end

    x_aitken = x_dos - (x_dos - x_uno)^2 / denominador;
    x_check  = g(x_aitken);
    error_actual = abs(x_check - x_aitken);

    printf('  x_%d   = g(x_%d) = %.6f\n',   idx+1, idx,   x_uno);
    printf('  x_%d   = g(x_%d) = %.6f\n',   idx+2, idx+1, x_dos);
    printf('  x_%d   = %.6f  (Aitken)\n',   idx+3,        x_aitken);
    printf('  x_%d   = g(x_%d) = %.6f   E = |x_%d - x_%d| = |%.6f - %.6f| = %.8f\n\n', ...
           idx+4, idx+3, x_check, idx+4, idx+3, x_check, x_aitken, error_actual);

    if error_actual < tolerancia
      x = x_aitken;
      break;
    end
    idx = idx + 4;
    x = x_aitken;
  end

  printf('E = |x_%d - x_%d| = |%.6f - %.6f| = %.8f < %.8f  --> Criterio cumplido\n', ...
         idx+4, idx+3, x_check, x_aitken, error_actual, tolerancia);
  printf('\nRaiz aproximada (Aitken): x = %.6f\n', x);
  printf('f(x) = %.8f\n', f(x));
  printf('Iteraciones: %d (%d ciclos de Aitken)\n', idx+4, iteracion);
end



tiempo = toc;
printf('\nTiempo de proceso: %.6f segundos\n', tiempo);

x_valores = linspace(150, 250, 500);
g_valores = (1000 + 200*log(400 ./ (500 - x_valores))) / 5;

figure(1);
plot(x_valores, x_valores, 'r--', 'LineWidth', 1.5);
hold on;
plot(x_valores, g_valores, 'b-', 'LineWidth', 2);
plot(x, x, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
hold off;

xlabel('x');
ylabel('y');
title('Metodo de Iteracion: Punto Fijo x = g(x)');
legend('y = x', 'y = g(x)', 'Punto fijo (raiz)', 'Location', 'northwest');
grid on;


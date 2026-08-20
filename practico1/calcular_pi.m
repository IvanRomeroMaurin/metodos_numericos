function [n_terminos, aprox, tiempo] = calcular_pi(cifras)
  tol = 0.5 * 10^(-cifras);
  t0 = cputime;
  suma = 0;
  n = 0;
  signo = 1;
  while true
    termino = signo / (2*n + 1);
    suma = suma + termino;
    aprox = 4 * suma;
    n = n + 1;
    signo = -signo;
    if abs(aprox - pi) < tol
      break;
    end
  end
  n_terminos = n;
  tiempo = cputime - t0;
end
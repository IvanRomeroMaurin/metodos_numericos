% =========================================================================
% LIBRERÍA DE FUNCIONES REUTILIZABLES - TP2
% Métodos Computacionales
% =========================================================================

function lib = libreria_tp2()
    % LIBRERIA_TP2 Inicializa y retorna un struct con las funciones de la librería.
    % 
    % Retorna:
    %   lib (struct): Estructura que contiene punteros a las funciones:
    %       - error: Calcula el error absoluto, relativo y relativo porcentual.
    %       - punto_flotante: Obtiene la representación en punto flotante normalizado.
    %       - redondear: Aproxima un número usando redondeo a k dígitos.
    %       - truncar: Aproxima un número usando truncamiento a k dígitos.
    
    % Retornamos una estructura con las funciones disponibles
    lib.error          = @calcular_error;
    lib.punto_flotante = @punto_flotante;
    lib.redondear      = @redondear_k;
    lib.truncar        = @truncar_k;
end

% -------------------------------------------------------------------------
% 1. Función para cálculo de errores
% -------------------------------------------------------------------------
function [ea, er, er_porc] = calcular_error(p, p_ast)
    % CALCULAR_ERROR Calcula los errores absoluto, relativo y relativo porcentual.
    %
    % Parámetros:
    %   p     (double): Valor exacto o verdadero.
    %   p_ast (double): Valor aproximado.
    %
    % Retorna:
    %   ea      (double): Error absoluto (|p - p_ast|).
    %   er      (double): Error relativo (ea / |p|).
    %   er_porc (double): Error relativo porcentual (er * 100).
    
    ea = abs(p - p_ast);
    er = ea / abs(p);
    er_porc = er * 100;
end

% -------------------------------------------------------------------------
% 2. Función para obtener la representación en punto flotante normalizado
% -------------------------------------------------------------------------
function [signo, m, e] = punto_flotante(x)
    % PUNTO_FLOTANTE Calcula la representación en punto flotante normalizado.
    % Convierte un número real a la forma: signo * m * 10^e, donde 0.1 <= m < 1.
    %
    % Parámetros:
    %   x (double): Número a normalizar.
    %
    % Retorna:
    %   signo (int):    Signo del número (1 positivo, -1 negativo, 0 si es cero).
    %   m     (double): Mantisa normalizada en el rango [0.1, 1).
    %   e     (int):    Exponente entero (base 10).
    
    if x == 0
        signo = 0;
        m = 0;
        e = 0;
        return;
    end
    
    signo = sign(x);
    x_abs = abs(x);
    
    % Calculamos el exponente de normalización (0.1 <= m < 1)
    e = floor(log10(x_abs)) + 1;
    m = x_abs / (10^e);
end

% -------------------------------------------------------------------------
% 3. Función de representación en punto flotante normalizado con REDONDEO
%    a k dígitos significativos: +- 0.d1 d2 ... dk * 10^e
% -------------------------------------------------------------------------
function res = redondear_k(x, k)
    % REDONDEAR_K Aproxima un número en punto flotante normalizado a k dígitos por redondeo.
    %
    % Parámetros:
    %   x (double): Número real original a redondear.
    %   k (int):    Cantidad de dígitos significativos para redondear la mantisa.
    %
    % Retorna:
    %   res (double): Valor aproximado mediante redondeo simétrico.
    
    if x == 0
        res = 0;
        return;
    end
    
    [signo, m, e] = punto_flotante(x);
    
    % Redondeo a k dígitos
    m_red = round(m * (10^k)) / (10^k);
    
    res = signo * m_red * (10^e);
end

% -------------------------------------------------------------------------
% 4. Función de representación en punto flotante normalizado con TRUNCAMIENTO
%    a k dígitos significativos (corte directo hacia cero)
% -------------------------------------------------------------------------
function res = truncar_k(x, k)
    % TRUNCAR_K Aproxima un número en punto flotante normalizado a k dígitos por truncamiento.
    %
    % Parámetros:
    %   x (double): Número real original a truncar.
    %   k (int):    Cantidad de dígitos significativos para truncar la mantisa.
    %
    % Retorna:
    %   res (double): Valor aproximado mediante corte (truncamiento) hacia cero.
    
    if x == 0
        res = 0;
        return;
    end
    
    [signo, m, e] = punto_flotante(x);
    
    % Truncamiento a k dígitos
    m_trunc = fix(m * (10^k)) / (10^k);
    
    res = signo * m_trunc * (10^e);
end

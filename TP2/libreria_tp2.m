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
    %       - normalizar: Aplica representación normalizada con una función de corte.
    %       - redondear: Aproxima un número usando redondeo a k dígitos (opcional: normalizar).
    %       - truncar: Aproxima un número usando truncamiento a k dígitos (opcional: normalizar).
    
    % Retornamos una estructura con las funciones disponibles
    lib.error          = @calcular_error;
    lib.punto_flotante = @punto_flotante;
    lib.normalizar     = @normalizar;
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
% 3. Función auxiliar para normalizar y procesar la mantisa
% -------------------------------------------------------------------------
function res = normalizar(x, k, func_corte)
    % NORMALIZAR Extrae la mantisa normalizada, aplica la función
    % de corte (round o fix) a k dígitos y reconstruye el número.
    [signo, m, e] = punto_flotante(x);
    m_aproximada = func_corte(m * (10^k)) / (10^k);
    res = signo * m_aproximada * (10^e);
end

% -------------------------------------------------------------------------
% 4. Función de representación con REDONDEO a k dígitos
% -------------------------------------------------------------------------
function res = redondear_k(x, k, usar_normalizacion)
    % REDONDEAR_K Aproxima un número a k dígitos por redondeo simétrico.
    %
    % Parámetros:
    %   x                  (double):  Número real original a redondear.
    %   k                  (int):     Cantidad de dígitos.
    %   usar_normalizacion (boolean): Opcional (por defecto true).
    %                                 - true:  Normaliza a punto flotante (k cifras significativas).
    %                                 - false: Redondea directamente a k decimales.
    %
    % Retorna:
    %   res (double): Valor aproximado mediante redondeo simétrico.
    
    if nargin < 3 || isempty(usar_normalizacion)
        usar_normalizacion = true;
    end
    
    if x == 0
        res = 0;
        return;
    end
    
    if usar_normalizacion
        res = normalizar(x, k, @round);
    else
        res = round(x * (10^k)) / (10^k);
    end
end

% -------------------------------------------------------------------------
% 5. Función de representación con TRUNCAMIENTO a k dígitos
% -------------------------------------------------------------------------
function res = truncar_k(x, k, usar_normalizacion)
    % TRUNCAR_K Aproxima un número a k dígitos por truncamiento hacia cero.
    %
    % Parámetros:
    %   x                  (double):  Número real original a truncar.
    %   k                  (int):     Cantidad de dígitos.
    %   usar_normalizacion (boolean): Opcional (por defecto true).
    %                                 - true:  Normaliza a punto flotante (k cifras significativas).
    %                                 - false: Trunca directamente a k decimales.
    %
    % Retorna:
    %   res (double): Valor aproximado mediante truncamiento hacia cero.
    
    if nargin < 3 || isempty(usar_normalizacion)
        usar_normalizacion = true;
    end
    
    if x == 0
        res = 0;
        return;
    end
    
    if usar_normalizacion
        res = normalizar(x, k, @fix);
    else
        res = fix(x * (10^k)) / (10^k);
    end
end


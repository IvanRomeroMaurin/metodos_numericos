% =========================================================================
% LIBRERÍA DE FUNCIONES REUTILIZABLES - TP2
% Métodos Computacionales
% =========================================================================

function lib = libreria_tp2()
    % Retornamos una estructura con las funciones disponibles
    lib.error     = @calcular_error;
    lib.redondear = @redondear_k;
    lib.truncar   = @truncar_k;
end

% -------------------------------------------------------------------------
% 1. Función para cálculo de errores
% -------------------------------------------------------------------------
function [ea, er, er_porc] = calcular_error(p, p_ast)
    ea = abs(p - p_ast);
    er = ea / abs(p);
    er_porc = er * 100;
end

% -------------------------------------------------------------------------
% 2. Función de representación en punto flotante normalizado con REDONDEO
%    a k dígitos significativos: +- 0.d1 d2 ... dk * 10^e
% -------------------------------------------------------------------------
function res = redondear_k(x, k)
    if x == 0
        res = 0;
        return;
    end
    
    signo = sign(x);
    x_abs = abs(x);
    
    % Calculamos el exponente de normalización (0.1 <= m < 1)
    e = floor(log10(x_abs)) + 1;
    m = x_abs / (10^e);
    
    % Redondeo a k dígitos
    m_red = round(m * (10^k)) / (10^k);
    
    res = signo * m_red * (10^e);
end

% -------------------------------------------------------------------------
% 3. Función de representación en punto flotante normalizado con TRUNCAMIENTO
%    a k dígitos significativos (corte directo hacia cero)
% -------------------------------------------------------------------------
function res = truncar_k(x, k)
    if x == 0
        res = 0;
        return;
    end
    
    signo = sign(x);
    x_abs = abs(x);
    
    % Calculamos el exponente de normalización (0.1 <= m < 1)
    e = floor(log10(x_abs)) + 1;
    m = x_abs / (10^e);
    
    % Truncamiento a k dígitos
    m_trunc = fix(m * (10^k)) / (10^k);
    
    res = signo * m_trunc * (10^e);
end

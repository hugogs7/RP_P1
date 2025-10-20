% ----------------------------------------
% Puzzle de termómetros - Modelo lógico
% ----------------------------------------

% Hechos del dominio: dim(N), cell(X,Y,Symbol), row_sum(Row,Val), col_sum(Col,Val)
% Salida esperada: fill(X,Y) → la celda (X,Y) está llena de mercurio

% ----------------------------------------------------------
% 1. Dominio de las celdas
% ----------------------------------------------------------
row(1..N) :- dim(N).
col(1..N) :- dim(N).

% ----------------------------------------------------------
% 2. Decisión: una celda puede estar llena o vacía
% ----------------------------------------------------------
{ fill(X,Y) } :- row(X), col(Y).

% ----------------------------------------------------------
% 3. Restricciones de las filas y columnas
% ----------------------------------------------------------
% La suma de celdas llenas por fila debe coincidir con row_sum
:- row_sum(R,V), V != #count { C : fill(R,C) }.

% La suma de celdas llenas por columna debe coincidir con col_sum
:- col_sum(C,V), V != #count { R : fill(R,C) }.

% ----------------------------------------------------------
% 4. Restricciones del termómetro (regla principal)
% ----------------------------------------------------------
% Si una celda está llena, todas las celdas desde la bombilla hasta esa celda deben estar llenas.
% (Dependiendo de la orientación del termómetro)

% Ejemplo para termómetros verticales y horizontales:
:- cell(X,Y,'U'), fill(X2,Y), X2 < X.         % Si la bombilla apunta arriba, no puede llenarse por debajo
:- cell(X,Y,'D'), fill(X2,Y), X2 > X.         % Si apunta abajo, no puede llenarse por encima
:- cell(X,Y,'L'), fill(X,Y2), Y2 < Y.         % Si apunta izquierda, no puede llenarse por la derecha
:- cell(X,Y,'R'), fill(X,Y2), Y2 > Y.         % Si apunta derecha, no puede llenarse por la izquierda

% ----------------------------------------------------------
% 5. Asegurar que solo se llenan celdas pertenecientes a termómetros
% ----------------------------------------------------------
valid_symbol('U';'D';'L';'R';'^';'v';'>';'<').
:- fill(X,Y), not cell(X,Y,S), valid_symbol(S).

% ----------------------------------------------------------
% Mostrar la salida
% ----------------------------------------------------------
#show fill/2.

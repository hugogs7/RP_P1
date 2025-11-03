% thermo.lp  -- Encoding para thermometers con curvas (curved thermometers)
% Hechos esperados en domain.lp:
%   dim(N).
%   bulb(Row,Col,Dir).   Dir = up|down|left|right
%   seg(Row,Col,DirSeg). DirSeg = up|down|left|right
%   curve(Row,Col,Type). Type = 0..3   % 0: └ (up/right), 1: ┏ (right/down), 2: ┐? (down/left), 3: ┘? (left/up)
%   colCount(Col,Num).
%   rowCount(Row,Num).
%
% Notas sobre curvas (según la especificación):
% Types are clockwise rotations of an L:
%  0: └  -> ports {up, right}
%  1: ┏  -> ports {right, down}
%  2: ┐  -> ports {down, left}
%  3: ┘  -> ports {left, up}
% For each curve type, entering from one port forces the exit to the other port (turn).

% --- celdas existentes (bulb, seg o curve) ---
cell(R,C) :- bulb(R,C,_).
cell(R,C) :- seg(R,C,_).
cell(R,C) :- curve(R,C,_).

% --- dirección del bulb (útil para la posición inicial) ---
dir(BR,BC,D) :- bulb(BR,BC,D).

% --- definición de lados/opuestos ---
opposite(up,down).
opposite(down,up).
opposite(left,right).
opposite(right,left).

% --- puertos (sides) que tiene cada curve type ---
% type 0: up <-> right
curve_port(0,up).
curve_port(0,right).
% type 1: right <-> down
curve_port(1,right).
curve_port(1,down).
% type 2: down <-> left
curve_port(2,down).
curve_port(2,left).
% type 3: left <-> up
curve_port(3,left).
curve_port(3,up).

% --- salida (exit) de una curva dado el tipo y el lado por el que se entra
% exit_type(Type,EnterSide,ExitSide)
exit_type(0,up,right).
exit_type(0,right,up).
exit_type(1,right,down).
exit_type(1,down,right).
exit_type(2,down,left).
exit_type(2,left,down).
exit_type(3,left,up).
exit_type(3,up,left).

% --- pos(BR,BC,Row,Col,Idx,OutDir)
%   significa: en el termómetro con bulbo en (BR,BC), la celda (Row,Col) está en posición Idx
%   y su "salida" (dirección hacia la siguiente celda del termómetro) es OutDir.
% posición inicial (la del bulb) tiene OutDir = dir del bulb
pos(BR,BC,BR,BC,1,Out) :- bulb(BR,BC,Out).

% --- transición: avanzar desde una posición siguiendo OutDir hacia la celda vecina
% movimiento a la derecha
pos(BR,BC,Row,Col2,Idx+1,NextOut) :-
    pos(BR,BC,Row,Col1,Idx, right),
    Col2 = Col1 + 1,
    % caso: la celda vecina es un segmento recto orientado right (misma dirección)
    seg(Row,Col2,right),
    NextOut = right.

% movimiento a la izquierda
pos(BR,BC,Row,Col2,Idx+1,NextOut) :-
    pos(BR,BC,Row,Col1,Idx, left),
    Col2 = Col1 - 1,
    seg(Row,Col2,left),
    NextOut = left.

% movimiento hacia arriba
pos(BR,BC,Row2,Col,Idx+1,NextOut) :-
    pos(BR,BC,Row1,Col,Idx, up),
    Row2 = Row1 - 1,
    seg(Row2,Col,up),
    NextOut = up.

% movimiento hacia abajo
pos(BR,BC,Row2,Col,Idx+1,NextOut) :-
    pos(BR,BC,Row1,Col,Idx, down),
    Row2 = Row1 + 1,
    seg(Row2,Col,down),
    NextOut = down.

% --- transiciones que atraviesan una curva: entrar por un lado y salir por el otro
% Si la celda vecina es curve(Type) y tiene puerto en el lado de entrada (entrada = opposite(Out)),
% entonces la salida NextOut viene dada por exit_type(Type, EnterSide, NextOut).
% Entrada desde la izquierda (si salimos hacia right)
pos(BR,BC,Row,Col2,Idx+1,NextOut) :-
    pos(BR,BC,Row,Col1,Idx,right),
    Col2 = Col1 + 1,
    Enter = left,                         % entramos en (Row,Col2) desde su lado izquierdo
    curve(Row,Col2,Type),
    curve_port(Type,Enter),
    exit_type(Type,Enter,NextOut).

% Entrada desde la derecha (si salimos hacia left)
pos(BR,BC,Row,Col2,Idx+1,NextOut) :-
    pos(BR,BC,Row,Col1,Idx,left),
    Col2 = Col1 - 1,
    Enter = right,
    curve(Row,Col2,Type),
    curve_port(Type,Enter),
    exit_type(Type,Enter,NextOut).

% Entrada desde abajo (si salimos hacia up)
pos(BR,BC,Row2,Col,Idx+1,NextOut) :-
    pos(BR,BC,Row1,Col,Idx,up),
    Row2 = Row1 - 1,
    Enter = down,
    curve(Row2,Col,Type),
    curve_port(Type,Enter),
    exit_type(Type,Enter,NextOut).

% Entrada desde arriba (si salimos hacia down)
pos(BR,BC,Row2,Col,Idx+1,NextOut) :-
    pos(BR,BC,Row1,Col,Idx,down),
    Row2 = Row1 + 1,
    Enter = up,
    curve(Row2,Col,Type),
    curve_port(Type,Enter),
    exit_type(Type,Enter,NextOut).

% --- Una celda participa en la posición I de un termómetro si hay algún pos con ese índice (ignoramos OutDir)
pos_index(BR,BC,R,C,I) :- pos(BR,BC,R,C,I,_).

% --- Cada celda pertenece como mucho a un termómetro (si la entrada es válida esto ya se cumple,
%     pero dejamos la regla descomentada por seguridad si se desea usarla)
% :- pos_index(BR1,BC1,Row,Col,_), pos_index(BR2,BC2,Row,Col,_), (BR1,BC1) != (BR2,BC2).

% --- Elección de llenado (puede llenarse cualquier celda existente)
{ fill(Row,Col) } :- cell(Row,Col).

% Monotonía: si una posición J está llena, todas las posiciones anteriores I < J en el mismo termómetro deben estar llenas
:- pos_index(BR,BC,R1,C1,I), pos_index(BR,BC,R2,C2,J), I < J, fill(R2,C2), not fill(R1,C1).

% No se pueden llenar celdas que no pertenezcan a ningún termómetro
:- fill(Row,Col), not cell(Row,Col).

% --- Contadores exactos por fila y columna ---
:- rowCount(Row,N), N != #count { Col : fill(Row,Col) }.
:- colCount(Col,N), N != #count { Row : fill(Row,Col) }.

#show fill/2.

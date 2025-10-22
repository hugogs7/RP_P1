% thermo.lp
% Encoding para el puzzle de termómetros.
% Lee hechos en domain.lp:
%   dim(N).
%   bulb(Row,Col,Dir).   Dir = up|down|left|right
%   seg(Row,Col,DirSeg). DirSeg = up|down|left|right
%   colCount(Col,Num).
%   rowCount(Row,Num).

% --- celdas existentes (bulb o seg) ---
cell(Row,Col) :- bulb(Row,Col,_).
cell(Row,Col) :- seg(Row,Col,_).

% --- direcciones de los bulbs ---
dir(BR,BC,right) :- bulb(BR,BC,right).
dir(BR,BC,left)  :- bulb(BR,BC,left).
dir(BR,BC,up)    :- bulb(BR,BC,up).
dir(BR,BC,down)  :- bulb(BR,BC,down).

% --- posición (índice) dentro del termómetro ---
% pos(BR,BC,Row,Col,I): el termómetro con bulbo en (BR,BC) tiene la celda (Row,Col) en posición I
pos(BR,BC,BR,BC,1) :- bulb(BR,BC,_).

% avanzar a la derecha
pos(BR,BC,Row,Col2,Idx+1) :-
    pos(BR,BC,Row,Col1,Idx),
    dir(BR,BC,right),
    Col2 = Col1 + 1,
    seg(Row,Col2,right).

% avanzar a la izquierda
pos(BR,BC,Row,Col2,Idx+1) :-
    pos(BR,BC,Row,Col1,Idx),
    dir(BR,BC,left),
    Col2 = Col1 - 1,
    seg(Row,Col2,left).

% avanzar hacia arriba
pos(BR,BC,Row2,Col,Idx+1) :-
    pos(BR,BC,Row1,Col,Idx),
    dir(BR,BC,up),
    Row2 = Row1 - 1,
    seg(Row2,Col,up).

% avanzar hacia abajo
pos(BR,BC,Row2,Col,Idx+1) :-
    pos(BR,BC,Row1,Col,Idx),
    dir(BR,BC,down),
    Row2 = Row1 + 1,
    seg(Row2,Col,down).

% --- Cada celda pertenece como mucho a un termómetro (debe cumplirse por la entrada válida)
% :- pos(BR1,BC1,Row,Col,_), pos(BR2,BC2,Row,Col,_), (BR1,BC1) != (BR2,BC2).

% --- Elección de llenado ---
{ fill(Row,Col) } :- cell(Row,Col).

% Monotonía: si una posición J está llena, todas las posiciones anteriores I<J también deben estar llenas
:- pos(BR,BC,R1,C1,I), pos(BR,BC,R2,C2,J), I < J, fill(R2,C2), not fill(R1,C1).

% No se pueden llenar celdas que no pertenezcan a ningún termómetro
:- fill(Row,Col), not cell(Row,Col).

% --- Contadores exactos por fila y columna ---
:- rowCount(Row,N), N != #count { Col : fill(Row,Col) }.
:- colCount(Col,N), N != #count { Row : fill(Row,Col) }.

#show fill/2.

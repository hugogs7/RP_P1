% thermo_curved.lp
% Variante de termómetros curvos (└ ┏ ┐ ┘)
% Coordenadas (Row,Col) en 0..N-1, con row=vertical, col=horizontal.

% --- Celdas existentes ---
cell(R,C) :- bulb(R,C,_).
cell(R,C) :- seg(R,C,_).
cell(R,C) :- curve(R,C,_).

% --- Posiciones dentro de cada termómetro ---
% pos(BR,BC,R,C,I,Dir): la celda (R,C) está en posición I desde el bulbo (BR,BC), con dirección actual Dir.

pos(BR,BC,BR,BC,1,Dir) :- bulb(BR,BC,Dir).

% --- Avances rectos ---
pos(BR,BC,R,C2,I+1,right) :-
    pos(BR,BC,R,C1,I,right),
    C2 = C1 + 1,
    seg(R,C2,right).
pos(BR,BC,R,C2,I+1,left) :-
    pos(BR,BC,R,C1,I,left),
    C2 = C1 - 1,
    seg(R,C2,left).
pos(BR,BC,R2,C,I+1,down) :-
    pos(BR,BC,R1,C,I,down),
    R2 = R1 + 1,
    seg(R2,C,down).
pos(BR,BC,R2,C,I+1,up) :-
    pos(BR,BC,R1,C,I,up),
    R2 = R1 - 1,
    seg(R2,C,up).

% --- Curvas ---
% 0 = └ : right->up, down->left
pos(BR,BC,R,C2,I+1,up) :-
    pos(BR,BC,R,C1,I,right),
    C2 = C1 + 1,
    curve(R,C2,0).
pos(BR,BC,R2,C,I+1,left) :-
    pos(BR,BC,R1,C,I,down),
    R2 = R1 + 1,
    curve(R2,C,0).

% 1 = ┏ : left->down, up->right
pos(BR,BC,R,C2,I+1,down) :-
    pos(BR,BC,R,C1,I,left),
    C2 = C1 - 1,
    curve(R,C2,1).
pos(BR,BC,R2,C,I+1,right) :-
    pos(BR,BC,R1,C,I,up),
    R2 = R1 - 1,
    curve(R2,C,1).

% 2 = ┐ : up->left, right->down
pos(BR,BC,R2,C,I+1,down) :-
    pos(BR,BC,R1,C,I,up),
    R2 = R1 - 1,
    curve(R2,C,2).
pos(BR,BC,R,C2,I+1,left) :-
    pos(BR,BC,R,C1,I,right),
    C2 = C1 + 1,
    curve(R,C2,2).

% 3 = ┘ : down->right, left->up
pos(BR,BC,R2,C,I+1,up) :-
    pos(BR,BC,R1,C,I,down),
    R2 = R1 + 1,
    curve(R2,C,3).
pos(BR,BC,R,C2,I+1,right) :-
    pos(BR,BC,R,C1,I,left),
    C2 = C1 - 1,
    curve(R,C2,3).

% --- Restricción: cada celda pertenece a lo sumo a un termómetro ---
:- pos(B1R,B1C,R,C,_,_), pos(B2R,B2C,R,C,_,_), (B1R,B1C) != (B2R,B2C).

% --- Elección de llenado ---
{ fill(R,C) } :- cell(R,C).

% --- Monotonía del mercurio ---
:- pos(BR,BC,R1,C1,I,_), pos(BR,BC,R2,C2,J,_), I < J, fill(R2,C2), not fill(R1,C1).

% --- No se puede llenar algo fuera de termómetros ---
:- fill(R,C), not cell(R,C).

% --- Restricciones de filas y columnas ---
:- rowCount(R,N), N != #count { C : fill(R,C) }.
:- colCount(C,N), N != #count { R : fill(R,C) }.

#show fill/2.

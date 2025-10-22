% thermo.lp
% Encoding para el puzzle termómetros.
% Lee hechos en domain.lp:
%   dim(N).
%   bulb(X,Y,Dir).   Dir = up|down|left|right
%   seg(X,Y,DirSeg). DirSeg = up|down|left|right
%   colCount(Col,Num).
%   rowCount(Row,Num).

% --- celdas existentes (bulb o seg) ---
cell(X,Y) :- bulb(X,Y,_).
cell(X,Y) :- seg(X,Y,_).

% --- direcciones de los bulbs (ayuda) ---
dir(BX,BY,right) :- bulb(BX,BY,right).
dir(BX,BY,left)  :- bulb(BX,BY,left).
dir(BX,BY,up)    :- bulb(BX,BY,up).
dir(BX,BY,down)  :- bulb(BX,BY,down).

% --- posición (índice) dentro del termómetro ---
% pos(BX,BY,X,Y,I) -> el termómetro con bulbo en (BX,BY) tiene la celda (X,Y) en posición I
pos(BX,BY,BX,BY,1) :- bulb(BX,BY,_).

% avanzar a la derecha
pos(BX,BY,X2,Y,Idx+1) :-
    pos(BX,BY,X1,Y,Idx),
    dir(BX,BY,right),
    X2 = X1 + 1,
    seg(X2,Y,right).

% avanzar a la izquierda
pos(BX,BY,X2,Y,Idx+1) :-
    pos(BX,BY,X1,Y,Idx),
    dir(BX,BY,left),
    X2 = X1 - 1,
    seg(X2,Y,left).

% avanzar hacia arriba (y disminuye hacia arriba en nuestro índice de fichero: pero usamos coordenadas 1..n con Y increasing top->bottom;
% para 'up' el siguiente segmento que continúa está en Y-1)
pos(BX,BY,X,Y2,Idx+1) :-
    pos(BX,BY,X,Y1,Idx),
    dir(BX,BY,up),
    Y2 = Y1 - 1,
    seg(X,Y2,up).

% avanzar hacia abajo
pos(BX,BY,X,Y2,Idx+1) :-
    pos(BX,BY,X,Y1,Idx),
    dir(BX,BY,down),
    Y2 = Y1 + 1,
    seg(X,Y2,down).

% Evitar índices fuera de la cuadrícula: (se asume que seg facts ya están dentro de la malla)
% No se necesita regla adicional aquí.

% --- Cada celda pertenece como mucho a un termómetro (debe cumplirse por la entrada válida).
% (Si la entrada fuese inconsistente y produce varias pos(...), podríamos detectar duplicados:)
:- pos(BX1,BY1,X,Y,I1), pos(BX2,BY2,X,Y,I2), (BX1,BY1) != (BX2,BY2).

% --- Elección de llenado:
% Para cada celda real (la que aparece en pos/5), permitimos que esté llena o no.
{ fill(X,Y) } :- cell(X,Y).

% Monotonía: si una posición con índice J está llena entonces todas las posiciones con índice I<J
% en el mismo termómetro deben estar llenas (el mercurio crece desde el bulbo).
:- pos(BX,BY,X1,Y1,I), pos(BX,BY,X2,Y2,J), I < J, fill(X2,Y2), not fill(X1,Y1).

% Impedimos llenar celdas que no pertenecen a ningun termómetro (aunque cell/2 cubre esto)
:- fill(X,Y), not cell(X,Y).

% --- Contadores por fila/columna: deben cumplirse exactamente.
% rowCount(Row,Num) con Row = Y
:- rowCount(Y,N), N != #count { X : fill(X,Y) }.

% colCount(Col,Num) con Col = X
:- colCount(X,N), N != #count { Y : fill(X,Y) }.

% Opcional: para depuración, podemos mostrar el termómetro (bulbo origen) al que pertenece cada celda:
% belongs(BX,BY,X,Y) :- pos(BX,BY,X,Y,_).
% pero no necesario.

% Mostrar solo los hechos fill/2 en la salida (si quieres que clingo muestre solo fill,
% puedes usar #show fill/2. Si quieres más info, comentar la siguiente línea)
#show fill/2.

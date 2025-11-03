% thermo.lp  — Encoding for curved thermometers
% Expected facts in domain.lp:
%   dim(N).
%   bulb(Row,Col,Dir).    % Dir = up|down|left|right
%   seg(Row,Col,DirSeg).  % DirSeg = up|down|left|right
%   curve(Row,Col,Type).  % Type = 0..3
%   colCount(Col,Num).
%   rowCount(Row,Num).


% existing cells (bulb, segment, or curve)
cell(R,C) :- bulb(R,C,_).
cell(R,C) :- seg(R,C,_).
cell(R,C) :- curve(R,C,_).

% direction of the bulb (useful for the initial position)
dir(BR,BC,D) :- bulb(BR,BC,D).

% definition of sides/opposites
opposite(up,down).
opposite(down,up).
opposite(left,right).
opposite(right,left).

% ports (sides) associated with each curve type
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

% exit of a curve given its type and the side from which it is entered
% exit_type(Type,EnterSide,ExitSide)
exit_type(0,up,right).
exit_type(0,right,up).
exit_type(1,right,down).
exit_type(1,down,right).
exit_type(2,down,left).
exit_type(2,left,down).
exit_type(3,left,up).
exit_type(3,up,left).


pos(BR,BC,BR,BC,1,Out) :- bulb(BR,BC,Out).


% rigth
pos(BR,BC,Row,Col2,Idx+1,NextOut) :-
    pos(BR,BC,Row,Col1,Idx, right),
    Col2 = Col1 + 1,
    % case: the neighboring cell is a straight segment oriented to the right (same direction) 
    seg(Row,Col2,right),
    NextOut = right.

% left
pos(BR,BC,Row,Col2,Idx+1,NextOut) :-
    pos(BR,BC,Row,Col1,Idx, left),
    Col2 = Col1 - 1,
    seg(Row,Col2,left),
    NextOut = left.

% up
pos(BR,BC,Row2,Col,Idx+1,NextOut) :-
    pos(BR,BC,Row1,Col,Idx, up),
    Row2 = Row1 - 1,
    seg(Row2,Col,up),
    NextOut = up.

% down
pos(BR,BC,Row2,Col,Idx+1,NextOut) :-
    pos(BR,BC,Row1,Col,Idx, down),
    Row2 = Row1 + 1,
    seg(Row2,Col,down),
    NextOut = down.

% --- transitions that go through a curve: enter from one side and exit through the other
% If the neighboring cell is a curve(Type) and has a port on the entry side (entry = opposite(Out)),
% then the exit direction NextOut is given by exit_type(Type, EnterSide, NextOut).
% Entry from the left (when exiting to the right)
pos(BR,BC,Row,Col2,Idx+1,NextOut) :-
    pos(BR,BC,Row,Col1,Idx,right),
    Col2 = Col1 + 1,
    Enter = left,
    curve(Row,Col2,Type),
    curve_port(Type,Enter),
    exit_type(Type,Enter,NextOut).

% Entry from the right (when exiting to the left)
pos(BR,BC,Row,Col2,Idx+1,NextOut) :-
    pos(BR,BC,Row,Col1,Idx,left),
    Col2 = Col1 - 1,
    Enter = right,
    curve(Row,Col2,Type),
    curve_port(Type,Enter),
    exit_type(Type,Enter,NextOut).

% Entry from below (when exiting to the top)
pos(BR,BC,Row2,Col,Idx+1,NextOut) :-
    pos(BR,BC,Row1,Col,Idx,up),
    Row2 = Row1 - 1,
    Enter = down,
    curve(Row2,Col,Type),
    curve_port(Type,Enter),
    exit_type(Type,Enter,NextOut).

% Entry from above (when exiting downward)
pos(BR,BC,Row2,Col,Idx+1,NextOut) :-
    pos(BR,BC,Row1,Col,Idx,down),
    Row2 = Row1 + 1,
    Enter = up,
    curve(Row2,Col,Type),
    curve_port(Type,Enter),
    exit_type(Type,Enter,NextOut).

% A cell participates in position I of a thermometer if there exists any pos with that index (OutDir ignored) 
pos_index(BR,BC,R,C,I) :- pos(BR,BC,R,C,I,_).

% --- Each cell belongs to at most one thermometer (if the input is valid, this is already ensured,
%     but the rule is left uncommented for safety if desired)
% :- pos_index(BR1,BC1,Row,Col,_), pos_index(BR2,BC2,Row,Col,_), (BR1,BC1) != (BR2,BC2).

% --- Filling choice (any existing cell may be filled)
{ fill(Row,Col) } :- cell(Row,Col).

% Monotonicity: if a position J is filled, all previous positions I < J in the same thermometer must also be filled 
:- pos_index(BR,BC,R1,C1,I), pos_index(BR,BC,R2,C2,J), I < J, fill(R2,C2), not fill(R1,C1).

% Cells that do not belong to any thermometer cannot be filled
:- fill(Row,Col), not cell(Row,Col).

% Exact counters for each row and column 
:- rowCount(Row,N), N != #count { Col : fill(Row,Col) }.
:- colCount(Col,N), N != #count { Row : fill(Row,Col) }.

#show fill/2.

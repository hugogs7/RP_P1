% thermo.lp
% Encoding for the Thermometers puzzle.
% Consumes facts from domain.lp:
%   dim(N).
%   bulb(Row,Col,Dir).    Dir = up|down|left|right
%   seg(Row,Col,DirSeg).  DirSeg = up|down|left|right
%   colCount(Col,Num).
%   rowCount(Row,Num).

% Existing cells in the grid (either a bulb or a segment)
cell(Row,Col) :- bulb(Row,Col,_).
cell(Row,Col) :- seg(Row,Col,_).

% Bulb directions (convenience predicate)
dir(BR,BC,right) :- bulb(BR,BC,right).
dir(BR,BC,left)  :- bulb(BR,BC,left).
dir(BR,BC,up)    :- bulb(BR,BC,up).
dir(BR,BC,down)  :- bulb(BR,BC,down).

% Position (index) along a thermometer
% pos(BR,BC,Row,Col,I): for the thermometer whose bulb is at (BR,BC),
% the cell (Row,Col) is at position I from the bulb (starting at 1).
pos(BR,BC,BR,BC,1) :- bulb(BR,BC,_).

% Propagate positions following the bulb's direction and segment orientation

% Move to the right
pos(BR,BC,Row,Col2,Idx+1) :-
    pos(BR,BC,Row,Col1,Idx),
    dir(BR,BC,right),
    Col2 = Col1 + 1,
    seg(Row,Col2,right).

% Move to the left
pos(BR,BC,Row,Col2,Idx+1) :-
    pos(BR,BC,Row,Col1,Idx),
    dir(BR,BC,left),
    Col2 = Col1 - 1,
    seg(Row,Col2,left).

% Move upward
pos(BR,BC,Row2,Col,Idx+1) :-
    pos(BR,BC,Row1,Col,Idx),
    dir(BR,BC,up),
    Row2 = Row1 - 1,
    seg(Row2,Col,up).

% Move downward
pos(BR,BC,Row2,Col,Idx+1) :-
    pos(BR,BC,Row1,Col,Idx),
    dir(BR,BC,down),
    Row2 = Row1 + 1,
    seg(Row2,Col,down).


% Optional sanity: each cell belongs to at most one thermometer
% Uncomment to reject inputs/models where a cell is assigned to two different bulbs.
% :- pos(BR1,BC1,Row,Col,_), pos(BR2,BC2,Row,Col,_), (BR1,BC1) != (BR2,BC2).

% Choice of filled cells
% For every valid cell, the solver may choose whether it is filled with mercury.
{ fill(Row,Col) } :- cell(Row,Col).


% Monotonicity constraint
% If a later position J is filled, then all earlier positions I<J along the same thermometer must be filled.
:- pos(BR,BC,R1,C1,I), pos(BR,BC,R2,C2,J), I < J, fill(R2,C2), not fill(R1,C1).

% Domain safety
% Cannot fill a cell that is not part of any thermometer cell declared in the input.
:- fill(Row,Col), not cell(Row,Col).

% Exact row/column counters
% Each row and column must have exactly the number of filled cells indicated by the input counters.
:- rowCount(Row,N), N != #count { Col : fill(Row,Col) }.
:- colCount(Col,N), N != #count { Row : fill(Row,Col) }.

#show fill/2.

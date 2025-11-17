#program dynamic.
shoot | load | wait.

loaded :- load.
loaded :- 'loaded, not unloaded.
unloaded :- shoot, 'loaded.
unloaded :- 'unloaded, not loaded.

:- load, 'loaded.

#program initial.
unloaded.
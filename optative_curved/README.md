# Curved Thermometers Puzzle Solver  
### Ana Lamas Rodríguez & Hugo García Souto  
# November 2025  


## Optional Work — Curved Thermometers  

This project extends the **Thermometers Puzzle** to support **curved thermometers**.  
It was developed as the **optional part** of the *Reasoning and Planning* course assignment,  
within the **Master in Artificial Intelligence** masters.    

## Description  

Unlike the basic version (straight thermometers only), this variant allows thermometers to **turn**.  
Curved thermometers are represented using four possible curve types, corresponding to clockwise rotations of an “L” shape:

| Symbol | Shape | Connected sides |
|:------:|:------:|:----------------|
| `0` | └ | up, right |
| `1` | ┏ | right, down |
| `2` | ┐ | down, left |
| `3` | ┘ | left, up |

## How to Run  

Run the following commands inside the project folder:

```bash

python encode_curved.py examplesthermob/dom09.txt domain.lp

clingo 0 thermo_curved.lp domain.lp

python decode.py thermo_curved.lp domain.lp > output.txt
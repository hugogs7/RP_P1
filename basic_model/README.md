# Thermometers Puzzle Solver
# HUGO GARCÍA SOUTO AND ANA LAMAS RODRIGUEZ.
# 3 NOVEMBER 2025

This project implements a complete pipeline to solve the **Thermometers Puzzle** using **Answer Set Programming (ASP)** with *Clingo* and visualizes the solution with *Pygame*.

The work was developed as part of a **university assignment on Declarative Problem Modeling**,  
within the **Master in Artificial Intelligence**, course *Reasoning and Planning*, as the **first project submission**.

## Overview

The **Thermometers Puzzle** consists of filling a grid of thermometers (horizontal or vertical tubes with a bulb) so that:
- The mercury always fills continuously from the bulb towards the end of the thermometer.
- The number of filled cells in each row and column matches the numerical clues provided.

This project provides:
1. A **Python encoder** (`encode.py`) that converts a text instance into ASP facts.
2. A **logic program** (`thermo.lp`) that defines the puzzle rules and constraints.
3. A **decoder** (`decode.py`) that reads Clingo’s output and prints the solved grid.
4. A **visualizer** (`drawthermo.py`) that displays the solution graphically using *Pygame* and the images in the `pics/` folder.


## Requirements

- **Python 3.10+**
- **Clingo 5.8+**
- **Pygame** (for graphical visualization)

## How to run

# 1 Encode the ASCII instance into ASP facts
python encode.py examplesthermo/dom01.txt domain.lp

# 2 Solve with Clingo (one solution)
clingo thermo.lp domain.lp -n 1 > solution.txt

# 3 Decode the solution to a compact text grid
python decode.py thermo.lp domain.lp > output.txt

# 4 Visualize the solved puzzle (uses pics/)
python drawthermo.py examplesthermo/dom01.txt output.txt

Install dependencies with:
```bash
pip install clingo pygame
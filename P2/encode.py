#!/usr/bin/env python3
import sys

def encode(input_file, output_file):
    # Leemos el mapa línea por línea
    with open(input_file, "r") as f:
        lines = [line.strip("\n") for line in f.readlines() if line.strip()]

    n_rows = len(lines)
    n_cols = len(lines[0])

    facts = []
    facts.append(f"#const nrows={n_rows}.")
    facts.append(f"#const ncols={n_cols}.")

    for row, line in enumerate(lines):        # fila = y
        for col, c in enumerate(line):        # columna = x
            if c == '.':
                facts.append(f"cell({row},{col},empty).")
            elif c == '#':
                facts.append(f"cell({row},{col},building).")
            elif c == 'X':
                facts.append(f"cell({row},{col},station).")
                facts.append(f"station({row},{col}).")
            elif c.isdigit():  # taxi
                facts.append(f"cell({row},{col},taxi).")
                facts.append(f"taxi({c},{row},{col}).")
            elif c.isalpha():  # pasajero
                facts.append(f"cell({row},{col},passenger).")
                facts.append(f"passenger({c},{row},{col}).")
            else:
                print(f"⚠️  Carácter desconocido: '{c}' en posición ({row},{col})")

    with open(output_file, "w") as f:
        f.write("\n".join(facts))
        f.write("\n")

    print(f"✅ Archivo '{output_file}' generado con {len(facts)} hechos.")
    print(f"Dimensiones: {n_rows} filas × {n_cols} columnas")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso: python3 encode.py <archivo_entrada.txt> <archivo_salida.lp>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    encode(input_file, output_file)
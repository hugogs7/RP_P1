import sys

def encode(input_file, output_file):
    with open(input_file, 'r') as f:
        lines = [line.strip() for line in f.readlines() if line.strip()]

    n = len(lines) - 2  # las dos últimas líneas son las sumas

    # Extraer las sumas
    col_sums = list(map(int, lines[-2].split()))
    row_sums = list(map(int, lines[-1].split()))

    # Extraer la cuadrícula
    grid = lines[:n]

    with open(output_file, 'w') as out:
        out.write(f"dim({n}).\n\n")

        # Crear hechos de las celdas
        for i in range(n):           # filas
            for j in range(n):       # columnas
                symbol = grid[i][j]
                out.write(f"cell({i+1},{j+1},'{symbol}').\n")
        out.write("\n")

        # Crear hechos de las sumas de columnas
        for j, val in enumerate(col_sums, start=1):
            out.write(f"col_sum({j},{val}).\n")
        out.write("\n")

        # Crear hechos de las sumas de filas
        for i, val in enumerate(row_sums, start=1):
            out.write(f"row_sum({i},{val}).\n")

    print(f"✅ Archivo '{output_file}' generado correctamente.")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso: python3 encode.py <input.txt> <output.lp>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    encode(input_file, output_file)

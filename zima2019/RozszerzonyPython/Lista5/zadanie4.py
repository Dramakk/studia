sudoku = [ [ 5, 3, 0, 0, 7, 0, 0, 0, 0 ],
        [ 6, 0, 0, 1, 9, 5, 0, 0, 0 ],
        [ 0, 9, 8, 0, 0, 0, 0, 6, 0 ],
        [ 8, 0, 0, 0, 6, 0, 0, 0, 3 ],
        [ 4, 0, 0, 8, 0, 3, 0, 0, 1 ],
        [ 7, 0, 0, 0, 2, 0, 0, 0, 6 ],
        [ 0, 6, 0, 0, 0, 0, 2, 8, 0 ],
        [ 0, 0, 0, 4, 1, 9, 0, 0, 5 ],
        [ 0, 0, 0, 0, 8, 0, 0, 7, 9 ] ]

def findEmpty(sudoku):
    for row in range(0, 9):
        for col in range(0, 9):
            if sudoku[row][col] == 0:
                return [row, col]
    return [9, 9]

def checkValid(n, i, j, sudoku):
    for a in range(0, 9):
        if sudoku[a][j] == n:
            return False
        if sudoku[i][a] == n:
            return False
    return True

def checkGrid(n, i, j, sudoku):
    for a in range(0, 3):
        for b in range(0, 3):
            if sudoku[a+i][b+j] == n:
                return False
    return True

def is_safe(sudoku, row, col, num):
    return checkValid(num, row, col, sudoku) and checkGrid(num, row - row % 3, col - col % 3, sudoku)

def solve(sudoku):
    newPlace = findEmpty(sudoku)
    row = newPlace[0]
    col = newPlace[1]
    if row == 9 and col == 9:
        for i in range(0, 9):
            print(sudoku[i])
        return True
    for a in range(1, 10):
        if is_safe(sudoku, row, col, a):
            sudoku[row][col] = a
            if solve(sudoku):
                return True
            sudoku[row][col] = 0
    return False

solve(sudoku)
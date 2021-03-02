# 3 on board is black king
# 1 on board is white king
# 2 on board is white tower
from collections import deque

input_file = open('zad1_input.txt', 'r')
output_file = open('zad1_output.txt', 'w')
line = input_file.readline().split()

possible_tower_moves = [(0, a) for a in range(-8, 9)] + \
    [(a, 0) for a in range(-8, 8)]
possible_tower_moves = [x for x in possible_tower_moves if x != (0, 0)]
possible_kings_moves = [(-1, -1), (0, -1), (1, -1),
                        (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0)]

possible_tower_moves.sort()
possible_kings_moves.sort()

def draw_board(state, file=None):
    color, wk, wt, bk = from_letters(state)
    print('='*10)
    for i in range(8, 0, -1):
        for j in range(1, 9):
            characterToPrint = '.'
            if (j, i) == bk:
                characterToPrint = '\u2654'
            elif (j, i) == wk:
                characterToPrint = '\u265A'
            elif (j, i) == wt:
                characterToPrint = '\u265C'
            print(characterToPrint, end='', file=file)
        print(file=file)
    print('='*10)

def from_letters(state):
    color, wk, wt, bk = state
    letters = {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5, 'f': 6, 'g': 7, 'h': 8}

    return (color, (letters[wk[0]], int(wk[1])), (letters[wt[0]], int(wt[1])), (letters[bk[0]], int(bk[1])))

def to_letters(letter, number):
    letters = {1: 'a', 2: 'b', 3: 'c', 4: 'd', 5: 'e', 6: 'f', 7: 'g', 8: 'h'}

    return letters[letter]+str(number)

def move(state, letter, number, piece):
    new_state = list(state[:])
    if state[0] == 'black':
        new_state[0] = 'white'
    else:
        new_state[0] = 'black'
    new_state[piece] = to_letters(letter, number)
    
    return tuple(new_state)


def add_coordinates(letter, number, move_letter, move_number):
    return (letter+move_letter, number+move_number)

def calculate_rectangle(board, letter, number):
    to_side_edge = min(letter, 8 - letter)
    to_vertical_edge = min(number, 8 - number)
    
    return (to_side_edge*to_vertical_edge)/16

def calculate_dist_to_black(board, letter, number):
    black_king_letter, black_king_number = from_letters(board)[3]

    return (abs(letter - black_king_letter) + abs(number - black_king_number))/14

def king_moves(board, piece):
    children_to_add = []
    letter, number = from_letters(board)[piece]
    black_king_letter, black_king_number = from_letters(board)[3]
    dist_to_black_old = calculate_dist_to_black(board, letter, number)
    rectangle_old = calculate_rectangle(board, letter, number)

    for possible_move in possible_kings_moves:
        possible_move_letter, possible_move_number = add_coordinates(
            letter, number, possible_move[0], possible_move[1])

        dist_to_black_new = calculate_dist_to_black(board, possible_move_letter, possible_move_number)
        rectangle_new = calculate_rectangle(board, possible_move_letter, possible_move_number)
        if is_valid_move(board, letter, number, possible_move_letter, possible_move_number, piece, kings_move=True):
            if piece == 3:
                if letter in (1, 8) or number in (1, 8) and is_check(board):
                    children_to_add.append(move(board, possible_move_letter, possible_move_number, piece))
                else:
                    if rectangle_old > rectangle_new:
                        children_to_add.append(move(board, possible_move_letter, possible_move_number, piece))
                    elif abs(rectangle_old - rectangle_new) < 0.1:
                        children_to_add.append(move(board, possible_move_letter, possible_move_number, piece))
            else:
                if dist_to_black_old >= dist_to_black_new:
                    children_to_add.append(move(board, possible_move_letter, possible_move_number, piece))
    
    if children_to_add == [] and is_check(board):
        children_to_add = -1
    
    return children_to_add


def tower_moves(board):
    children_to_add = []
    letter, number = from_letters(board)[2]
    dist_to_black_old = calculate_dist_to_black(board, letter, number)

    for possible_move in possible_tower_moves:
        possible_move_letter, possible_move_number = add_coordinates(
            letter, number, possible_move[0], possible_move[1])
            
        dist_to_black_new = calculate_dist_to_black(board, possible_move_letter, possible_move_number)
        if is_valid_move(board, letter, number, possible_move_letter, possible_move_number, 2):
            if dist_to_black_old > dist_to_black_new:
                children_to_add.append(move(board, possible_move_letter, possible_move_number, 2))
    return children_to_add


def is_valid_move(board, letter, number, possible_move_letter, possible_move_number, piece, kings_move=False):
    if not 0 < possible_move_letter < 9 or not 0 < possible_move_number < 9:
        return False
    
    color, wk, wt, bk = from_letters(board)
    if kings_move:
        color = 'black' if piece == 3 else 'white'
        if (possible_move_letter, possible_move_number) in (wk, wt, bk):
            return False

        if color == 'black':
            white_king_letter, white_king_number = wk
            white_tower_letter, white_tower_number = wt
            if white_tower_letter == possible_move_letter or white_tower_number == possible_move_number:
                return False
            if calculate_dist(possible_move_letter, possible_move_number, white_king_letter, white_king_number):
                return False
        else:
            black_king_letter, black_king_number = bk
            if calculate_dist(possible_move_letter, possible_move_number, black_king_letter, black_king_number):
                return False
    else:
        if calculate_dist(possible_move_letter, possible_move_number, bk[0], bk[1]):
            return False
        if is_over_king(board, letter, number, possible_move_letter, possible_move_number):
            return False
    return True


def is_over_king(board, letter, number, possible_move_letter, possible_move_number):
    def check_condition(letter, number, possible_move_letter, possible_move_number, king_letter, king_number):
        if possible_move_letter == king_letter and possible_move_number == king_number:
            return True
        if number == king_number and possible_move_number == king_number:
            if letter < king_letter:
                start_relative_pos = 'left'
            else:
                start_relative_pos = 'right'
            if possible_move_letter < king_letter:
                end_relative_pos = 'left'
            else:
                end_relative_pos = 'right'
            if start_relative_pos != end_relative_pos:
                return True
        if letter == king_letter and possible_move_letter == king_letter:
            if number < king_number:
                start_relative_pos = 'left'
            else:
                start_relative_pos = 'right'
            if possible_move_number < king_number:
                end_relative_pos = 'left'
            else:
                end_relative_pos = 'right'
            if start_relative_pos != end_relative_pos:
                return True
        return False

    color, wk, wt, bk = from_letters(board)

    white_king_in_letter, white_king_in_number = wk
    black_king_in_letter, black_king_in_number = bk

    return check_condition(letter, number, possible_move_letter, possible_move_number, white_king_in_letter, white_king_in_number) or \
        check_condition(letter, number, possible_move_letter,
                        possible_move_number, black_king_in_letter, black_king_in_number)


def calculate_dist(x1, y1, x2, y2):
    # calculate if king is in range of other piece
    dist_tuple = (abs(x1-x2), abs(y1-y2))

    return dist_tuple in ((1, 1), (0, 1), (1, 0))


def is_check(board):
    color, wk, wt, bk = from_letters(board)
    black_king_row, black_king_col = bk
    white_king_row, white_king_col = wk
    tower_row, tower_col = from_letters(board)[2]
    if tower_row == black_king_row or tower_col == black_king_col:
        if calculate_dist(black_king_row, black_king_col, tower_row, tower_col):
            if calculate_dist(white_king_row, white_king_col, black_king_col, black_king_row):
                return True
            else:
                return False
        else:
            return True
    else:
        return False


def create_tree(queue, max_depth = 10):
    visited = set()
    while queue != []:
        current_state, current_depth = queue.popleft() 
        color, wk, wt, bk = from_letters(current_state)
        if current_state in visited:
            continue
        visited.add(current_state)

        if current_depth > max_depth:
            continue

        if color == 'black':
            possible_moves = king_moves(current_state, 3)
            if possible_moves == -1:
                print(current_depth, file=output_file)
                break
            for possible_move in possible_moves:
                
                queue.append((possible_move, current_depth+1))
        else:
            possible_moves = king_moves(current_state, 1)
            if possible_moves == -1:
                print(current_depth, file=output_file)
                draw_board(current_state)
                break
            possible_moves.extend(tower_moves(current_state))
            for possible_move in possible_moves:
                queue.append((possible_move, current_depth+1))

queue = deque()
queue.append((tuple(line), 0))
create_tree(queue)

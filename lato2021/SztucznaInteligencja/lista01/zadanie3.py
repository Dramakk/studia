from itertools import product
import random
from tqdm import tqdm

colors = [x for x in range(0, 4)]
figures = [x for x in range(2, 15)]

lowCards_deck = [(x, y) for (x,y) in product(colors, figures[0:9])]
highCards_deck = [(x, y) for (x,y) in product(colors, figures[9:])]

def build_figures_in_hand(hand, mode=1):
    #mode 1 to return figures depending on value
    #mode 0 to return figures depending on color
    figures_in_hand = dict()
    
    for card in hand:
        if card[mode] in figures_in_hand:
            figures_in_hand[card[mode]] += 1
        else:
            figures_in_hand[card[mode]] = 1
    
    return figures_in_hand

def is_color(hand):
    figures_in_hand = build_figures_in_hand(hand, 0)

    return any(figures_in_hand[k] == 5 for k in figures_in_hand)


def is_streigh(hand):
    hand.sort(key=lambda x: x[1])
    isAsc = True
    lastSeen = hand[0][1]

    for card in hand[1:]:
        if card[1] == lastSeen+1:
            lastSeen = card[1]
        else:
            isAsc = False
            break
    
    return isAsc

def is_poker(hand):
    return is_streigh(hand) and is_color(hand)

def is_caret(hand):
    figures_in_hand = build_figures_in_hand(hand)

    return any(figures_in_hand[k] == 4 for k in figures_in_hand)

def is_triple(hand):
    figures_in_hand = build_figures_in_hand(hand)
    
    return any(figures_in_hand[k] == 3 for k in figures_in_hand)

def is_double_pair(hand):
    figures_in_hand = build_figures_in_hand(hand)
    
    return any(figures_in_hand[k] == 2 and figures_in_hand[j] == 2 for k in figures_in_hand for j in figures_in_hand if j != k)

def is_pair(hand):
    figures_in_hand = build_figures_in_hand(hand)
    
    return any(figures_in_hand[k] == 2 for k in figures_in_hand)

def is_full(hand):
    return is_triple(hand) and is_pair(hand)

def score(lowCards_hand, highCards_hand):
    #True high_cards win
    #False low_cards win
    possible_hands = [(is_poker, 10), (is_caret, 9), (is_full, 8), (is_color, 7), (is_streigh, 6), (is_triple, 5), (is_double_pair, 4), (is_pair, 3)]

    low_cards_score = -1
    high_cards_score = -1

    for hand in possible_hands:
        if hand[0](lowCards_hand) and low_cards_score == -1:
            low_cards_score = hand[1]
        if hand[0](highCards_hand) and high_cards_score == -1:
            high_cards_score = hand[1]
    
    if low_cards_score == high_cards_score:
        return True
    elif low_cards_score > high_cards_score:
        return False
    else:
        return True

def test(lowCards_deck):
    high_cards_wins = 0
    low_cards_wins = 0
    games = 10000
    for _ in range(0, games):
        high_cards_hand = random.sample(highCards_deck, 5)
        low_cards_hand = random.sample(lowCards_deck, 5)
        
        if score(low_cards_hand, high_cards_hand):
            high_cards_wins += 1
        else:
            low_cards_wins += 1

    return low_cards_wins/games

def best_low_cards_deck():
    best_deck = [[], 0]
    for _ in tqdm(range (0, 1000)):
        i = random.randint(5, 35)
        low_cards_deck = random.sample(lowCards_deck, i)
        score = test(low_cards_deck)

        if score > best_deck[1] and len(low_cards_deck) > len(best_deck[0]):
            best_deck = [low_cards_deck, score]
    print(best_deck)
test(lowCards_deck)
best_low_cards_deck()

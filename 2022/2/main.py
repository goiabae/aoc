from enum import Enum

class Throw(Enum):
    ROCK = 1
    PAPER = 2
    SCISSORS = 3

class Outcome(Enum):
    WIN = 6
    DRAW = 3
    LOSE = 0

MOVES = {
    # me
    "A": Throw.ROCK,
    "B": Throw.PAPER,
    "C": Throw.SCISSORS,
    # opponent
    "X": Throw.ROCK,
    "Y": Throw.PAPER,
    "Z": Throw.SCISSORS
}

def outcome(opponent, player):
    opponent_score, player_score = opponent.value, player.value
    if player_score % 3 + 1 == opponent_score:
        return Outcome.LOSE
    elif player_score == opponent_score:
        return Outcome.DRAW
    return Outcome.WIN

def hand_part1(opponent, player_strategy):
    opponent_throw = MOVES[opponent]
    player_throw = MOVES[player_strategy]
    return opponent_throw, player_throw

def hand_part2(opponent, player_strategy):
    opponent_throw = MOVES[opponent]
    if player_strategy == "Z":
        player_throw = Throw((opponent_throw.value) % 3 + 1)
    elif player_strategy == "Y":
        player_throw = opponent_throw
    else:
        player_throw = Throw((opponent_throw.value + 1) % 3 + 1)

    return opponent_throw, player_throw

def score(opponent, player):
    return outcome(opponent, player).value + player.value

def part1(data):
    return sum(score(*hand_part1(*row.split(" "))) for row in data)

def part2(data):
    return sum(score(*hand_part2(*row.split(" "))) for row in data)

def get_data(filepath="input"):
    return open(filepath, "r").read().splitlines()

if __name__ == "__main__":
    print(part1(get_data()))
    print(part2(get_data()))

# Rock-Paper-Scissors-Simulation-using-SAS-programming

 Rock, Paper, Scissors Simulation with Biased Players
   Author: Bishal Bhandari
   Purpose: Simulate Rock, Paper, Scissors with biased player choices
   Game Rules:
     - Player 1 has fixed bias: Rock 80%, Paper 12%, Scissors 8%
     - Player 2's bias is configurable through macro parameters
     - Rock beats scissors, scissors beats paper, paper beats rock
     - If both players select the same option, the game ends in a tie
   Macro Parameters:
     - p2rock: Percentage of time Player 2 chooses rock (0-100)
     - p2paper: Percentage of time Player 2 chooses paper (0-100)
     - ngames: Number of games to simulate (default 10000)
   Output: A frequency table showing game outcomes with the specified biases



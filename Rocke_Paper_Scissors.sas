/* Modified Rock, Paper, Scissors Simulation with Biased Players
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
*/

/* Simulate with fixed Player-1 bias and parametrized Player-2 bias*/
%macro rps_sim(p2rock=, p2paper=, ngames=10000);
  /* convert percentages to proportions */
  %let p2rock_p   = %sysevalf(&p2rock/100);
  %let p2paper_p  = %sysevalf(&p2paper/100);
  %let p2sciss_p  = %sysevalf(1 - &p2rock_p - &p2paper_p);
  
  /* Validate input: make sure scissors-proportion is non-negative */
  %if &p2sciss_p < 0 %then
    %put ERROR: p2rock + p2paper must be <= 100%;
  %else %do;
    data rps_&p2rock._&p2paper;
      length outcome $13;
      seed = 12345;
      do game = 1 to &ngames;
        /* Generate Player 1 choice with fixed bias: 
           Rock 80%, Paper 12%, Scissors 8% */
        u1 = ranuni(seed);
        if u1 < 0.80 then player1 = 1;      
        else if u1 < 0.92 then player1 = 2; 
        else player1 = 3;                   
        
        /* Generate Player 2 choice with configurable bias */
        u2 = ranuni(seed);
        if u2 < &p2rock_p then player2 = 1;      
        else if u2 < &p2rock_p + &p2paper_p then player2 = 2; 
        else player2 = 3;                        

        /* Determine game outcome based on player choices */
        if player1 = player2 then
          outcome = 'Draw';
        else if (player1=1 and player2=3)  /* Rock beats Scissors */
             or (player1=2 and player2=1)  /* Paper beats Rock */
             or (player1=3 and player2=2)  /* Scissors beats Paper */
          then outcome = 'Player 1 Wins';
        else
          outcome = 'Player 2 Wins';
        output;
      end;
      drop seed u1 u2 game;
    run;
    
    /* Generate frequency table of game outcomes */
    proc freq data=rps_&p2rock._&p2paper noprint;
      tables outcome / out=Freq_&p2rock._&p2paper(drop=percent);
    run;
    
    /* Display results */
    title "RPS Simulation (&ngames Games): P2 rock=&p2rock% paper=&p2paper% scissors=%sysevalf(&p2sciss_p*100)%";
    proc print data=Freq_&p2rock._&p2paper noobs;
      var outcome count;
      label outcome = 'Game Outcome'
            count   = 'Frequency';
    run;
  %end;
%mend rps_sim;

/* Demonstrate: P2 = 30% rock, 25% paper, 45% scissors*/
%rps_sim(p2rock=30, p2paper=25);

/* Demonstrate: P2 = 40% rock, 30% paper, 30% scissors */
%rps_sim(p2rock=40, p2paper=30);

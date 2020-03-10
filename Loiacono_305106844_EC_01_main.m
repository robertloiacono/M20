%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Extra Credit 1 MATLAB Script
%   Author: Robert Loiacono
%   Date:   3/6/20
%   UID: 305106844
%   Code for Problems 1
%   This problem     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Clear Cache
clear all
close all
clc

%%MAIN SCRIPT
load('votes1.mat');%makes a variable called votes automatically

%initialize starting variables
winnerFlag=1;
winner = 0;
numRounds=0;
%find size of columns and rows
nv=size(votes,1);
nc=size(votes,2);
%initalizes first row of command window with the number of candidates
fprintf('                    ');
for z=1:1:nc
    fprintf('%i',z);
    fprintf('      ');
end
fprintf('\n');

%while loop that does not break until a winner is found
while winnerFlag==1
    numRounds=numRounds+1;
    fprintf('Round %i Totals:   ',numRounds);
    totals=zeros(1,nc);
    %finds total votes for each candidate
    for i=1:1:nv
        j=votes(i,1);
        totals(j)=totals(j)+1;
    end
    grandTotal = sum(totals);
    %sorts candidate votes from least to greatest
    [S,I]=sort(totals);
    %if numRounds==4
        %losingCandidate=I(5);
    %else
        losingCandidate=I(numRounds);
    %end
    %if a winner is found
    if S(nc)>(0.5*grandTotal)
        winner=I(nc);
        winnerFlag=0;
    else %no winner this round 
        votes=removeCandidate(votes,losingCandidate);
    end
    for g=1:1:nc
        if totals(g)==0
            fprintf('000    ');
        else
            fprintf('%i    ',totals(g));
        end
    end
    fprintf('\n');
end
% header = cell(numRounds,1);
% for i = 1:1:numRounds
%    roundHeader = {"Round " + num2str(i) + " Totals:"};
%    header(i,1) = roundHeader;
% end
% output = header.';
% output(2,:)= num2cell(roundTotals');
% fprintf('%s %i \n', output{:});
fprintf('Winning Candidate: %i \n',winner);

function votes = removeCandidate(votes,losingCandidate)
%start of a round
nv=size(votes,1);
nc=size(votes,2);
%fprintf('Round %i Totals:   ',numRounds);
%makes every vote for a losing candidate equal to 0
for a=1:1:nv
    for f=1:1:nc
        if votes(a,f)==losingCandidate
            votes(a,f)=0;
        end
    end
end
%fill every 0 value with values from columns to the right,
%essentially moving everything over to the left, leaving a column
%full of 0s on the far right side
for b=1:1:nv
    for c=1:1:(nc-1)
        if votes(b,c)==0
            votes(b,c)=votes(b,c+1);
            votes(b,c+1)=0;
        end
    end
end
end


%ANSWERS TO QUESTIONS IN PROMPT
%{
The winning candidate for the first voting file was #6 after 7 rounds
while the winning candidate for the second voting file was #3 after 5
rounds. The function takes in a losing candidate and removes them from 
all rows and columns of the vote array, created by the loaded file. 
(c) For votes2.mat in round 4, there is a tie for last place between 
  candidate 2 and 4. My script will normally make the first candidate from
  left to right the losing candidate so candidate 2 would be eliminated,
  allowing candidate 3 to win the election. If you modify the code so
  candidate 4 is removed after the 4th round, there is no change in the
  winner since candidate 3 wins by about 50 more votes than before.
(d) This new voting system rewards candidates that are more popular
overall, aka the top 4 people on the ballot. Weighted sum method is better
to elections because it rewards the most popular candidate overall. The
other method can let people with more votes on the least favorable side
still win if it survives long enough. The candidate that wins in the
weighted voting system for vote1.mat is #5 while the candidate that wins for
the other voting file is #2.

%}
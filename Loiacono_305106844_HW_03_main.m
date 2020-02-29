%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Homework 3 MATLAB Script
%   Author: Robert Loiacono
%   Date:   01/31/20
%   UID: 305106844
%   Code for Problems 1 and 2
%   Problem 1 is designed The goal in this problem is to show 
%   how three different populations of species, X,Y and Z, are 
%   affected over time by their interactions. Using three Lotka-Volterra 
%   equations for each of the species, you are able to show how 
%   these populations die out and grow over time.
%   Problem 2 is designed to return the average amount of coins used to 
%   form all 100 different change amounts. The problem designates the 
%   value of each coin to a variable name and used a for loop designed to
%   only repeat once the exact change has been found.   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Clear Cache
clear all
close all
clc

%%MAIN SCRIPT
problemNum=input('Type the number 1 for problem 1 or type 2 for problem 2:');
while(problemNum~=1 && problemNum~=2)
    fprintf('Invalid problem number. Please enter a 1 for problem 1 or a 2 for problem 2.\n');
    problemNum=input('Type the number 1 for problem 1 or type 2 for problem 2:');
end
switch problemNum
    case 1
        %%Problem 1
        tic
        %initial populations at time=0
        x_i=2;
        y_i=2.49;
        z_i=1.5;
        
        %set time variables
        t=0;
        t_f=12;
        delta_t=0.005;
        
        %Set up table for population numbers over time
        fprintf('Time \t \tX \t \tY \t \tZ\n');
        %print initial populations as the first row in table
        fprintf('%.1f \t %.2f \t %.2f \t %.2f\n',t,x_i,y_i,z_i);
        
        %for loop that breaks when the time equals 12
        for a=1:(t_f/(delta_t))
            %discretized governing equations using Euler's method
            x_f = x_i + delta_t * (0.75*x_i*(1-x_i/20) -1.5*x_i*y_i -0.5*x_i*z_i);
            y_f = y_i + delta_t * (y_i*(1-y_i/25) -0.75*x_i*y_i -1.25*z_i*y_i);
            z_f = z_i + delta_t * (1.5*z_i*(1-z_i/30) -x_i*z_i -z_i*y_i);
            %print data
            tableTime=mod(a,0.5/delta_t);%every half second
            if (tableTime==0)
                fprintf('%3.1f \t %.2f \t %.2f \t %.2f\n', t,x_f,y_f,z_f);
            end
            %reassign values to initial x, y and z values
            x_i=x_f;
            y_i=y_f;
            z_i=z_f;
            t=t+delta_t;  
        end
        toc
        b=toc;
    case 2
        %%Problem 2
        %designate how much each kind of coin is worth in cents
        Q=25;
        D=10;
        N=5;
        P=1;
        %rolling count variables
        number_of_coins=0;
        loop_count=0;
        %iterate through the loop subtracting the current coin amount and increasing the number of coins used when applicable 
        for i=0:99
            change_amount=i;%always redesignate the change amount to the new amount indicated by the current value of i
         %Quarters
            while change_amount >= Q %as long as the change is above or equal to 25
                change_amount = change_amount - Q;
                number_of_coins = number_of_coins + 1;
            end
            %Dimes
            while change_amount >= D %as long as the change is above or equal to 10
                change_amount = change_amount - D;
                number_of_coins = number_of_coins + 1;
            end
            %Nickels
            while change_amount >= N %as long as the change is above or equal to 5
                change_amount = change_amount - N;
                number_of_coins = number_of_coins + 1;
            end
            %Pennies
            while change_amount >= 1 %as long as the change is above or equal to 1
                change_amount = change_amount - P;
                number_of_coins = number_of_coins + 1;
            end
            %counts the number of times the loop is called
            loop_count=loop_count+1;
        end
        %calculate the average number of coins used to form all 100 cent
        %amounts and print this number out
        average=number_of_coins/loop_count;
        fprintf('Average Number of Coins = %.2f\n', average);
    otherwise
        error('Wrong input to select a problem.');
end

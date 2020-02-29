%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Homework 2 MATLAB Script
%   Author: Robert Loiacono
%   Date:   01/24/20
%   UID: 305106844
%   Code for Problems 1 and 2
%   Problem 1 is designed to take a month, day and year in a certain
%   format(MMM,DD,YYYY). The program uses various input checks to ensure
%   the following of the problem's rules. The script will calculate the
%   Julian Day Number (J) and number of days since the new moon and use 
%   it calculate the lunar phase of the moon (L).
%   Problem 2 is designed to take in the number of rows and columns as well
%   as a number of a cell, named P. Using if and else statements, the
%   script determines where P lies in the array and prints out its
%   neighbors, assuming everything inputted is a valid input.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Clear Cache
clear all
close all
clc

%%MAIN SCRIPT
problemNum=input('Type the number 1 for problem 1 or type 2 for problem 2:');
switch problemNum
    case 1
        %%Problem 1

        %input for the month----------------------------------------------------
        month=input('Please enter the month as MMM (e.g. DEC): ','s');
        %-----------------------------------------------------------------------

        %input for the day------------------------------------------------------
        day=input('Please enter the day as DD (e.g. 21):','s');
        %-----------------------------------------------------------------------

        %input for the year----------------------------------------------------
        year=input('Please enter the year as YYYY (e.g. 2012):','s');
        %----------------------------------------------------------------------

        %input checks for day --------------------------------------------------
        intDay=str2num(day);%converts the string input into a integer input
        if (length(day)~=2)
            error('Input not in the form DD. Rerun script.');
        end
        if (isempty(intDay))
            error('Input must be a number. Rerun script');
        end
        if(intDay<1 || intDay>31)
           error('Day must be between 1 and 31. Rerun script.');
        end

        %input checks for year-------------------------------------------------
        intYear=str2num(year);%converts the string input into a integer input
        if (length(year)~=4)
            error('Input not in the form YYYY. Rerun script.');
        end
        if (isempty(intYear))
            error('Input must be a number. Rerun script');
        end
        if (intYear<1900 || intYear>9999)
            error('Year must be between 1900-9999. Rerun script.');
        end

        %input checks for month------------------------------------------------
        switch month %switch statement to ensure capitalization of month and marking the month's number and setting the max number of days for a future input check
            case 'JAN'
                maxDays = 31;
                intMonth = 1;
            case 'FEB'
                intMonth = 2;
                if ((mod(intYear,4)==0)&&(mod(intYear,100)~=0))||(mod(intYear,400)==0)%leap year calculation
                    maxDays = 29;
                else
                    maxDays = 28;
                end
            case 'MAR'
                maxDays = 31;
                intMonth = 3;
            case 'APR'
                maxDays = 30;
                intMonth = 4;
            case 'MAY'
                maxDays = 31;
                intMonth = 5;
            case 'JUN'
                maxDays = 30;
                intMonth = 6;
            case 'JUL'
                maxDays = 31;
                intMonth = 7;
            case 'AUG'
                maxDays = 31;
                intMonth = 8;
            case 'SEP'
                maxDays = 30;
                intMonth = 9;
            case 'OCT'
                maxDays = 31;
                intMonth = 10;
            case 'NOV'
                maxDays = 30;
                intMonth = 11;
            case 'DEC'
                maxDays = 31;
                intMonth = 12;
            otherwise
                error('The month inputted is incorrect. Rerun script.')
        end

        %Perform "calendar-aware" checks (e.g., no JUN 31)
        if(intDay>maxDays)
            error('This date is not possible. Rerun script.')
        end

        %Calculations for J or the Julian Day Number and the elapsed number of days
        %since the new moon
        if(intMonth==1 || intMonth==2)
            a=1;
        else
            a=2;
        end
        y=intYear-a+4800;
        m=intMonth+12*a-3;
        J=intDay+(floor((153*m+2)/5))+365*y+floor((y/4))-floor((y/100))+floor((y/400))-32045;
        deltJ=J-2415021;

        %Calculations for L or the lunar phase of moon
        T=29.530588853; %number of days in each lunar revolution
        L=(sin((pi*mod(deltJ,T))/T))^2;

        %Printing out the date,illumination and 

        if((mod(deltJ,T))/T) < 0.5%waxing and waning conditionals
            status='Waxing';
        else
            status='Waning';
        end
        fprintf('%s %s %s:\n', month,day,year)
        fprintf('Illumination = %3.1f percent \n',L*100);%printing the L value as a percentage not a number between 0 and 1
        fprintf('%s \n', status);
    case 2
        %%Problem 2
        %input statements for M, N and P
        M=str2double(input('Enter a value for the number of rows:','s'));
        N=str2double(input('Enter a value for the number of columns:','s'));
        P=str2double(input('Enter a value for the cells location:','s'));
        %input checks
        if (isnan(M) || isnan(N) || isnan(P))%error input check for non numeric input
            error('Enter a numeric number for the number of rows, columns and cell location. Rerun script.');
        end
        if(M<2 || N<2)
            error('Enter an M or N value greater or equal to 2. Rerun script.');
        end
        if(P<1 || P>(M*N))
            error('Must have a valid P value. Rerun script.');
        end
        %premade neighbor cells for specific locations, including the
        %corners and the middle cells
        neighborsOfP=[];
        middleCell=[P-M-1,P-M, P-M+1,P-1,P+1,P+M-1,P+M,P+M+1];
        topLeft=[P+1,P+M+1];
        topRight=[P+1,P-M+1];
        bottomLeft=[P-1,P+M-1];
        bottomRight=[P-1,P-M-1];

        %setting the neighbors of P
        %left wall
        if(P<=M) %anything less than M must be on the left wall of the MxN grid
            neighborsOfP=[neighborsOfP,P+M]; %cell directly to right of P
            if(mod(P,M)==1)%if in top left corner
                neighborsOfP=[neighborsOfP,topLeft];
            elseif (mod(P,M)==0)%if in bottom left corner
                neighborsOfP=[neighborsOfP,bottomLeft];
            else
                neighborsOfP=[neighborsOfP,bottomLeft,topLeft];
            end
        %right wall (same as left wall code but variables interchanged to account
        %for being on the right side
        elseif(P>M*(N-1))%P must be a number in the final column
            neighborsOfP=[neighborsOfP,P-M]; %cell directly to left of P
            if(mod(P,M)==1)
                neighborsOfP=[neighborsOfP,topRight];  
            elseif (mod(P,M)==0)%if in top right corner
                neighborsOfP=[neighborsOfP,bottomRight];
            else
                neighborsOfP=[neighborsOfP,bottomRight,topRight];
            end
        %can now either be on top wall or bottom wall or a middle cell
        elseif(P>M && P<=M*(N-1))%in between columns 1 and N
            if(mod(P,M)==1)%middle cell of the top wall
                neighborsOfP=[neighborsOfP,P-M,P+M,P+1,P+M+1,P-M+1];
            elseif(mod(P,M)==0)
                neightborOfP=[neighborOfP,P-M,P+M,P-1,P+M-1,P-M-1];
            else
                neighborsOfP=[neighborsOfP,middleCell];
            end
        end
        %sort the neighboring cells into a new array
        sortedNeighbors=sort(neighborsOfP);
        %print out the cell ID and the neighboring cells
        fprintf('Cell ID:    %i \n',P);
        fprintf('Neighbors:  ');
        fprintf('%i ', sortedNeighbors);
    otherwise
        error('Wrong input to select a problem.');
end

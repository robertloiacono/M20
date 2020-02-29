%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Homework 6 MATLAB Script
%   Author: Robert Loiacono
%   Date:   02/21/20
%   UID: 305106844
%   Code for Problems 1 and 2
%   Problem 1 models a Monte Carlo simulation to find when people in a group have 
%   birthdays in the same week. Every time a match is found, the script will add the 
%   Nth person added to the group to an array. After 10,000 trials, the script will 
%   find and output the median number of people it takes to find a shared birthday. 
%   The script will plot a histogram of all 10,000 trials to see the distribution of our results.
%   Problem 2 models the behavior of two particles randomly moving (or staying still) 
%   until they collide with one another. The script will plot the initial positions 
%   of both particles initially and plot both particles dynamically as they move 
%   around the grid. As the script performs 5000 of these tests, it will keep track 
%   of the number of movements before a collision and at the end, printing the median of all these numbers.   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Clear Cache
clear all
close all
clc
rng("shuffle")
% 
%%MAIN SCRIPT
problemNum=input('Type the number 1 for problem 1 or type 2 for problem 2:');
while(problemNum~=1 && problemNum~=2)
    fprintf('Invalid problem number. Please enter a 1 for problem 1 or a 2 for problem 2.\n');
    problemNum=input('Type the number 1 for problem 1 or type 2 for problem 2:');
end
switch problemNum
    case 1
        ncount=[]; %store trials
        medianOfTrials=0;
        for trials=1:10000 
            trialArray=[];
            count=0;
            foundBday=0;
            %while no shared birthdays are found
            while foundBday==0
                %random birthday between 1 and 365
                birthday=randi([1 365]);
                trialArray=[trialArray birthday];
                count=count+1;
                for j=1:size(trialArray,2)-1
                    %normal condition cases
                    if abs(trialArray(j)-birthday)<7
                        foundBday=1;
                    end
                    %wrap around case
                    if birthday>359 &&trialArray(j)<7
                        if abs(365-birthday)+trialArray<7
                            foundBday=1;
                        end
                    end
                    %wrap around case
                    if birthday<7 &&trialArray(j)>359
                        if abs(365-trialArray)+birthday<7
                            foundBday=1;
                        end
                    end

                end
            end
        ncount=[ncount count];
        end
        %OLD CODE1
          %{  
        numTrials=10000;
        ncount=zeros(1,numTrials);
        %iterates through 10000 trials
        for trialNum=1:1:numTrials
            sharedF=0;
            %holds list of birthdays that don't match
            birthdayList=zeros(1,365);
            %loop for specific trial
            %FOR FIRST PERSON IN GROUP
            birthday=ceil(365*rand);%random birthday
            birthdayList(1)=birthday;
            %loop over every previous birthday
            k=2;
            while sharedF==0 && k<365
                birthday=ceil(365*rand);%random birthday
                %loop over each element in array
                for i=1:1:k
                    difference=abs(birthday-birthdayList(i));
                    if difference<7 || difference>358 
                        ncount(trialNum)=birthday;
                        sharedF=1;
                    end
                end
                birthdayList(i+1)=birthday;
                k=k+1;
            end
        end
        %}
        %find median and print out median
        medianofTrials=ceil(median(ncount));
        fprintf('Median Number of People = %i\n',medianofTrials);
        %graph histogram of shared birthdays
        %nbins=50;
        histogram(ncount);
        xlabel('Number of Different Birthdays')
        ylabel('Number of Trials')
        title('Shared Birthday Histogram','Fontsize',24)
    case 2
        %set to 4999 to account for the one trial used to graph
        numTrials=4999;
        ncount=zeros(1,(numTrials+1));
        %initial positions of the A particle
        xA_i=-5;
        xA_current=xA_i;
        yA_i=0;
        yA_current=yA_i;
        %initial positions of the B particle
        xB_i=5;
        xB_current=xB_i;
        yB_i=0;
        yB_current=yB_i;
        figure(1)
        hold on
        set(gca,'xtick',-5.5:1:5.5)
        set(gca,'ytick',-5.5:1:5.5)
        grid on
        xlim([-5.5 5.5])
        ylim([-5.5 5.5])
        axis square
        xAK_i=[xA_i-0.5, xA_i+0.5,xA_i+0.5,xA_i-0.5];
        yAK_i=[yA_i-0.5,yA_i-0.5,yA_i+0.5,yA_i+0.5];
        %make center of particle B appear as in the middle of a square on grid for step k
        xBK_i=[xB_current-0.5, xB_current+0.5,xB_current+0.5,xB_current-0.5];
        yBK_i=[yB_i-0.5,yB_i-0.5,yB_i+0.5,yB_i+0.5];
        fill(xAK_i,yAK_i,'r')
        fill(xBK_i,yBK_i,'y')
        xlabel('X Position (units)')
        ylabel('Y Position (units)')
        title('Initial Random Walk','Fontsize',24)
        set(gcf,'Position',[30,350,850,450])
        set(gca,'Linewidth',3,'Fontsize',20)
        hold off
        %boundary conditions
        BC=[5,-5,-5,5]; %north south west east
        %input the number of steps such as n=1000
        nsteps=input('Enter the number of steps: ');
        while nsteps<=0 || mod(nsteps,1)~=0
            fprintf('Please enter a positive number of steps.\n');
            nsteps=input('Enter the number of steps: ');
        end
        
        %FIRST TRIAL THROUGH TO PLOT
        %set a collision flag for when they collide
        collisionF=0;
        k=0;
        %iterate while collision hasn't occured and not reached max steps
        while k<nsteps && collisionF==0
            %random direction or stay still
            [xAK_next,yAK_next]=RandWalk(xA_current,yA_current,BC);
            [xBK_next,yBK_next]=RandWalk(xB_current,yB_current,BC);
            %make center of particle A appear as in the middle of a square on grid for step k
            xAK_val=[xA_current-0.5, xA_current+0.5,xA_current+0.5,xA_current-0.5];
            yAK_val=[yA_current-0.5,yA_current-0.5,yA_current+0.5,yA_current+0.5];
            %make center of particle A appear as in the middle of a square
            %on grid for step k+1
            xAKnext_val=[xAK_next-0.5,xAK_next+0.5,xAK_next+0.5,xAK_next-0.5];
            yAKnext_val=[yAK_next-0.5,yAK_next-0.5,yAK_next+0.5,yAK_next+0.5];
            
            %make center of particle B appear as in the middle of a square on grid for step k
            xBK_val=[xB_current-0.5, xB_current+0.5,xB_current+0.5,xB_current-0.5];
            yBK_val=[yB_current-0.5,yB_current-0.5,yB_current+0.5,yB_current+0.5];
            %make center of particle A appear as in the middle of a square
            %on grid for step k+1
            xBKnext_val=[xBK_next-0.5,xBK_next+0.5,xBK_next+0.5,xBK_next-0.5];
            yBKnext_val=[yBK_next-0.5,yBK_next-0.5,yBK_next+0.5,yBK_next+0.5]; 

            %graph particles' new movement
            figure(1)
            hold on
            set(gca,'xtick',-5.5:1:5.5)
            set(gca,'ytick',-5.5:1:5.5)
            grid on
            xlim([-5.5 5.5])
            ylim([-5.5 5.5])
            axis square
            %particle A at step k - red 
            %particle A at step k+1 - blue
            %particle B at step k - yellow
            %particle B at step k-1 - green
            fill(xAK_val,yAK_val,'r')
            fill(xAKnext_val,yAKnext_val,'b')
            fill(xBK_val,yBK_val,'y')
            fill(xBKnext_val,yBKnext_val,'g')
            title('Random Walk','Fontsize',24)
            xlabel('X Position (units)')
            ylabel('Y Position (units)')
            set(gcf,'Position',[30,350,850,450])
            set(gca,'Linewidth',3,'Fontsize',20)
            hold off
            %update new positions for step (k+1)
            xA_current=xAK_next;
            yA_current=yAK_next;
            xB_current=xBK_next;
            yB_current=yBK_next;
            k=k+1;
            %if collision before nsteps is over
            if xA_current==xB_current && yA_current==yB_current
                collisionF=1;
                ncount(1)=k;
            end
            
        end
        %if particles dont meet after nsteps, set the number of iterations
        %to collision to the value of nsteps
        if xA_current~=xB_current && yA_current~=yB_current
            collisionF=0;
            ncount(1)=nsteps;
        end
        
        %REST OF TRIALS BUT NOT PLOTTING
        for i=1:1:numTrials
        %initial positions of the A particle
        xA_i=-5;
        xA_current=xA_i;
        yA_i=0;
        yA_current=yA_i;
        %initial positions of the B particle
        xB_i=5;
        xB_current=xB_i;
        yB_i=0;
        yB_current=yB_i;
        %set a collision flag for when they collide
        collisionF=0;
        k=0;
        %iterate while collision hasn't occured and not reached max steps
        while k<nsteps && collisionF==0
            [xAK_next,yAK_next]=RandWalk(xA_current,yA_current,BC);
            [xBK_next,yBK_next]=RandWalk(xB_current,yB_current,BC);
            %update new positions for step (k+1)
            xA_current=xAK_next;
            yA_current=yAK_next;
            xB_current=xBK_next;
            yB_current=yBK_next;
            k=k+1;
            %if collision before nsteps is over
            if xA_current==xB_current && yA_current==yB_current
                collisionF=1;
                ncount(i+1)=k;
            end
        end
        %if particles dont meet after nsteps, set the number of iterations
        %to collision to the value of nsteps
        if xA_current~=xB_current && yA_current~=yB_current
            collisionF=0;
            ncount(i+1)=nsteps;
        end
        end
        %find median of the number of iterations and print out
        medianofTrials=ceil(median(ncount));
        fprintf('Median = %i\n',medianofTrials);
    otherwise
        error('Wrong input to select a problem.');
end

%function takes in initial positions and calculates a movement depending on
%the result of the rand function, and accounts for when the walker is
%against a boundary/wall
function[x,y]=RandWalk(x0,y0,BC)
    r=rand;
    if r<= 0.2 %stay still
        x=x0;
        y=y0;
    elseif r>0.2 && r<=0.4 %moving north
        x=x0;
        y=y0+1;
        %if at a boundary
        if y>=BC(1)
            y=BC(1);
        end
    elseif r>0.4 && r<=0.6 %moving south
        x=x0;
        y=y0-1;
        %if at boundary
        if y<=BC(2)
            y=BC(2);
        end
    elseif r>0.6 && r<=0.8 %moving west
        x=x0-1;
        y=y0;
        %if at boundary
        if x<=BC(3)
            x=BC(3);
        end
    elseif r>0.8 %moving east
        x=x0+1;
        y=y0;
        %if at boundary
        if x>=BC(4)
            x=BC(4);
        end
    end
end
    

    

        
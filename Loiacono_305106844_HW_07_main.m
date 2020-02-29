%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Homework 7 MATLAB Script
%   Author: Robert Loiacono
%   Date:   02/28/20
%   UID: 305106844
%   Code for Problems 1 and 2
%   Problem 1's goal is to simulate the fate of living cells using the rules 
%   outlined in John Conway's "Game of Life". Depending on the number of living
%   neighbors, the cell will survive or die (if alive) or become a living cell(if dead).
%   This data is simulated for various amounts of generations and is graphed
%
%   Problem 2's goal is to model the behavior Euler-Bernoulli beam bending, 
%   using discretized equations. The problem calls for a force to be applied 
%   to an aluminum beam, fastened down at its ends. After finding the deflection, 
%   shear and moment of the beam at every point (the user indicates how many), 
%   graph each data set on a separate graphs.  
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
        %ask for size of grid for x and y
       x_array=input('Enter the grid size of the x axis.\n');
       while mod(x_array,1)~=0 || x_array<=0
           fprintf('Error: grid size must be greater than 0');
           x_array=input('Enter the grid size of the x axis.\n');
       end
       y_array=input('Enter the grid size of the y axis.\n');
       while mod(y_array,1)~=0 || y_array<=0
           fprintf('Error: grid size must be greater than 0');
           y_array=input('Enter the grid size of the y axis.\n');
       end
       %generate initial grid randomly with 1s and 0s
       %1=alive    0=dead
       lifeGrid=floor(rand(y_array,x_array)*2);%multiply by 2 since floor would always make a random value between 0 and 1, a 1
       figure(1)
       %plot the initial grid at an iteration of 0
       imagesc(lifeGrid)
       set(gcf,'Position',[30 350 850 450])
       set(gca,'LineWidth',3,'FontSize',20)
       title('Game of Life at n=0','FontSize',24);
       axis equal
       
       %ask user for maximum number of iterations
       currGen=0;
       maxGen=input('Enter the maximum generation number.\n');
       while mod(maxGen,1)~=0 || maxGen<=0
           fprintf('Error: Generation number must be positive.');
           maxGen=input('Enter the maximum generation number.\n');
       end
       
       aliveArray=zeros(1,maxGen);
       %iterate through game of life until you have reached the max number
       %of generations
       while currGen<maxGen
           aliveCount=0;
           %pause(0.01)
           %increase generation to the next
           currGen=currGen+1;
           %new grid for next timestep
           newGrid=lifeGrid;
           %go through y direction
           for y=1:1:y_array
               %if at y axis boundary?
               if y==1;y_1_less=y_array; else; y_1_less=y-1; end
               if y== y_array; y_1_more=1; else; y_1_more=y+1; end
               %go through x direction
               for x_axis=1:1:x_array
                   % if at x axis boundary?
                   if x_axis==1;xm1=x_array; else; xm1=x_axis-1; end
                   if x_axis== x_array; xp1=1; else; xp1=x_axis+1; end
                   
                   %find value of all neighbors
                   live_value=lifeGrid(y_1_less,xm1)+lifeGrid(y_1_less,x_axis)+lifeGrid(y_1_less,xp1)+lifeGrid(y,xm1)+lifeGrid(y,xp1)+lifeGrid(y_1_more,xm1)+lifeGrid(y_1_more,x_axis)+lifeGrid(y_1_more,xp1);
                   %for living cells
                   if lifeGrid(y,x_axis)==1
                       %if 2 or 3 neighbors survives
                       if live_value==2 || live_value==3 
                           newGrid(y,x_axis)=1;
                           aliveCount=aliveCount+1;
                       else%any other living cell dies
                           newGrid(y,x_axis)=0;
                       end
                   else
                       %a dead cell with 3 live neigbors becomes alive
                       if live_value==3
                           newGrid(y,x_axis)=1;
                           aliveCount=aliveCount+1;
                       end
                   end
               end
               
           end
           alive_Array(currGen)=aliveCount;
           %plot grid
           imagesc(newGrid)
           title (['Game of Life at n= ' num2str(currGen)'.'], 'FontSize',24)
           set(gcf,'Position',[30 350 850 450])
           set(gca,'LineWidth',3,'FontSize',20)
           axis equal
           drawnow %ensure each time step is displayed
           
           %update the current life grid for next generation
           lifeGrid=newGrid;
       end
       %set an array so each generation is an index
       time_Array=zeros(1,maxGen);
       for i=1:1:maxGen
           time_Array(i)=i;
       end
       figure()
       plot(time_Array,alive_Array)
       title('Alive Cells over Every Generation');
       xlabel('Generation')
       ylabel('Number of Alive Cells')
    case 2
       %initialize all constants for the beam, such as the force on the
       %beam, the length of the beam, etc.
       L=1;%[m]
       R=0.013;%[m]
       r=0.011;%[m]
       E=70;%[GPa]
       d=0.75;%[m]
       I=(pi/4)*(R^4 -r^4);%[m]
       P=2000;%[N]
       
       %ask for the number of points along the beam
       beamPoints=input('Enter the number of points along the beam.\n');
       while mod(beamPoints,1)~=0 || beamPoints<=0
           fprintf('Error: input number must be greater than 0');
           beamPoints=input('Enter the number of points along the beam.\n');
       end
       
       %create x axis points to be used for graphs
       x_axis=zeros(beamPoints,1);
       y_initial=zeros(beamPoints,1);
       dx=L/(beamPoints -1);
       for i=2:1:beamPoints
           x_axis(i)=x_axis(i-1)+dx;
       end
       %shear force vector
       shear=zeros(beamPoints,1);
       for i=1:1:beamPoints
           if x_axis(i)<=d*L
               shear(i)=P/2; %apply positive force if between 0 and d
           else
               shear(i)=-P/2;%apply negative force if between d and L
           end
       end
       %moment vector
       moment=zeros(beamPoints,1);
       for i=1:1:beamPoints
           %depending on if between 0 and d and d and L
           if x_axis(i)<=d*L
               moment(i)=shear(i)*x_axis(i);
           else
               moment(i)=-shear(i)*(L-x_axis(i));
           end
       end
       %solve for deflection and set BC's
       deflection=zeros(beamPoints,beamPoints);
       %boundary condition at x=0
       deflection(1,1)=1;
       %boundary condition at x=L
       deflection(beamPoints,beamPoints)=1;
       
       for i=2:1:beamPoints-1
           deflection(i,i-1)=1;
           deflection(i,i)=-2;
           deflection(i,i+1)=1;
       end
       %equation 1 of report, solving for second derivative
       b=dx^2*moment/(E*I);
       %solve for deflection at each grid point
       y=deflection\b; %matrix operation to find y
       %c=min(d,L-d);
       %2fprintf('a %.3f',c);
       figure(1)
       %moment plot
       subplot(3,1,1);
       hold on 
       grid on
       plot(x_axis,moment,'g','LineWidth',3)
       plot(x_axis,moment,'go','MarkerSize',10,'MarkerFaceColor','g')
       set(gca,'LineWidth',3,'FontSize',10)
       set(gcf,'Position',[30 350 850 450])
       title('Moment','FontSize',10)
       xlabel('Position [m]')
       ylabel('Moment [Nm]')
       
       %shear plot
       subplot(3,1,2);
       hold on
       grid on
       plot(x_axis,shear,'b','LineWidth',3)
       plot(x_axis,shear,'bo','MarkerSize',10,'MarkerFaceColor','b')
       title('Shear','FontSize',10)
       ylabel('V [N]')
       set(gca,'LineWidth',3,'FontSize',10)
       
       %deflection plot
       subplot(3,1,3)
       hold on 
       grid on
       plot(x_axis,y_initial,'y','LineWidth',3)
       plot(x_axis,y,'r','LineWidth',3)
       plot(x_axis,y,'ro','MarkerSize',10,'MarkerFaceColor','r')
       title('Deflection','FontSize',10)
       set(gca,'LineWidth',3,'FontSize',10)
       ylabel('y [m]')

    otherwise
        error('Wrong input to select a problem.');
end


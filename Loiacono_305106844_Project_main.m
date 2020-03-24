%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Final Project MATLAB Script
%   Author: Robert Loiacono
%   Date:   3/20/20
%   UID: 305106844
%   Code for Final Project
%   The goal in this problem is to simulate the Magnetic Ising model that 
%   consists of approximating the magnetic dipole moments in one of two 
%   possible states: positve(+1) and negative(-1). By theoretically changing 
%   a state at a particular site, you are able to calculate whether this 
%   scenario is possible by examining the spins of neighboring sites. Over 
%   one million iterations, the script will calculate and change the spins 
%   of a random site and will output certain iterations in a plot and video format.      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Clear Cache
clear all
close all
clc

%%VIDEO CODE---------------------------------------------------
% vidfile=VideoWriter('test3','MPEG-4');
% vidfile.FrameRate=60;
% vidfile.Quality=100;
% open(vidfile);
%------------------------------------------------------------------------
%%MAIN SCRIPT
%initialize values of grid size and iteration numbers
J=1;
kT=0.1;
x_min=0;
x_max=150;
y_min=0;
y_max=100;
h=1;
currIter=0;
maxIter=1000000;

grid_type=input('Please enter grid-type: 1, 2 ,3: ');
while grid_type~=1 && grid_type~=2 && grid_type~=3
   fprintf('Error: Please enter a correct grid-type: 1, 2, 3\n');
   grid_type=input('Please enter grid-type: 1, 2 ,3: '); 
end
%set up initial field and plot its original state
[dipole_field]=seed_initial(x_min,x_max,y_min,y_max,h,grid_type);
plot_dipole(dipole_field,currIter,grid_type);

maxJPts=((x_max-x_min)/h) +1;
maxIPts=((y_max-y_min)/h) +1;
while currIter<=maxIter
    currIter=currIter+1;
    %choose one site at random to change its spin configuration
    j=floor(rand()*maxJPts)+1;
    i=floor(rand()*maxIPts)+1;
    %calculate the proposed spin
    [delE,Prob]=ProbCalculation(dipole_field,i,j,J,kT);
    randomNumber=rand;
    
    if Prob==1
        %spin is accepted
        new_field=update_field(dipole_field,i,j);
        dipole_field=new_field;
    else
        if randomNumber<=Prob
            %spin is accepted
            new_field=update_field(dipole_field,i,j);
            dipole_field=new_field;
%         else
%             %spin is rejected
%             new_field=dipole_field(i,j);
        end
    end
    %dipole_field=new_field;
    
    if currIter==10 || currIter==100 || currIter==1000 || currIter==10000 || currIter==100000 || currIter==1000000
        plot_dipole(dipole_field,currIter,grid_type);
    end
%VIDEO CODE---------------------------------------------------
%     if mod(currIter,1000)==0
%         plot_dipole(dipole_field,currIter,grid_type);
%         writeVideo(vidfile,getframe(gcf));
%     end
%-------------------------------------------------------------
end
%VIDEO CODE---------------------------------------------------
%close(vidfile)
%-------------------------------------------------------------
%%Function 1 Initial Condition Function 
%initializes all the dipoles of every location in the matrix
function [dipole_field]=seed_initial(x_min,x_max,y_min,y_max,h,grid_type)
    maxJPts=((x_max-x_min)/h) +1;
    maxIPts=((y_max-y_min)/h) +1;
    dipole_field=zeros([maxIPts,maxJPts]);%blank dipole array
    if grid_type==1
        for i=1:1:maxIPts%iterate through columns first then rows
            for j=1:1:maxJPts
                r=rand;
                if r>=0.5
                    dipole_field(i,j)=1;
                else
                    dipole_field(i,j)=-1;
                end
            end
        end
    elseif grid_type==2
        left_Half=0.5*maxJPts; %equalt to half the number of clumns
        for i=1:1:maxIPts %iterate through columns first then rows
            for j=1:1:maxJPts
                if j<left_Half
                    dipole_field(i,j)=1;
                else
                    dipole_field(i,j)=-1;
                end
            end
        end
    else
        i_center=ceil((y_max-y_min)/2)+1;
        j_center=ceil((x_max-x_min)/2)+1;
        radius=i_center;
        for i=1:1:maxIPts %iterate through columns first then rows
            for j=1:1:maxJPts
                if((i-i_center)^2 + (j-j_center)^2) <=radius^2 %anything inside this circle becomes positive
                    dipole_field(i,j)=1;
                else
                    dipole_field(i,j)=-1;
                end
            end
        end
    end
end

%%Function 2- Energy and Probability Calculation Function
%calculates the change and energy and probability of the random point
function[delE,Prob]=ProbCalculation(dipole_field,i,j,J,kT)
    fieldSize=size(dipole_field);
    i_max=fieldSize(1);
    j_max=fieldSize(2);
    j_min=0;
    i_min=0;
    h=1;
    maxJPts=(j_max-j_min)/h;
    maxIPts=(i_max-i_min)/h;
    
    %flip spin of random point
    dipole_field(i,j)=dipole_field(i,j)*-1;
%     temp_field=dipole_field;
%     temp_field(i,j)=temp_field(i,j)*-1;
%     dipole_field=temp_field;
    
    %calculate change in energy
    if j==1 %left side of matrix
        if i==1 %top left corner
            delE=-1*J*dipole_field(i,j)*(dipole_field(i,j+1)+dipole_field(i+1,j)+dipole_field(maxIPts,j)+dipole_field(i,maxJPts));
        elseif i==maxIPts %bottom left corner
            delE=-1*J*dipole_field(i,j)*(dipole_field(i-1,j)+dipole_field(i,j+1)+dipole_field(1,1)+dipole_field(i,maxJPts));
        else %anywhere on the left wall of matrix not in corners
            delE=-1*J*dipole_field(i,j)*(dipole_field(i-1,j)+dipole_field(i+1,j)+dipole_field(i,j+1)+dipole_field(i,maxJPts));
        end
    elseif j==maxJPts %right side of matrix
        if i==1 %top right corner
            delE=-1*J*dipole_field(i,j)*(dipole_field(i,j-1)+dipole_field(i,1)+dipole_field(i+1,j)+dipole_field(maxIPts,j));
        elseif i==maxIPts %bottom right corner
            delE=-1*J*dipole_field(i,j)*(dipole_field(i,j-1)+dipole_field(i,1)+dipole_field(i-1,j)+dipole_field(1,j));
        else  %anywhere else on the right wall not in corners
            delE=-1*J*dipole_field(i,j)*(dipole_field(i-1,j)+dipole_field(i+1,j)+dipole_field(i,j-1)+dipole_field(i,1));
        end
    elseif i==1 && (j>1 && j<maxJPts) %top wall but not corners
        delE=-1*J*dipole_field(i,j)*(dipole_field(i,j+1)+dipole_field(i,j-1)+dipole_field(i+1,j)+dipole_field(maxIPts,j));
    elseif i==maxIPts && (j>1 && j<maxJPts) %bottom wall but not corners
        delE=-1*J*dipole_field(i,j)*(dipole_field(i,j+1)+dipole_field(i,j-1)+dipole_field(i-1,j)+dipole_field(1,j));
    else %middle cell
        delE=-1*J*dipole_field(i,j)*(dipole_field(i+1,j)+dipole_field(i-1,j)+dipole_field(i,j+1)+dipole_field(i,j-1));
    end
    
    %finding probability
    if delE<=0
        Prob=1;
    else
        Prob=exp(-delE/kT);
    end
    %flip spin back at random point and let update field function handle
    %changing it if needed
    dipole_field(i,j)=dipole_field(i,j)*-1;
end 

%%Update Field Function
%updates the dipole field if there needs to be a change in spin
function [new_field]=update_field(dipole_field,i,j)
%if proposed spin is accepted
    new_field=dipole_field;
    new_field(i,j)=new_field(i,j)*-1;
end

%%Plot Field Function 
%plots the current iterations dipole field matrix
function plot_dipole(dipole_field,currIter,grid_type)
%yellow is positive spin and purple is negative; can be seen in colorbar
figure()
imagesc(dipole_field)
colorbar
title(['Iteration Number ' num2str(currIter) ' For Grid Type ' num2str(grid_type)],'FontSize',20);
%set(gcf,'Position',[0 0 150 100])
hold on 
grid on
drawnow
end
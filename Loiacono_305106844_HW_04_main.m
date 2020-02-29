%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Homework 4 MATLAB Script
%   Author: Robert Loiacono
%   Date:   2/07/20
%   UID: 305106844
%   Code for Problems 1 and 2
%   Problem 1 is designed to graph the energy, angular position, velocity and
%   acceleration to the user by using Euler's explicit and semi implicit
%   methods.
%   Problem 2 is designed to analyze a data file containing a segment of human DNA by using iterations 
%   and logical conditions. The results will be calculated by identifying where a start and stop codon 
%   are in order to find the DNA segment's length. All calculations will be printed to the command window, 
%   including the average length, minimum length, maximum length and the total number of DNA segments found. 
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
        %set up initial values of variables
        L=1; %meters
        g=9.81; %m/s^2
        %set up time variables
        t_i=0;
        t_f=20;
        dt=0.005;
        t_steps=ceil(t_f/dt);
        x_axis_time=linspace(t_i,t_f,t_steps);
        %set up arrays to hold thetas and w's
        theta_array=zeros(1,t_steps);
        w_array=zeros(1,t_steps);
        alpha_array=zeros(1,t_steps);
        e_array=zeros(1,t_steps);
        %initial theta and w values in array
        theta_array(1)=pi/3;
        w_array(1)=0;
        
        %explicit euler method
        for i=1:1:(t_steps-1)
            alpha_array(i)=(-1*g/L)*sin(theta_array(i));
            w_array(i+1)=alpha_array(i)*dt + w_array(i);
            theta_array(i+1)=w_array(i)*dt + theta_array(i);
            h=L*(1-cos(theta_array(i)));
            e_array(i)=g*h+0.5*(L*w_array(i)).^2;
        end
        plot(x_axis_time,theta_array);
        title('Explicit Euler: Angular Pos vs Angular Velo vs Angular Acc vs Time');
        xlabel('Time (seconds)');
        ylabel('Position (rads), Velocity (rads/s), Acceleration (rads^2)');
        hold on
        plot(x_axis_time, w_array);
        plot(x_axis_time, alpha_array);
        legend('Angular Position (radians)','Angular Velocity (rads/second)','Angular Acceleration (rads/second^2)');
        hold off
        figure
        plot(x_axis_time,e_array);
        title('Explicit Euler: Energy vs Time');
        xlabel('Time (seconds)');
        ylabel('Joules (J)');
        
        %semi implicit euler
        for i=1:ceil(t_steps-1)
            alpha_array(i)=(-1*g/L)*sin(theta_array(i));
            w_array(i+1)=alpha_array(i)*dt + w_array(i);
            theta_array(i+1)=w_array(i+1)*dt + theta_array(i);
            h=L*(1-cos(theta_array(i)));
            e_array(i)=g*h+0.5*(L*w_array(i)).^2;
        end
        figure
        plot(x_axis_time,theta_array);
        title('Implicit Euler: Angular Pos vs Angular Velo vs Angular Acc vs Time');
        xlabel('Time (seconds)');
        ylabel('Position (rads), Velocity (rads/s), Acceleration (rads^2)');
        hold on
        plot(x_axis_time, w_array);
        plot(x_axis_time, alpha_array);
        legend('Angular Position (radians)','Angular Velocity (rads/second)','Angular Acceleration (rads/second^2)');
        hold off
        figure
        plot(x_axis_time,e_array);
        title('Implicit Euler: Energy vs Time');
        xlabel('Time (seconds)');
        ylabel('Joules (J)')
        ylim([0 7]);
    case 2
        %%Problem 2
        %load in DNA segment file
        load('chr1_sect.mat');
        %initilize variables for use in the loops
        numberOfBases=length(dna);
        dna_lengths=zeros(1,(numberOfBases));
        startingPos=0;
        numberOfSegments=0;
        %intialize base numbers
        A=1;
        C=2;
        G=3;
        T=4;
        %for report
        tag=0;
        tga=0;
        taa=0;
        for i=1:3: numberOfBases-2 %must end two places from the end since nothing exists past the final element in the array
            %if statement to find start of protein segment
            if startingPos==0 && dna(i)==A && dna(i+1)==T && dna(i+2)==G %if ATG
                %once start found set variables
                numberOfSegments=numberOfSegments+1;
                startingPos=i;
                continue;
            end
            %find stop codons TAG, TGA, TAA
            if dna(i)==T && startingPos~=0
                % the next two bases after T are GA
                if dna(i+1)==G && dna(i+2)==A %TGA stop codon
                  singleLength=i-startingPos +3; %end of segment length
                  startingPos=0;
                  dna_lengths(numberOfSegments)=singleLength;
                  tga=tga+1;
                % the next two bases after T are AA
                elseif dna(i+1)==A && dna(i+2)==A %TAA stop codon
                  singleLength=i-startingPos +3; %end of segment length
                  startingPos=0;
                  dna_lengths(numberOfSegments)=singleLength;
                  taa=taa+1;
                  % the next two bases after T are AG
                elseif dna(i+1)==A && dna(i+2)==G %TAG stop codon
                  singleLength=i-startingPos +3; %end of segment length
                  startingPos=0;
                  dna_lengths(numberOfSegments)=singleLength;
                  tag=tag+1;
                end
            end
        end
        %print statements for the total number of DNA segments and the
        %minimum, maximum and average lengths
        fprintf('Total Protein-Coding Segments: %i \n',numberOfSegments);
        
        %calculate the average length over the entire array using the mean
        %MATLAB function
        averageLength=mean(dna_lengths(1:numberOfSegments));
        fprintf('Average Length: %.2f \n',averageLength);
        %find the maximum length of DNA
        maximumLength=max(dna_lengths);
        fprintf('Maximum Length: %i \n',maximumLength);
        %find the minimum length of DNA
        minimumLength=min(dna_lengths(1:numberOfSegments));
        fprintf('Minimum Length: %i \n',minimumLength);
        
    otherwise
        error('Wrong input to select a problem.');
end

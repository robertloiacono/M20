%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Homework 5 MATLAB Script
%   Author: Robert Loiacono
%   Date:   2/14/20
%   UID: 305106844
%   Code for Problems 1 and 2
%   Problem 1's goal is to create two functions that will subdivide and 
%   smooth the edges of a square to form a more circular shape. One function 
%   will copy values of the original points into a new array and averaging them 
%   to form the neighboring cells. Using the new array, the other function will 
%   average each value using its neighbors and predetermined coefficients, 
%   called weights, to form a final array. This array will be graphed along with the original points. 
%   Problem 2's goal is to evaluate and compare accuracies between three 
%   different Runge-Kutta numerical methods to the exact equation. Each of 
%   the methods, first order, second order and fourth order, use a timestep 
%   to find a small change in the current y value($y_k$) to find the next y 
%   value or $y_k_+_1$. After calling the function advanceRK until you reach 
%   15 seconds, the data is graphed on three different plots, one for each timestep and containing four curves each.    
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
        %Initialize an x and y vector of known points
        x = [1,2,1,0];
        y = [0, 1, 2,1];
        x0 = x; %To plot original
        y0 = y;
        %w = zeros(1,3);
        %Initialize tracker variables
        maxDis = 1;
        count = 0;
        %Check for the sum
        w(1)=input('Enter a weight value: ');
        w(2)=input('Enter a second weight value: ');
        w(3)=input('Enter a third weight value: ');
        %Iterate until max node displacement reaches a certain limit
        while maxDis >= 1e-3 && count < 20  %set 25 as a limit so loop isnt infinite
            xs = splitPts(x);
            ys = splitPts(y);
            xa = averagePts(xs, w);
            ya = averagePts(ys, w);
            x = xa;
            y = ya;
            %Check to see if max node displacement is too small
            dx = xa - xs;
            dy = ya - ys;
            maxDis = max(sqrt(dx.^2+dy.^2));
            count = count + 1; %Increase count to track loop
        end

        %Plot the results
        plot(x0,y0,'bo');
        hold on
        plot(x,y,'ro');
        title('Plot of Split and Average Results');
        xlabel('x');
        ylabel('y');
        legend('New Points', 'Original Points');

    case 2
        %%Problem 2
        t_i=0;
        t_f=15;
        y_i=1;
        y=1;
        y_new=y;
        dt1=1;
        dt2=0.1;
        dt3=0.01;

        whichmethod=input('Which RK method do you want to use? 1, 2 or 4? ');
        while whichmethod~=1 && whichmethod~=2 && whichmethod~=4
            fprintf('Error. Reenter method value.');
            whichmethod=input('Which RK method do you want to use? 1, 2 or 4? ');
        end
        switch whichmethod
            case 1 %method 1
                time_array1=zeros(1,t_f/dt1);
                y1_array=zeros(1,t_f/dt1);
                time_array2=zeros(1,t_f/dt2);
                y2_array=zeros(1,t_f/dt2);
                time_array3=zeros(1,t_f/dt3);
                y3_array=zeros(1,t_f/dt3);
                count=1;

                for k=t_i:dt1:(t_f/dt1)
                    time_array1(count)=k;
                    y_new=advanceRK(y,dt1,whichmethod);
                    y1_array(count)=y_new;
                    y=y_new;
                    count=count+1;
                end
                for j=1:1:length(y1_array)
                    error1=y1_array(j);
                end
                average1=error1/length(y1_array);
                count=1;
                y=y_i;
                y_new=y_i;
                for k=t_i:dt2:(t_f/dt2)
                    time_array2(count)=k;
                    y_new=advanceRK(y,dt2,whichmethod);
                    y2_array(count)=y_new;
                    y=y_new;
                    count=count+1;
                end
                for a=1:1:length(y2_array)
                    error2=y2_array(a);
                end
                average2=error2/length(y2_array);
                count=1;
                y=y_i;
                y_new=y_i;
                for k=t_i:dt3:(t_f/dt3)
                    time_array3(count)=k;
                    y_new=advanceRK(y,dt3,whichmethod);
                    y3_array(count)=y_new;
                    y=y_new;
                    count=count+1;
                end
                for b=1:1:length(y3_array)
                    error3=y3_array(b);
                end
                average3=error3/length(y3_array);
                fprintf('dt     RK1      RK2      RK4\n');
                fprintf('%.2f:    %.5f      %.5f    %.5f',dt1,average1,average2, average3);
                plot(time_array1,y1_array);
                xlim([0,15])
                hold on
                plot(time_array2,y2_array);
                hold on
                plot(time_array3,y3_array);
                title('Plot of Carbon 15 Decay - Method 1');
                xlabel('Time (t)');
                ylabel('Amount of Carbon 15 Remaining (y)');
                legend('dt=1','dt=0.1','dt=0.01');
            case 2 %method 2
                time_array1=zeros(1,t_f/dt1);
                y1_array=zeros(1,t_f/dt1);
                time_array2=zeros(1,t_f/dt2);
                y2_array=zeros(1,t_f/dt2);
                time_array3=zeros(1,t_f/dt3);
                y3_array=zeros(1,t_f/dt3);
                count=1;
                for k=t_i:dt1:(t_f/dt1)
                    time_array1(count)=k;
                    y_new=advanceRK(y,dt1,whichmethod);
                    y1_array(count)=y_new;
                    y=y_new;
                    count=count+1;
                end
                for j=1:1:length(y1_array)
                    error1=y1_array(j);
                end
                average1=error1/length(y1_array);
                count=1;
                y=y_i;
                y_new=y_i;
                for k=t_i:dt2:(t_f/dt2)
                    time_array2(count)=k;
                    y_new=advanceRK(y,dt2,whichmethod);
                    y2_array(count)=y_new;
                    y=y_new;
                    count=count+1;
                end
                for a=1:1:length(y2_array)
                    error2=y2_array(a);
                end
                average2=error2/length(y2_array);
                count=1;
                y=y_i;
                y_new=y_i;
                for k=t_i:dt3:(t_f/dt3)
                    time_array3(count)=k;
                    y_new=advanceRK(y,dt3,whichmethod);
                    y3_array(count)=y_new;
                    y=y_new;
                    count=count+1;
                end
                for b=1:1:length(y3_array)
                    error3=y3_array(b);
                end
                average3=error3/length(y3_array);
                fprintf('dt     RK1      RK2      RK4\n');
                fprintf('%.2f:    %.5f      %.5f    %.5f',dt1,average1,average2, average3);
                plot(time_array1,y1_array);
                xlim([0,15])
                hold on
                plot(time_array2,y2_array);
                hold on
                plot(time_array3,y3_array);
                title('Plot of Carbon 15 Decay - Method 2');
                xlabel('Time (t)');
                ylabel('Amount of Carbon 15 Remaining (y)');
                legend('dt=1','dt=0.1','dt=0.01');
            case 4 %method 4
                time_array1=zeros(1,t_f/dt1);
                y1_array=zeros(1,t_f/dt1);
                time_array2=zeros(1,t_f/dt2);
                y2_array=zeros(1,t_f/dt2);
                time_array3=zeros(1,t_f/dt3);
                y3_array=zeros(1,t_f/dt3);
                count=1;
                for k=t_i:dt1:(t_f/dt1)
                    time_array1(count)=k;
                    y_new=advanceRK(y,dt1,whichmethod);
                    y1_array(count)=y_new;
                    y=y_new;
                    count=count+1;
                end
                for j=1:1:length(y1_array)
                    error1=y1_array(j);
                end
                average1=error1/length(y1_array);
                count=1;
                y=y_i;
                y_new=y_i;
                for k=t_i:dt2:(t_f/dt2)
                    time_array2(count)=k;
                    y_new=advanceRK(y,dt2,whichmethod);
                    y2_array(count)=y_new;
                    y=y_new;
                    count=count+1;
                end
                for a=1:1:length(y2_array)
                    error2=y2_array(a);
                end
                average2=error2/length(y2_array);
                count=1;
                y=y_i;
                y_new=y_i;
                for k=t_i:dt3:(t_f/dt3)
                    time_array3(count)=k;
                    y_new=advanceRK(y,dt3,whichmethod);
                    y3_array(count)=y_new;
                    y=y_new;
                    count=count+1;
                end
                for b=1:1:length(y3_array)
                    error3=y3_array(b);
                end
                average3=error3/length(y3_array);
                fprintf('dt     RK1      RK2      RK4\n');
                fprintf('%.2f:    %.5f      %.5f    %.5f',dt1,average1,average2, average3);
                plot(time_array1,y1_array);
                xlim([0,15])
                hold on
                plot(time_array2,y2_array);
                hold on
                plot(time_array3,y3_array);
                title('Plot of Carbon 15 Decay - Method 4');
                xlabel('Time (t)');
                ylabel('Amount of Carbon 15 Remaining (y)');
                legend('dt=1','dt=0.1','dt=0.01');
            otherwise
                error('Wrong input. Please reenter.');
        end
    otherwise
        error('Wrong input to select a problem.');
end
% split function to double the size of an array by copying values of the
% previous array and using neighbors to fill in the rest
function[xs]=splitPts(x)
n=length(x);
xs=zeros(1,2*n);
placement=1;
%copy values to every other cell in xs
for i=1:2:2*n
    xs(i)=x(placement);
    placement=placement+1;
end
%fill in other terms by averaging neighbors
for j=2:2:2*n
    %if the final term in array, wrap around
    if j==2*n
        average=(xs(1)+xs(j-1))/2;
        xs(j)=average;
    end
    %any term besides the last
    if j~=2*n
        average=(xs(j-1)+xs(j+1))/2;
        xs(j)=average;
    end
end
end
%average each value in split array by using weight system
function [xa] = averagePts( xs, w)
%Check for the sum equaling zero
while sum(w)==0
    fprintf('Weight sum cannot be 0. Please reenter. ');
    w(1)=input('Enter a weight value: ');
    w(2)=input('Enter a second weight value: ');
    w(3)=input('Enter a third weight value: ');
end
n=length(xs);
xa=zeros(1,n);
%normalize the weights
w1=w(1)/sum(w);
w2=w(2)/sum(w);
w3=w(3)/sum(w);
%average each value in array
for i=1:1:length(xs)
   if i==1
       xa(i)=w1*xs(n)+w2*xs(i)+w3*xs(i+1);
   end
   if i==n
       xa(i)=w1*xs(i-1)+w2*xs(i)+w3*xs(1);
   end
   if i>1 && i<n
       xa(i)=w1*xs(i-1)+w2*xs(i)+w3*xs(i+1);
   end
end
end

function [y]=advanceRK(y,dt,method)
f=-1*log(2)/2.45; %differential equation dy/dt
switch method
    case 1 %first order RungeKutta Method
        c1=dt*f*y;
        y=y+c1;
    case 2 % second order RungeKutta Method
        c1=dt*f*y;
        c2=dt*f*(0.5*(y+c1));
        y=y+c2;
    case 4 %fourth order RungeKutta Method        
        c1=dt*f*y;
        c2=dt*f*(0.5*(y+c1));
        c3=dt*f*(0.5*(y+c2));
        c4=dt*f*(y+c3);
        y=y+(1/6)*c1+(1/3)*c2+(1/3)*c3+(1/6)*c4;
    otherwise
        fprintf('Invalid method. Select either method 1,2 or 4\n');
end
end

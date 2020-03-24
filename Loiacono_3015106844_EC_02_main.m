%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   EC2 Project MATLAB Script
%   Author: Robert Loiacono
%   Date:   3/13/20
%   UID: 305106844
%   Code for EC2 Project
%   This problem uses a zero finding method to find the zeros of a third degree polynomial
%   defined in the second line of the main script. The script asks for user
%   input to determine which of the three values of delta are gonna be
%   used. Instead of evaluating the derivative of the function, I used a
%   central difference approximation using a pertubation size of 10^-6.
%   Finally the script will print out the number of evaluations until it
%   doesn't pass the while loop condition in the function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Clear Cache
clear all
close all
clc

%%MAIN SCRIPT
%initialize function, x0 and the max number of evaluations
x0=1.43;
func = @(x) 816*x^3 - 3835*x^2 + 6000*x-3125;
fEvalMax = 100;

%user input for the value of delta, three options in total
delta=input('Please choose a delta value 1(10^-6), 2(10^-8) or 3(10^10): ');
while delta~=1 && delta~=2 && delta~=3
   fprintf('Error: Please enter a correct delta value:');
   delta=input('Please choose a delta value 1(10^-6), 2(10^-8) or 3(10^10):'); 
end

%depending on input set delta to one of three values
if delta==1 
    delta=10^-6;
elseif delta==2
    delta=10^-8;
else 
    delta=10^-10;
end

%call the function
for i = x0:0.01:1.71
    [xc, fEvals] = Newton(func,i,delta,fEvalMax);
    fprintf('x0 = %3.2f, evals = %i, xc = %7.6f \n', i, fEvals, xc);
end
%%Newton Function 
function [xc,fEvals] = Newton(f,x0,delta,fEvalMax)
h = 10^(-6);
xc = x0;
fd= @(x)(f(x+h)-f(x-h))/(2*h);
fEvals=0;
%until this condition breaks, continually change xc and increase fEvals 
while abs(f(xc))> delta
    fEvals=fEvals+1;
    if fEvals >=fEvalMax
        break;
    end
    xc= xc-(f(xc)/fd(xc));
end
end
%As delta decreases from 10^-6 to 10^-10, the number of evaluations
%required goes up because it takes more iterations to get an approximation
%of that small of a difference. When x0 is in the range of 1.61<=x0<=1.62,
%the values printed in the table show a local minimum or where the slope of the function f(x) is 0. 
% The script gives a zero at each point even though it does so discontinuously.
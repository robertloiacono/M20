%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework 1 Script
% Author: Robert Loiacono 
% UID: 305106844
% Due Date: January 17, 2020
% Code for Problems 1 and 2 of Homework 1
% Problem 1 is designed to take in two radial inputs to calculate the exact
%   and approximate oblate spheroid surface area. Each answer will display 10
%   digits to reveal the difference between the two
% Problem 2 is designed to calculate the perimeter of an ellipse using 8
%   difference equations. None of them produce an exact answer, only an
%   approximation. Each equation (besides P1) is compared back to P1 to find
%   the percent difference between the two.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clearing caches
clear all
close all
clc

%% Main Script
%% Problem 1
%inputs--------------------------------------------------------------------------------------------------------
%asks for the user to input values of r1 and r2
r1=input('Please enter a value for the equatorial radius:\n'); %asks for the equatorial radius
r2=input('Please enter a value for the polar radius:\n'); %asks for the polar radius
%--------------------------------------------------------------------------------------------------------------

%equations-----------------------------------------------------------------------------------------------------
%calculates the exact and approx surface area and the percent differences
Y=acos(r2/r1); %equation to solve for gamma
exact_SA=2*pi*((r1^2)+(r2^2)/sin(Y)*log((cos(Y))/(1-sin(Y)))); %equation to solve for the exact surface area of an oblate spheroid
approx_SA=4*pi*((r1+r2)/2)^2; %equation to solve for the approximate surface area of an oblate spheroid
percent_diff=(exact_SA-approx_SA)/((exact_SA+approx_SA)/2)*100;%percent difference between the exact and approx surface area
%--------------------------------------------------------------------------------------------------------------


%print statements----------------------------------------------------------------------------------------------
%prints out the exact and approx surface area and the percent differences
fprintf('For the inputted radii, the exact surface area of the oblate spheroid is: %10.1f kilometers squared.\n',exact_SA); %print statement to print out exact surface area
fprintf('For the inputted radii, the approximate surface area of the oblate spheroid is: %10.1f kilometers squared.\n',approx_SA); %print statement to print out approximate surface area
fprintf('The percent difference between the exact and approximate surface areas is: %10f.\n',percent_diff);%prints out the percent difference
%--------------------------------------------------------------------------------------------------------------
%% Problem 2
%inputs--------------------------------------------------------------------------------------------------------
%asks for the user to input values of a and b
a=input('Please enter a value for the length of semi-axis a:\n'); %asks for the legnth of semi-axis a
b=input('Please enter a value for the length of semi-axis b:\n'); %asks for the length of semi-axis b
%--------------------------------------------------------------------------------------------------------------

%equations-----------------------------------------------------------------------------------------------------
%equations to calculate P1 through P8 using the values of a,b and h
h=((a-b)/(a+b))^2;
P1=pi*(a+b);
P2=pi*sqrt(2*(a^2 +b^2));
P3=pi*sqrt(2*(a^2 +b^2)-((a-b)^2)/2);
P4=pi*(a+b)*((1+(h/8))^2);
P5=pi*(a+b)*(1+(3*h)/(10+sqrt(4-3*h)));
P6=pi*(a+b)*((64-3*h^2)/(64-16*h));
P7=pi*(a+b)*((256-48*h-21*h^2)/(256-112*h+3*h^2));
P8=pi*(a+b)*((3-sqrt(1-h))/2);
%--------------------------------------------------------------------------------------------------------------

%percent difference equations----------------------------------------------------------------------------------
%calculates the percent differences of P2 through P8 and 
%compares them to P1

P1_P2=(P1-P2)/((P1+P2)/2)*100;
P1_P3=(P1-P3)/((P1+P3)/2)*100;
P1_P4=(P1-P4)/((P1+P4)/2)*100;
P1_P5=(P1-P5)/((P1+P5)/2)*100;
P1_P6=(P1-P6)/((P1+P6)/2)*100;
P1_P7=(P1-P7)/((P1+P7)/2)*100;
P1_P8=(P1-P8)/((P1+P8)/2)*100;
%--------------------------------------------------------------------------------------------------------------

%print statements----------------------------------------------------------------------------------------------
%prints out the values of P1 through P8 and their percent 
%differences compared to P1

fprintf('For the inputted values of a and b, the value of h is: %3f units. \n',h)
fprintf('The value of P1 is: %3.3f units. \n',P1);
fprintf('The value of P2 is: %3.3f units, and the percent difference compared to P1 is: %2.3f.\n',P2,P1_P2); 
fprintf('The value of P3 is: %3.3f units, and the percent difference compared to P1 is: %2.3f.\n',P3,P1_P3);
fprintf('The value of P4 is: %3.3f units, and the percent difference compared to P1 is: %2.3f.\n',P4,P1_P4);
fprintf('The value of P5 is: %3.3f units, and the percent difference compared to P1 is: %2.3f.\n',P5,P1_P5);
fprintf('The value of P6 is: %3.3f units, and the percent difference compared to P1 is: %2.3f.\n',P6,P1_P6);
fprintf('The value of P7 is: %3.3f units, and the percent difference compared to P1 is: %2.3f.\n',P7,P1_P7);
fprintf('The value of P8 is: %3.3f units, and the percent difference compared to P1 is: %2.3f.\n',P8,P1_P8);
%--------------------------------------------------------------------------------------------------------------
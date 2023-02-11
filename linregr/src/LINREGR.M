
% Example: linear regression

% clear workspace
clear all;

% data configuration
N=100;             % number of points
Xmin=-5;  Xmax=5;  % X series range
Ys=2.5;            % noise variance
A=[0.5 3]';        % ideal linear model

% step-1: create X series and noisy Y responses
X=linspace( Xmin, Xmax, N )';
sz=length(X);
Y=( [X ones(sz,1)]*A ) + rand(sz,1)*Ys;   % Y=A1*X+A2+err

% step-2: estimate the LSE linear fit
B = [X ones(sz,1)]\Y;      % LSE solution: YY=B1*X+B2
YY = [X ones(sz,1)]*B;     % create estimated Y responses

% step=3: show the results
txtY=sprintf('estimated:  Y = %.6f x (X) + %.6f',B(1),B(2));
txtT=sprintf('Linear regression:  Y = %.3f x (X) + %.3f',A(1),A(2));
disp(txtT);
disp(txtY);
disp('<press any key to plot>');
pause;

plot(X,Y,'wo',X,YY,'g-');   % plot the noisy data points and the LSE fit
xlabel('X series');
ylabel(txtY);
title(txtT);

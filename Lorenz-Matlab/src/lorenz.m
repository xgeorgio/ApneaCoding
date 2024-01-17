clear all;

iterN=10000;
dt=0.01;
rho=28;
beta=8/3;
sigma=10;

XYZ=zeros(iterN,4);          % [1..3]=<x,y,z>, [4]=dist(<0,0,0>)

XYZ(1,1:3)=ones(1,3);                 % initial point (seed)
XYZ(1,4)=sqrt(sum(XYZ(1,1:3).^2));    % distance from (0,0,0)

for k=2:iterN
  dx=sigma*(XYZ(k-1,2)-XYZ(k-1,1));             % dx/dt=sigma*(y-x)
  dy=XYZ(k-1,1)*(rho-XYZ(k-1,3))-XYZ(k-1,2);    % dy/dt=x*(rho-z)-y
  dz=XYZ(k-1,1)*XYZ(k-1,2)-beta*XYZ(k-1,3);     % dz/dt=x*y-beta*z

  XYZ(k,1:3)=XYZ(k-1,1:3)+[dx dy dz]*dt;        % 1st-order Euler step
  XYZ(k,4)=sqrt(sum(XYZ(k,1:3).^2));            % distance from (0,0,0)
end

figure(1);
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3));
grid on;
title('Lorenz attractor XYZ');

figure(2);
plot(1:size(XYZ,1),XYZ(:,4));
grid on;
title('distance from (0,0,0)');





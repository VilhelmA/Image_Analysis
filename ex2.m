clear all
load('heart_data.mat');

[M N] =size(im);
n = M*N; %Number of image pixels

%Calculate mean and std for chamber and background
c_mean=mean(chamber_values);
b_mean=mean(background_values);
c_std=std(chamber_values);
b_std=std(background_values);

lambda=1.7;

%Find 4-neighbours
Neighbors = edges4connected(M,N);
i=Neighbors(:,1);
j=Neighbors(:,2);
A = sparse(i,j,lambda,n,n);

%From lab 3 and instructions
T = zeros(n,2);
T(:,1)=(-log(normpdf(im(:),c_mean,c_std)));
T(:,2)=(-log(normpdf(im(:),b_mean,b_std)));
for i = 1:95
    for j = 80:96
        T(i *96+ j ,1) = intmax;
    end
end
% Ground truth : Upper part of image is definitely background.
for i = 1:95
    for j = 1:10
        T(i *96+ j ,1) = intmax;
    end
end
T = sparse(T);

[E, theta] = maxflow(A,T);
theta = reshape(theta,M,N);
theta = double(theta);
imshow([theta, im])
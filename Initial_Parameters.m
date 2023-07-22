%% init
set(0,'defaultfigurecolor','w');

%% simulation & fig setting
fig_shape = false;

%% model parameters
if ~exist("delay", "var")
    delay = 0.1;
end
if ~exist("kv", "var")
    kv = 10;
end
if ~exist("kp", "var")
    kp = 1;
end
if ~exist("kbeta", "var")
    kbeta = 1.5;
end

%% leader dynamic
% ax = acc_x, ay = acc_y*cos(w_y*t)+c_y;
acc_x = 0.1;
acc_y = 0.5;
w_y = 0.5;
c_y = 0;

%% if use historical infomation
use_his_info = true;

%% formation shape & leader num
leaderNum = 3;
P=2*[2 0;
    1 1;
    1 -1;
    0 1.2;
    0 -1.2;
    -1 1;
    -1 -1;
    -2 0.5;
    -2 -0.5];
P0 = [2 0;
      1 1;
      1 -1;
      1 2.2;
      -1 -2.2;
      1 3;
      -3 -3;
      1 3.5;
      -5 -3.5];
dim = size(P,2);

%% undirected adjacent matrix
nodenum = size(P,1);
followerNum = nodenum - leaderNum;
neighborMat=zeros(nodenum,nodenum);
neighborMat(1,2)=1;neighborMat(1,3)=1;neighborMat(1,8)=1;neighborMat(1,9)=1;
neighborMat(2,4)=1;neighborMat(2,7)=1;
neighborMat(3,5)=1;neighborMat(3,6)=1;neighborMat(3,4)=1;neighborMat(2,5)=1;
neighborMat(4,5)=1;neighborMat(4,6)=1;neighborMat(2,7)=1;neighborMat(4,7)=0;
neighborMat(5,7)=1;neighborMat(5,8)=0;neighborMat(5,6)=0;
neighborMat(6,7)=1;neighborMat(6,8)=1;
neighborMat(7,9)=1;
neighborMat(8,9)=1;
m=sum(sum(neighborMat)); % number of edges
neighborMat=neighborMat+neighborMat';

%% stress matrix
% note: stress matrix returned is -Omega
stressMat=-fcn_StressMatrix(2,nodenum,m,P,neighborMat,fig_shape);
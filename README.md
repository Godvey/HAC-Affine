#  Enhanced Affine Formation Maneuver Control Using Historical Acceleration Command (HAC) Simulation Code

## Introduction

Simulation code for ***Enhanced Affine Formation Maneuver Control Using Historical Acceleration Command (HAC)***.

**Author：Wei Yu & Peng Yi**

**Date：     2023-07-22**

## Requirments
- Matlab Version 2020b and above.
- Simulink Version 2020b and above.

## Code Structure

<img width="317" alt="code_structure" src="https://github.com/Lovely-XPP/HAC-Affine/assets/66028151/93326ddd-ac32-4532-9cab-aea330c388e4">

- `affine_double_intergrator.slx` - Main programme of simulation by Simulink.

- `run_by_script.m` - A Matlab script to easyly run simulation and demonstrate results including essential figures and cohesiveness.

- `fcn_StressMatrix.m` - A script to calculate Stress Matrix by Shiyu, Zhao.

- `Initial_Parameters.m` - A script to initialize parameters for simulation.

- `FigureUtility` - Functions of visualizing simulation results including trajectory, norm error, etc.

- `VideoUtility` - Functions of visualizing simulation formation maneuvering and some cases demonstration.

## Usage
It is strongly recommended to use `run_by_script.m` for simulation. Detailed Usage is as follow:

- **Setting simulation case with different $\tau$**: setting variable `delays`. Example:
  
    ```matlab
    delays = [0.01, 0.1, 0.5, 1];
    ```
    
- **Setting different controller parameters**: setting variable `kp`, `kv` and `kbeta`, which is as the same as the paper defined. Example:
  
    ```matlab
    kp = 1;
    kv = 10;
    kbeta = 1.5;
    ```
    
- **Setting simulation condition**: variable `simtime` for simulation time and variable `simstep` for simulation step size. Example:
  
    ```matlab
    simtime = 50;
    simstep = 0.01;
    ```

If you want to **change formation and initial positions**, you can modity `Initial_Parameters.m`. Detailed Usage is as follow:

- **Setting formation**: setting variable `P`, which means the configuration of the agents， also, you need to change Adjacency Matrix. Example:

  ```matlab
  P=2*[2 0;
      1 1;
      1 -1;
      0 1.2;
      0 -1.2;
      -1 1;
      -1 -1;
      -2 0.5;
      -2 -0.5];
  
  neighborMat=zeros(nodenum,nodenum);
  neighborMat(1,2)=1;neighborMat(1,3)=1;neighborMat(1,8)=1;neighborMat(1,9)=1;
  neighborMat(2,4)=1;neighborMat(2,7)=1;
  neighborMat(3,5)=1;neighborMat(3,6)=1;neighborMat(3,4)=1;neighborMat(2,5)=1;
  neighborMat(4,5)=1;neighborMat(4,6)=1;neighborMat(2,7)=1;neighborMat(4,7)=0;
  neighborMat(5,7)=1;neighborMat(5,8)=0;neighborMat(5,6)=0;
  neighborMat(6,7)=1;neighborMat(6,8)=1;
  neighborMat(7,9)=1;
  neighborMat(8,9)=1;
  ```

- **Setting initial positions**: setting variable `P0`. Example:

  ```matlab
  P0 = [2 0;
        1 1;
        1 -1;
        1 2.2;
        -1 -2.2;
        1 3;
        -3 -3;
        1 3.5;
        -5 -3.5];
  ```

  

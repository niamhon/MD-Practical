# MD-Practical
Practical on MD for LJC Summer School

This practical is structured in two main sections. In the first section ```01_MD-Fundamentals``` you will work on a bare-bones MD code, and implement some of the key functions in order to run an MD simulation. In the second part ```02_LAMMPS-electrolyte```, you will look at a more `real-world' example, where you will set up your own simulation and run it on a HPC, and then analyse the resulting trajectory.

## Part 0: Setup
```git clone https://github.com/niamhon/MD-Practical.git ```

## Part 1: MD-Fundamentals
In this section we will follow in the footsteps of Aneesur Rahman, who ran published the first molecular dynamics computer simulation on liquid argon in 1964 [[1]](#1). Fittingly for this summer school, we will also be modelling the interactions between the Ar atoms with a Lennard Jones potential.
We have provided you with a skeleton of the molecular dynamics code. 

### 1:Force Calculation 

### 2:Integration
Implement the simple Euler and Velocity-Verlet algorithms. Check if they are energy conserving.
### 3: Analysis of trajectory
Implement a radial distribution function on the trajectory you have generated.

## Part 2: LAMMPS electrolyte
Now you have got to grips with the basics of running an MD simulation, we will now consider a more complex system, which you may be interested in simulating in a research project. While in the last part, you wrote your own MD code from scratch, in practice MD simulations are run using sophisticated codes -- one of which LAMMPS -- we will be using today.

The system we will look at is an electrolyte solution of NaCl in water in contact with graphene. This is an interesting interfacial system

## References
<a id="1">[1]</a> 
A. Rahman
Phys. Rev. 136, A405 – Published 19 October 1964

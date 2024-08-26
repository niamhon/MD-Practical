# MD-Practical
Practical on MD for LJC Summer School

This practical is structured in two main sections. In the first section ```01_MD-Fundamentals``` you will work on a bare-bones MD code, and implement some of the key functions in order to run an MD simulation. In the second part ```02_LAMMPS-electrolyte```, you will look at a more `real-world' example, where you will set up your own simulation and run it on a HPC, and then analyse the resulting trajectory.

## Part 0: Setup
```git clone https://github.com/niamhon/MD-Practical.git ```

## Part 1: MD-Fundamentals

### MD Simulation of Liquid Argon

![Liquid argon simulation](https://github.com/niamhon/MD-Practical/blob/main/01_MD-Funadamentals/argon.jpg)

In this section we will follow in the footsteps of Aneesur Rahman, who ran the first molecular dynamics computer simulation on liquid argon 60 years ago in 1964 [[1]](#1). Fittingly for this summer school, we will also be modelling the interactions between the Ar atoms with a Lennard Jones potential. This potential is given by:

$U(r) = 4\epsilon [(\frac{\sigma}{r})^{12} -(\frac{\sigma}{r})^{6} ]$

where $\sigma$ and $\epsilon$ are characteristic lengths and energies for a given system.

```cd MD-Practical```

We have provided you with a skeleton of the molecular dynamics code in the ```MD.ipynb``` notebook.

We want to simulate liquid argon at the same conditions Rahman used ($\mathrm{T} = 94.4 \mathrm{K}$, $\rho = 1.374 \mathrm{g/cm}^3$).
In this simulation we use reduced Lennard Jones units, so that our potential becomes:

$U^\star(r^{\star}) = 4 \left[\left(\frac{1}{r^*}\right)^{12} - \left(\frac{1}{r^*}\right)^{6}\right]$

**Qs:** Can you think of reason(s) why we would use reduced units?

**Qs:** The Lennard-Jones parameters for Xenon are $\sigma = 3.96 \AA{}$ and $\epsilon/k_B = 231.1 K $. To what conditions of Xenon does our simulation of Argon correspond?

###Step 1: Initialisation:
We will initialise the particles on a lattice. 
So that your code runs reasonably quickly you should use 125 particles. Your first task is to calculate the box size, temperature and timestep you should use in your simulation in reduced units.

You should then initialise your MD simulation with the parameters you have computed:

```md_simulation = MD(n_particles, box_length_star, temperature_star, dt_star, read_positions = False)```

You can use a code called _ASE_ (Atomic Simulation Environment) to visualise the system.

```
system = Atoms(['Ar'] * md_system.n_particles, positions = md_system.positions * sigma_ar*1E10)
system.set_cell([box_length_star * sigma_ar*1E10, box_length_star * sigma_ar*1E10, box_length_star * sigma_ar*1E10])
view(system, viewer = 'x3d')
```

### Running the simulation

Running a MD simulation is based on a general series of steps:
1. Initialise system (positions and velocities)
2. Compute forces
3. Integrate to get next position

We have already initialised the system now and you can see that the code sets the positions, velocities and old positions

### 1:Force Calculation 
The calculation of the Lennard Jones Potential is implemented. However, you should implement the minimum image convention to compute `xr`.

### 2:Integration
Once the force has been calculated the next step is to integrate the equations of motion. There are many numerical schemes for doing this, with different accuracies and stabilities. In this practical we will investigate two such schemes, the _simple Euler_ method and the _velocity-Verlet_ method.

There is space for two new functions defined in the code: ```def euler``` and ```def velocity_verlet``` for you to implement. Note that you can access and update the velocities and positions by for example: ```self.positions = new_positions```

### 3:Compute temperature from simulation

There is a function defined that you should complete to compute the temperature at each step in the simulation: 

```
def calculate_temperature(self):

  return temperature
```

Recall that the temperature can be related to the average kinetic energy per degreee of freedom as $\frac{1}{2}k_B T = \langle \frac{1}{2} m v^2 \rangle$

### 4: Run a Simulation

Once you have implemented the integrators you can now try and test your MD code.

You can run the simulation like this:

```positions, properties = md_simulation.do_MD(n_steps, integrator='velocity_verlet')```

where you should define ```n_steps``` and the ```integrator```.

The code will print out some properties of interest that you can monitor over the simulation [. 

**Qs:** What is the difference between the Euler and Velocity-Verlet schemes? (Hint: check if they are energy conserving.)

**Qs:** What happens if you increase the timestep?

### 3: Analysis of trajectory
Run your simulation for 1000 steps. What does the radial distribution function look like?
First you should run a simulation at a high temperature to `melt' the lattice. In your 

The radial distribution function gives a measure of structural 
Implement a radial distribution function on the trajectory you have generated.

## Part 2: LAMMPS electrolyte
Now you have got to grips with the basics of running an MD simulation, we will now consider a more complex system, which you may be interested in simulating in a research project. While in the last part, you wrote your own MD code from scratch, in practice MD simulations are run using sophisticated codes -- one of which LAMMPS -- we will be using today.

The system we will look at is an electrolyte solution of NaCl in water in contact with graphene. This is an interesting interfacial system

## References
<a id="1">[1]</a> 
A. Rahman
Phys. Rev. 136, A405 – Published 19 October 1964

# MD-Practical
Practical on MD for LJC Summer School

This practical is structured in two main sections. In the first section ```01_MD-Fundamentals``` you will work on a bare-bones MD code, and implement some of the key functions in order to run an MD simulation. In the second part ```02_LAMMPS-electrolyte```, you will look at a more `real-world' example, where you will set up your own simulation and run it on a HPC, and then analyse the resulting trajectory.

## Part 0: Setup
```
source ~/rds/rds-ljc-summerschool/4_Molecular_dynamics/moldyn/bin/activate
git clone https://github.com/niamhon/MD-Practical.git
```

## Part 1: MD-Fundamentals

### MD Simulation of Liquid Argon

![Liquid argon simulation](https://github.com/niamhon/MD-Practical/blob/main/01_MD-Fundamentals/argon.jpg)

In this section we will follow in the footsteps of Aneesur Rahman, who ran the first molecular dynamics computer simulation on liquid argon 60 years ago in 1964 [[1]](#1). Fittingly for this summer school, we will also be modelling the interactions between the Ar atoms with a Lennard Jones potential. This potential is given by:

$U(r) = 4\epsilon [(\frac{\sigma}{r})^{12} -(\frac{\sigma}{r})^{6} ]$

where $\sigma$ and $\epsilon$ are characteristic lengths and energies for a given system.

```cd MD-Practical```

We have provided you with a skeleton of the molecular dynamics code in the ```MD.ipynb``` notebook.

We want to simulate liquid argon at the same conditions Rahman used ($\mathrm{T} = 94.4 \mathrm{K}$, $\rho = 1.374 \mathrm{g/cm}^3$).

Generally in simulations we use reduced Lennard Jones units, so that our potential becomes:

$U^{\star}(r^{\star}) = 4 [(\frac{1}{r*})^{12} -(\frac{1}{r*})^{6} ]$

In the first section of the notebook ```Plot Lennard-Jones Potential``` to get used to plotting with matplotlib you should plot the Lennard Jones potential. 

**Qs:** Can you think of reason(s) why we would use reduced units?

**Qs:** The Lennard-Jones parameters for Xenon are $\sigma = 3.96 Å $ and $\epsilon/k_B = 231.1 K $. To what conditions of Xenon does our simulation of Argon correspond?


Running a MD simulation is based on a general series of steps that are repeated:
1. Initialise system (positions and velocities)
2. Compute forces
3. Integrate to get next position
4. Compute properties

### Step 1: Initialisation:

We will initialise the argon particles on a lattice, to give a reasonable starting configuration (_can you think what would happen for example if the atoms were intialised on top of or very close to each other?_)
So that your code runs reasonably quickly you should use 125 particles. Your first task is to calculate the box size, temperature and timestep you should use in your simulation in reduced units.

You should then initialise your MD simulation with the parameters you have computed in the next cell:

```md_simulation = MD(n_particles, box_length_star, temperature_star, dt_star, read_positions = False)```

You can use a code called _ASE_ (Atomic Simulation Environment) to visualise the system.

```
system = Atoms(['Ar'] * md_simulation.n_particles, positions = md_simulation.positions * sigma_ar*1E10)
system.set_cell([box_length_lj * sigma_ar*1E10, box_length_lj * sigma_ar*1E10, box_length_lj * sigma_ar*1E10])
view(system, viewer = 'x3d')
```

We have already initialised the system now and you can see that the code sets the positions, velocities and old positions

### Step 2: Force Calculation
The calculation of the Lennard Jones Potential is implemented. However, you should implement the minimum image convention to compute `xr`.

### Step 3: Integration
Once the force has been calculated the next step is to integrate the equations of motion. There are many numerical schemes for doing this, with different accuracies and stabilities. In this practical we will investigate two such schemes, the _simple Euler_ method and the _velocity-Verlet_ method.

There is space for two new functions defined in the code: ```def euler``` and ```def velocity_verlet``` for you to implement. Note that you can access and update the velocities and positions by for example: ```self.positions = new_positions```

### Step 4: Compute temperature from simulation

There is a function defined that you should complete to compute the temperature at each step in the simulation: 

```
def calculate_temperature(self):

  return temperature
```

Recall that the temperature can be related to the average kinetic energy per degreee of freedom as $\frac{1}{2}k_B T = \langle \frac{1}{2} m v^2 \rangle$

### Run the Simulation

Once you have implemented the integrators you can now try and test your MD code.

You can run the simulation like this:

```positions, properties = md_simulation.do_MD(n_steps, integrator='velocity_verlet')```

where you should define ```n_steps``` and the ```integrator```.

The code will print out some properties of interest that you can monitor over the simulation [Timestep; kinetic energy; potential energy; total energy; temperature]. 
These properties are also saved to a file called ```data.txt```, which you can load nd plot different properties over time (use numpy and matplotlib or else if you prefer gnuplot or some other plotting software).

**Qs:** What is the difference between the Euler and Velocity-Verlet schemes? (Hint: check if they are energy conserving.)

**Qs:** What happens if you increase the timestep?

### Analysis of trajectory
You will notice that the code also saves the _trajectory_ as ```positions.npy```, that is the positions of all particles at each timestep of the simulation. The trajectory is very rich in information and we can compute many different static and dynamic properties simply from the positions of the atoms. You can load the trajectory as shown in the notebook with ```np.load('positions.npy')```

Today we will compute the radial distribution function (RDF). This is defined as 

$g(r) = $

You should define a function as shown 
```
def get_rdf(positions, nbins=100):
  return gr
```
that returns the radial distribution function given a trajectory.

Run your simulation for 1000 steps and then plot the radial distribution function. How does it look?

If your system is still looking very `solid-like' instead of waiting for a long time for it to melt, you could instead run a short (1000 steps) simluation at a higher temperature and then use the last frame to initialise a _production_ simulation at the target temperature. You can use the last frame of a saved trajectory by enabling ```read_positions=True``` in the initialisation:

```
md_simulation = MD(n_particles, box_length_lj, temperature_lj, dt_lj, read_positions=True)
```



## Part 2: LAMMPS electrolyte

![Interfacial electrolyte simulation](https://github.com/niamhon/MD-Practical/blob/main/02_LAMMPS-electrolyte/01_LAMMPS-simulation/nacl_h2o_c.jpg)

Now you have got to grips with the basics of running an MD simulation, we will now consider a more complex system, which you may be interested in simulating in a research project. While in the last part, you wrote your own MD code from scratch, in practice MD simulations are run using sophisticated codes -- one of which LAMMPS -- we will be using today.

The system we will look at is an electrolyte solution of NaCl in water in contact with graphene. This is an interesting interfacial system with technological relevance for example in desalination membranes.

In the first part of this section we will setup a LAMMPS input file and then submit a simulation on CSD3. 

### Running simulation with LAMMPS

```
cd 02_LAMMPS-electrolyte/LAMMPS-simulation
```

You have been provided with a LAMMPS input file with some key information missing. Your first task is to complete the LAMMPS input script ```system.in```, using help from the documentation at: https://docs.lammps.org/Manual.html. You can use whatever text editor you would like to adapt the input files.

The section you should fix is the ```Interactions Section``` as shown:

```
# ----------------- Interactions Section -----------------

bond_coeff   1           1000.0  1.0 
angle_coeff  1         1000.0  109.47

pair_coeff   1 1    XXX  YYY 
pair_coeff   2 2    XXX  YYY 

pair_coeff 4 4  XXX  YYY 
pair_coeff 3 3  XXX YYY 
pair_coeff 5 5  XXX YYY
```

where the Lennard-Jones parameters are missing.

Unlike in the previous part, where we just had one Lennard-Jones $\sigma$ and $\epsilon$ for Argon, now since we have a more complicated system, there are different values of $\sigma$ and $\epsilon$ for the various interactions. 

We are using a rigid model SPC/E for water, whose parameters you can find here: http://www.sklogwiki.org/SklogWiki/index.php/SPC/E_model_of_water, while the Na and Cl parameters can be found here: https://pubs.acs.org/doi/10.1021/ja00131a018

You will have to do a bit more work to get the carbon parameters. This paper: https://pubs.acs.org/doi/10.1021/jp0268112 gives the _C-O_ paramters as $\sigma_{\mathrm{CO}} = 3.190$ Å and $\epsilon_{\mathrm{CO}} = 0.09369002$ kcal/mol. You should use the Lorentz-Berthelot mixing rules: $\epsilon_{ij} = \sqrt{\epsilon_i \epsilon_j}$ and $\sigma_{ij} = \frac{1}{2} (\sigma_i + \sigma_j)$. 

_Hints:_ Make sure the units you use are consistant with the units defined in the input file. Make sure that you map the correct interactions to the correct atom types. You can see how the atom types are labelled in the `init_nvt.data` file.

### Analysing simulation

```cd 02_LAMMPS-electrolyte/analysis```

We are now ready to analyse the trajectory you generated above. You should use the ```trajectory-analysis.ipynb``` Jupyter notebook to run the analysis.

## References
<a id="1">[1]</a> 
A. Rahman
Phys. Rev. 136, A405 – Published 19 October 1964

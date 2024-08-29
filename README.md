# MD-Practical
### Practical on MD for LJC Summer School: 4th September 2024 


This practical is structured in two main sections. In the first section ```01_MD-Fundamentals``` you will work on a bare-bones MD code, and implement some of the key functions in order to run an MD simulation. In the second part ```02_LAMMPS-electrolyte```, you will look at a more `real-world' example, where you will set up your own simulation and run it on a HPC, and then analyse the resulting trajectory.

There are solutions notebooks available for both sections of the pracitcal in their respective folders. However we _strongly_ reccommend that you do not look at these until after the practical or if you are desparately stuck. It is better to ask one of us and talk through any problems than simply copying an answer (you may also come up with much more efficient solutions!). 

## Part 0: Setup
The practical will be run on CSD3 which you by now are probably familiar with. You should first connect to CSD3 as usual. Then run the following code to download the practical exercises from the Github repository to activate the environment.

```
mkdir 4_Molecular_dynamics
cd 4_Molecular_dynamics
source ~/rds/rds-ljc-summerschool/4_Molecular_dynamics/moldyn/bin/activate
git clone https://github.com/niamhon/MD-Practical.git
cp /rds/project/hpc/rds-hpc-training/rds-ljc-summerschool/shared/4_Molecular_dynamics/data/* ./MD-Practical/02_LAMMPS-electrolyte/02_analysis
```

## Part 1: MD-Fundamentals

### MD Simulation of Liquid Argon

![Liquid argon simulation](https://github.com/niamhon/MD-Practical/blob/main/01_MD-Fundamentals/argon.jpg)

In this section we will follow in the footsteps of Aneesur Rahman, who ran the first molecular dynamics computer simulation on liquid argon 60 years ago in 1964 [[1]](#1). Fittingly for this summer school, we will also be modelling the interactions between the Ar atoms with a Lennard Jones potential. 

```cd MD-Practical/01_MD-Fundamentals```

We have provided you with a skeleton of the molecular dynamics code in the ```MD.ipynb``` notebook.

Work through the notebook, filling in the required code to run an MD simulation of liquid Argon.


## Part 2: LAMMPS electrolyte

![Interfacial electrolyte simulation](https://github.com/niamhon/MD-Practical/blob/main/02_LAMMPS-electrolyte/01_LAMMPS-simulation/nacl_h2o_c.jpg)

Now you have got to grips with the basics of running an MD simulation, we will now consider a more complex system, which you may be interested in simulating in a research project. While in the last part, you wrote your own MD code from scratch, in practice MD simulations are run using sophisticated codes -- one of which LAMMPS -- we will be using today.

The system we will look at is an electrolyte solution of NaCl in water in contact with graphene. This is an interesting interfacial system with technological relevance for example in desalination membranes.

In the first part of this section we will setup a LAMMPS input file and then run a simulation on CSD3. 

### Running simulation with LAMMPS

```
cd 02_LAMMPS-electrolyte/LAMMPS-simulation
```
#### Setting up the input file

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

You will have to do a bit more work to get the carbon parameters. This paper: https://pubs.acs.org/doi/10.1021/jp0268112 gives the _C-O_ paramters as $\sigma_{\mathrm{CO}} = 3.190$ Å and $\epsilon_{\mathrm{CO}} = 0.09369002$ kcal/mol. You should use the Lorentz-Berthelot mixing rules: $\epsilon_{ij} = \sqrt{\epsilon_i \epsilon_j}$ and $\sigma_{ij} = \frac{1}{2} (\sigma_i + \sigma_j)$, which gives a formula to obtain the mixed interactions between species $i$ and $j$ from their resepective interaction parameters. 

_Hints:_ Make sure the units you use are consistant with the units defined in the input file. Make sure that you map the correct interactions to the correct atom types. You can see how the atom types are labelled in the `init_nvt.data` file.

#### Running the simulations

```
module purge
module load rhel8/default-icl
module load intel-oneapi-mkl/2022.1.0/intel/mngj3ad6
mpirun -np 1 /rds/project/hpc/rds-hpc-training/rds-ljc-summerschool/shared/4_Molecular_dynamics/lammps/src/lmp_intel_cpu_intelmpi -in system.in &
```

You can monitor the output of the simulation in the ```log.lammps``` file. 

**Plot the simulation speed (timesteps per second) vs number of cores**

### Analysing simulation

```cd 02_LAMMPS-electrolyte/analysis```

We are now ready to analyse the trajectory you generated above. You should use the ```trajectory-analysis.ipynb``` Jupyter notebook to run the analysis.

While the LAMMPS code is much more efficient than our home-made code from Part 1, chances are you still have not got a trajectory long enough to obtain converged properties for the system in the 20 minutes or so that you have run the simulation. For this reason we have supplied you with a 10 ns trajectory ```traj.dcd ``` that we generated previously which you should use for the analysis.


## References
<a id="1">[1]</a> 
A. Rahman
Phys. Rev. 136, A405 – Published 19 October 1964

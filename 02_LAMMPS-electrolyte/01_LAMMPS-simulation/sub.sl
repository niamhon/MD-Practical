#!/bin/bash
#SBATCH --account=cfn312320
#SBATCH --nodes=2
#SBATCH --ntasks=96
#SBATCH --time=24:00:00
#SBATCH --partition=cfn

module load intel
export OMPI_MCA_btl=^openib
source /sdcc/u/kfong/software/cp2k/tools/toolchain/install/setup

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/sdcc/u/kfong/software/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/sdcc/u/kfong/software/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/sdcc/u/kfong/software/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/sdcc/u/kfong/software/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda activate mainenv

srun /sdcc/u/kfong/software/n2p2-cNNPMD/bin/lmp_mpi -in system.in

exit



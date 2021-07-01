#!/bin/bash

#SBATCH --nodes=4
#SBATCH --partition=GPU
#SBATCH --ntasks-per-node 2
#SBATCH --time=00:17:00
#SBATCH --gres=gpu:v100-16:8
##SBATCH --res challengegpu
#SBATCH -A tra210016p
set -x
module load cuda/11.1.1 openmpi/4.0.5-nvhpc21.2
./run.sh ${1} hybrid_gpu big ${2}

#!/bin/bash

#SBATCH --nodes=1
#SBATCH --partition=GPU-shared
#SBATCH --ntasks-per-node 1
#SBATCH --time=00:00:30
#SBATCH --gres=gpu:v100-16:1
##SBATCH --res challengegpu
#SBATCH -A tra210016p
set -x
module load cuda/11.1.1
./run.sh ${1} openacc small ${2}

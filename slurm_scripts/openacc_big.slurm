#!/bin/bash

#SBATCH --nodes=1
#SBATCH --partition=GPU
#SBATCH --ntasks-per-node 1
#SBATCH --time=00:03:00
#SBATCH --gres=gpu:v100-16:8
##SBATCH --res challengegpu
#SBATCH -A tra210016p
set -x
module load cuda/11.1.1
./run.sh ${1} openacc big ${2}

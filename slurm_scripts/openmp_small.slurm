#!/bin/bash

#SBATCH --nodes=1
#SBATCH --partition=RM
#SBATCH --ntasks-per-node 4
#SBATCH --time=00:00:30
##SBATCH --res challenge
#SBATCH -A tra210016p
set -x
./run.sh ${1} openmp small ${2}

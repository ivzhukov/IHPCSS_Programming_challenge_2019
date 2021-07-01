#!/bin/bash

#SBATCH --nodes=4
#SBATCH --partition=RM
#SBATCH --ntasks-per-node 28
#SBATCH --time=00:04:00
##SBATCH --res challenge
#SBATCH -A tra210016p
set -x
./run.sh ${1} mpi big ${2}

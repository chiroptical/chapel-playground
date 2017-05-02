#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --job-name=tests
#SBATCH --output=tests.out
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=10
#SBATCH --cluster=mpi

source /ihome/sam/bmooreii/src/chapel/util/setchplenv.bash
source /ihome/sam/bmooreii/projects/chapel/chapel.sh

export HFI_NO_CPUAFFINITY=1

$SLURM_SUBMIT_DIR/overflow \
    --numLocales=$SLURM_NNODES \
    --tasksPerLocale=$SLURM_NTASKS_PER_NODE

#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --job-name=summa
#SBATCH --output=summa.out
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=10
#SBATCH --cluster=mpi

module load chapel

$SLURM_SUBMIT_DIR/$SLURM_JOB_NAME \
    --numLocales=$SLURM_NNODES \
    --tasksPerLocale=$SLURM_NTASKS_PER_NODE

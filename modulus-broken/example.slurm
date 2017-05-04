#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --job-name=example
#SBATCH --output=example.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=mpi

module load chapel

$SLURM_SUBMIT_DIR/$SLURM_JOB_NAME \
    --numLocales=$SLURM_NNODES

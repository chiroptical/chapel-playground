#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --job-name=hello
#SBATCH --output=hello.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=28
#SBATCH --cluster=dist

source /ihome/sam/bmooreii/src/chapel/util/setchplenv.bash
source chapel.sh

#module load openmpi

#/usr/shmem/gcc/gasnet-1.24.2-openmpi-hfi/bin/gasnetrun_psm -n 56 $SLURM_SUBMIT_DIR/hello_real --numLocales=$SLURM_NNODES
$SLURM_SUBMIT_DIR/hello --numLocales=$SLURM_NNODES --tasksPerLocale=$SLURM_NTASKS_PER_NODE

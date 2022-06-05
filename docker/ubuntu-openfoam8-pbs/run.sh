#!/bin/sh

#PBS -l nodes=1:ppn=4
#PBS -q batch
#PBS -N pbs-test
#PBS -o test.stdout
#PBS -e test.stderr

export OMP_NUM_THREADS=2

cd ${PBS_O_WORKDIR}

# execution
mpirun --allow-run-as-root -np 4 ./test
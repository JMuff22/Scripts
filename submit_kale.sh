#!/bin/bash -l

#SBATCH -J MCP ##job name
#SBATCH -o std.out ##standard out file
#SBATCH -e std.err  ##standard error file
#SBATCH -n 1    ##number of cores to be used
#SBATCH -t 0-06:00:0  ##maximum CPU time
#SBATCH --mem-per-cpu=2000 ##maximum allowed memory per core
#SBATCH --mail-type=ALL ##what kind of mail notifications  to be sent
#SBATCH --mail-user=youremail@helsinki.fi  #mail to send report status
#SBATCH -p short  ##job type

# commands to manage the batch script
#   submission command
#     sbatch [script-file]
#   status command
#     squeue -u username
#   termination command
#     scancel [jobid]

# For more information
#   http://docs.physics.helsinki.fi/kale.html

srun  $HOME/Kimocs/kimocs .  ##run command for the job

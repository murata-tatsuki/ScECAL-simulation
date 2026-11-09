#!/bin/bash
###############################################################################
# A sample SLURM script to run analyzer on 1 node
#
#  usage:
#        (0) Edit this script
#        (1) Submit the job.
#            % cd $MEG2SYS/analyzer
#            % sbatch -a 0-20%10 example/analyzer_array.sl
#             sbatch -o out/test-%A_%a.out --error="err/test-%A_%a.err" jobThrowing_ml.sl 
#
###############################################################################

#SBATCH --job-name=geant4
#SBATCH --output=log_%A_%a.out
#SBATCH --error="log_%A_%a.err"
#SBATCH --array=1-50

MY_HOST=`hostname`
MY_DATE=`date`
#
# Disable core dump. (Remove this line if you want to create core files)
#
ulimit -c 0

echo "Running on $MY_HOST at $MY_DATE"
echo "================================================================"

#
# Print envirionment
#
#echo "Running environment":
#env | sort
#echo "================================================================"

#
# Replace the start run number and configuration file by yours
#

# particle=e-
# energy=5
# sipm=_10um  # _10um or ""
# z=_z973  # _10um or ""

path="$PWD"
condor_mac="$path/mac"
condor_root="$path/../../Result_MC/generate/ml"

NEVENTS=20000
START=$(( (SLURM_ARRAY_TASK_ID - 1) * NEVENTS + 1 ))
END=$(( SLURM_ARRAY_TASK_ID * NEVENTS ))

srun /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL/build/CEPCScECAL  $condor_mac/ml_e-.mac $condor_root/e-_log-uniform_${SLURM_ARRAY_TASK_ID}.root

# /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL/build/CEPCScECAL /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL/generate/mac/kek_e-_5_10um.mac /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL/generate/../../Result_MC/generate/e-/5GeV/kek_e-_5_10um_z973.root
# /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL/build/CEPCScECAL /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL/generate/mac/ml_e-.mac         /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL/generate/../../Result_MC/generate/ml/e-_log-uniform.root

RET=$?
echo "Exit status: $RET"
echo "================================================================"
END_DATE=`date`
echo "End of run is $END_DATE ($SECONDS sec)"

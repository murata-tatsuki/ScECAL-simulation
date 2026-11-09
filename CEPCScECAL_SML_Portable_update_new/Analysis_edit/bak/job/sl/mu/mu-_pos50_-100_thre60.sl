#!/bin/bash
###############################################################################
# A sample SLURM script to run analyzer on 1 node
#
#  usage:
#        (0) Edit this script
#        (1) Submit the job.
#            % cd $MEG2SYS/analyzer
#            % sbatch -a 0-20%10 example/analyzer_array.sl
#
###############################################################################

#SBATCH --partition=all
#SBATCH --ntasks=1       
#SBATCH --job-name=analyzer
#SBATCH --array=0
#SBATCH --output="analyzer-%A_%a.out"
#SBATCH --error="analyzer-%A_%a.err"

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
/home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/build/MCAnalysis /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC/generate/mu-/100GeV/mu-_100GeV_pos50_-100_event_100000.root /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/share/cosmic_parameters/2020ped.root /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/share/cosmic_parameters/20201216_20210308_InterCalib.root /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/share/cosmic_parameters/20201216_20210308.root /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/share/cosmic_parameters/20210702_160312_LED_Calib.root notreverse /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC/decode/mu-/cosmicThreScan/100GeV/mu-_100GeV_pos50_-100_thre60.root 60
RET=$?
echo "Exit status: $RET"
echo "================================================================"
END_DATE=`date`
echo "End of run is $END_DATE ($SECONDS sec)"

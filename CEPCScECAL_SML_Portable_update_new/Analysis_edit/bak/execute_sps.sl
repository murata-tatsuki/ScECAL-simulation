#!/bin/bash
###############################################################################
# A sample SLURM script to run analyzer on 1 node
#
#  usage:
#        (0) Edit this script
#        (1) Submit the job.
#            % cd $MEG2SYS/analyzer
#            % sbatch -o job/out/test-%A_%a.out --error="job/err/test-%A_%a.err" execute_ml_digitization.sl 
#            % sbatch -o test-%A_%a.out --error="test-%A_%a.err" execute_sps.sl 
#
###############################################################################

#SBATCH --partition=all
#SBATCH --ntasks=1       
#SBATCH --job-name=test
#SBATCH --array=0
#SBATCH --output="test-%A_%a.out"
#SBATCH --error="test-%A_%a.err"

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
#/bin/bash

workDir=${PWD}
echo "========== Work Dir : ${workDir}"
particleTag=e-
energyTag=20GeV
angle=0.01
# fileName=e-_log-uniform.root
# fileName=e-_log-uniform_merged.root
#fileName=muon_100GeV_1000000.root

#resultDir="/home/wangjx/HEP/CEPC2023/Result_MC"
resultDir="/home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC"
truthDir="${resultDir}/truth/${particleTag}/sps_beam/${energyTag}/angle${angle}"
digiDir="${resultDir}/decode/${particleTag}/sps_beam/${energyTag}/angle${angle}"

if [ ! -d "$truthDir" ]; then
	mkdir -p "$truthDir"
fi
if [ ! -d "$digiDir" ]; then
	mkdir -p "$digiDir"
fi

# energyAnaTruthDir="${workDir}/../Result/energy_analysis_truth"
# energyAnaDigiDir="${workDir}/../Result/energy_analysis_digi"
# energyAnaTruthHistDir="${workDir}/../Result/energy_analysis_truth_hist"
# energyAnaDigiHistDir="${workDir}/../Result/energy_analysis_digi_hist"
# hitDigiDir="${workDir}/../Result/hit_digi"

shareDir="${workDir}/share"
pedFile="${shareDir}/pedestal2023_SPS.root"
HLRatioFile="${shareDir}/all_hl_electron2023_hlratio_v3.root"
MIPFile="${shareDir}/all_auto_muon_v4_trackfit.root"
#MIPFile="${shareDir}/all_auto_muon_v4.root"
SiPMGainFile="${shareDir}/20230504_1425_Calib_LED_all.root"

echo "... ..."

for fileName in `ls ${resultDir}/generate/${particleTag}/sps_beam/${energyTag}/angle${angle}`; do

  echo ${fileName}
  cp ${resultDir}/generate/${particleTag}/sps_beam/${energyTag}/angle${angle}/${fileName} ${truthDir}

  # # ${workDir}/build/MCAnalysis ${mergeDir}/${fileName} ${truthDir}/${fileName} ${energyAnaTruthDir}/${fileName} ${energyAnaTruthHistDir}/${fileName} ${digiDir}/${fileName} ${energyAnaDigiDir}/${fileName} ${energyAnaDigiHistDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile}
  ${workDir}/build/MCAnalysis ${truthDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile} ${digiDir}/${fileName}

  echo "... ... ... ..."
  echo "Simulation Hit Digi : ADC Hit Tree"
  echo "===  Simulation Digi   ===> ${digiDir}/${fileName}"
  #echo "=== EnergyAna Digi  ===> ${energyAnaDigiDir}/${fileName}"
  #echo "=== EnergyAna Digi Hist  ===> ${energyAnaDigiHistDir}/${fileName}"

done

#cd /home/wangjx/HEP/CEPC2023/SiWECAL_analysis_2023_update/run
#source calib.sh
#cd /home/wangjx/HEP/CEPCScECAL_SML_Portable_update/Analysis



	## MC truth check
# vector<double> *Hit_Energy=nullptr;
# MC_Truth->SetBranchAddress("Hit_Energy",&Hit_Energy);
# TH1F *Ehisto = new TH1F("Ehisto","Ehisto",10000,0,10000);
# 
# for(int ientry=0;ientry<MC_Truth->GetEntries();ientry++){
#   MC_Truth->GetEntry(ientry);
#   double energy=0;
#   for(int cell=0;cell<Hit_Energy->size();cell++){
#     energy += Hit_Energy->at(cell);
#   }
#   Ehisto->Fill(energy);
# }
# Ehisto->Draw();
#

	## decode check


# /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/build/MCAnalysis /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC/truth/e-/100GeV/100000.root /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/share/pedestal2023_SPS.root /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/share/all_hl_electron2023_hlratio_v3.root /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/share/all_auto_muon_v4_trackfit.root /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Analysis_edit/share/20230504_1425_Calib_LED_all.root notreverse /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC/decode/e-/threScan/100GeV/e-_100GeV_100000_thre_100.root 100


RET=$?
echo "Exit status: $RET"
echo "================================================================"
END_DATE=`date`
echo "End of run is $END_DATE ($SECONDS sec)"

#/bin/bash

workDir=${PWD}
echo "========== Work Dir : ${workDir}"
particleTag=mu-
energyTag=100GeV
fileName=100000.root
#fileName=muon_100GeV_1000000.root

#resultDir="/home/wangjx/HEP/CEPC2023/Result_MC"
resultDir="/home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC"
truthDir="${resultDir}/truth/${particleTag}/${energyTag}"
# digiDir="${resultDir}/decode/${particleTag}_new_edit/${energyTag}"
# digiDir="${resultDir}/decode/${particleTag}/threScan/${energyTag}"
digiDir="${resultDir}/decode/${particleTag}/cosmicThreScan/${energyTag}"
if [ ! -d "$truthDir" ]; then
	mkdir -p "$truthDir"
fi
if [ ! -d "$digiDir" ]; then
	mkdir -p "$digiDir"
fi

cp ${resultDir}/generate/${particleTag}/${energyTag}/${fileName} ${truthDir}

# energyAnaTruthDir="${workDir}/../Result/energy_analysis_truth"
# energyAnaDigiDir="${workDir}/../Result/energy_analysis_digi"
# energyAnaTruthHistDir="${workDir}/../Result/energy_analysis_truth_hist"
# energyAnaDigiHistDir="${workDir}/../Result/energy_analysis_digi_hist"
# hitDigiDir="${workDir}/../Result/hit_digi"

## given parameters
shareDir="${workDir}/share"
pedFile="${shareDir}/pedestal2023_SPS.root"
HLRatioFile="${shareDir}/all_hl_electron2023_hlratio_v3.root"
MIPFile="${shareDir}/all_auto_muon_v4_trackfit.root"
#MIPFile="${shareDir}/all_auto_muon_v4.root"
SiPMGainFile="${shareDir}/20230504_1425_Calib_LED_all.root"
# ThresholdFile="${shareDir}/threshold_rev.root"
ThresholdFile="notreverse"

## cosmic ray parameters
shareDir="${workDir}/share/cosmic_parameters"
pedFile="${shareDir}/2020ped.root"
HLRatioFile="${shareDir}/20201216_20210308_InterCalib.root"
MIPFile="${shareDir}/20201216_20210308.root"
SiPMGainFile="${shareDir}/20210702_160312_LED_Calib.root"

echo "... ..."

# ${workDir}/build/MCAnalysis ${mergeDir}/${fileName} ${truthDir}/${fileName} ${energyAnaTruthDir}/${fileName} ${energyAnaTruthHistDir}/${fileName} ${digiDir}/${fileName} ${energyAnaDigiDir}/${fileName} ${energyAnaDigiHistDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile}
# ${workDir}/build/MCAnalysis  ${truthDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile} ${digiDir}/${fileName}

# for i in `seq 0 10`; do
for i in `seq 0 0`; do
  # a=$((i*5))
  a=$((i*10))
  # a=$((i))
  # a=50

  # outfileName=${particleTag}_${energyTag}_100000_thre_rev_${a}.root    # thre - ${a}
	outfileName=${particleTag}_${energyTag}_100000_thre_${a}.root        # pedestal + ${a}
	# outfileName=muon_100GeV_1000000_thre_adjust.root

  # ${workDir}/build/MCAnalysis ${mergeDir}/${fileName} ${truthDir}/${fileName} ${energyAnaTruthDir}/${fileName} ${energyAnaTruthHistDir}/${fileName} ${digiDir}/${fileName} ${energyAnaDigiDir}/${fileName} ${energyAnaDigiHistDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile}
  ${workDir}/build/MCAnalysis  ${truthDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile} ${ThresholdFile} ${digiDir}/${outfileName} ${a}

  echo "... ... ... ..."
  echo "Simulation Hit Digi : ADC Hit Tree"
  echo "===  Simulation Digi   ===> ${digiDir}/${outfileName}"
done


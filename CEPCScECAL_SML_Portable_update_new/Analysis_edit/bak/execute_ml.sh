#/bin/bash

workDir=${PWD}
echo "========== Work Dir : ${workDir}"
particleTag=ml
# energyTag=250GeV
fileName=e-_log-uniform.root
#fileName=muon_100GeV_1000000.root

#resultDir="/home/wangjx/HEP/CEPC2023/Result_MC"
resultDir="/home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC"
truthDir="${resultDir}/truth/${particleTag}"
digiDir="${resultDir}/decode/${particleTag}_new_edit"
if [ ! -d "$truthDir" ]; then
	mkdir -p "$truthDir"
fi
if [ ! -d "$digiDir" ]; then
	mkdir -p "$digiDir"
fi

cp ${resultDir}/generate/${particleTag}/${fileName} ${truthDir}

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

# ${workDir}/build/MCAnalysis ${mergeDir}/${fileName} ${truthDir}/${fileName} ${energyAnaTruthDir}/${fileName} ${energyAnaTruthHistDir}/${fileName} ${digiDir}/${fileName} ${energyAnaDigiDir}/${fileName} ${energyAnaDigiHistDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile}
${workDir}/build/MCAnalysis ${truthDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile} ${digiDir}/${fileName} 0

echo "... ... ... ..."
echo "Simulation Hit Digi : ADC Hit Tree"
echo "===  Simulation Digi   ===> ${digiDir}/${fileName}"
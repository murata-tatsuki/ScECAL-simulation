#/bin/bash

workDir=${PWD}
echo "========== Work Dir : ${workDir}"
particleTag=e-
energyTag=250GeV
fileName=100000.root
#fileName=muon_100GeV_1000000.root

#resultDir="/home/wangjx/HEP/CEPC2023/Result_MC"
resultDir="/home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC"
truthDir="${resultDir}/truth/${particleTag}/${energyTag}"
digiDir="${resultDir}/decode/${particleTag}_new_edit/${energyTag}"
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

shareDir="${workDir}/share"
pedFile="${shareDir}/pedestal2023_SPS.root"
HLRatioFile="${shareDir}/all_hl_electron2023_hlratio_v3.root"
MIPFile="${shareDir}/all_auto_muon_v4_trackfit.root"
#MIPFile="${shareDir}/all_auto_muon_v4.root"
SiPMGainFile="${shareDir}/20230504_1425_Calib_LED_all.root"

echo "... ..."

# ${workDir}/build/MCAnalysis ${mergeDir}/${fileName} ${truthDir}/${fileName} ${energyAnaTruthDir}/${fileName} ${energyAnaTruthHistDir}/${fileName} ${digiDir}/${fileName} ${energyAnaDigiDir}/${fileName} ${energyAnaDigiHistDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile}
${workDir}/build/MCAnalysis  ${truthDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile} ${digiDir}/${fileName}

echo "... ... ... ..."
echo "Simulation Hit Digi : ADC Hit Tree"
echo "===  Simulation Digi   ===> ${digiDir}/${fileName}"
#echo "=== EnergyAna Digi  ===> ${energyAnaDigiDir}/${fileName}"
#echo "=== EnergyAna Digi Hist  ===> ${energyAnaDigiHistDir}/${fileName}"

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

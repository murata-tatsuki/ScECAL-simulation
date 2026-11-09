#/bin/bash

workDir=${PWD}
echo "========== Work Dir : ${workDir}"
particleTag=mu-
# energyTag=GeV
fileName=100000.root
#fileName=muon_100GeV_1000000.root

#resultDir="/home/wangjx/HEP/CEPC2023/Result_MC"
resultDir="/home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC"
# truthDir="${resultDir}/truth/${particleTag}/${energyTag}"
# # digiDir="${resultDir}/decode/${particleTag}_new_edit/${energyTag}"
# digiDir="${resultDir}/decode/${particleTag}/threScan/${energyTag}"
# if [ ! -d "$truthDir" ]; then
# 	mkdir -p "$truthDir"
# fi
# if [ ! -d "$digiDir" ]; then
# 	mkdir -p "$digiDir"
# fi

# cp ${resultDir}/generate/${particleTag}/${energyTag}/${fileName} ${truthDir}

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
for energy in $( ls ${resultDir}/generate/${particleTag} ); do   
  echo ${energy}
  energyTag=${energy}


  truthDir="${resultDir}/truth/${particleTag}/${energyTag}"
  # digiDir="${resultDir}/decode/${particleTag}_new_edit/${energyTag}"
  digiDir="${resultDir}/decode/${particleTag}/cosmicThreScan/${energyTag}"
  if [ ! -d "$truthDir" ]; then
  	mkdir -p "$truthDir"
  fi
  if [ ! -d "$digiDir" ]; then
  	mkdir -p "$digiDir"
  fi

  # cp ${resultDir}/generate/${particleTag}/${energyTag}/${fileName} ${truthDir}



  # for i in `seq 0 10`; do
  for i in `seq 0 10`; do
    for x in `seq 0 4`; do
      for y in `seq 0 4`; do
        # a=$((i*5))
        a=$((i*10))
        posx=$(((x-2)*50))
        posy=$(((y-2)*50))
        
        fileName=${particleTag}_${energyTag}_pos${posx}_${posy}_event_100000.root
        outfileName=${particleTag}_${energyTag}_pos${posx}_${posy}_thre${a}.root
        
        cp job/example_mu_cosmic_generate.sl job/sl/mu/${particleTag}_pos${posx}_${posy}_thre${a}.sl
    
        # outfileName=${particleTag}_${energyTag}_100000_thre_rev_${a}.root    # thre - ${a}
      	# outfileName=${particleTag}_${energyTag}_100000_thre_${a}.root        # pedestal + ${a}
      	# outfileName=muon_100GeV_1000000_thre_adjust.root
    
        # ${workDir}/build/MCAnalysis ${mergeDir}/${fileName} ${truthDir}/${fileName} ${energyAnaTruthDir}/${fileName} ${energyAnaTruthHistDir}/${fileName} ${digiDir}/${fileName} ${energyAnaDigiDir}/${fileName} ${energyAnaDigiHistDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile}
        # command="${workDir}/build/MCAnalysis\ ${truthDir}/${fileName}\ ${pedFile}\ ${HLRatioFile}\ ${MIPFile}\ ${SiPMGainFile}\ ${ThresholdFile}\ ${digiDir}/${outfileName}\ ${a}"
        # command="${workDir}/build/MCAnalysis ${truthDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile} ${ThresholdFile} ${digiDir}/${outfileName} ${a}"
        # echo ${command}
    
        # sed -i -e "s/runcode/${command}/g" job/${particleTag}_${energyTag}_${a}.sl
        sed -i -e "s/generateroot/${fileName}/g" job/sl/mu/${particleTag}_pos${posx}_${posy}_thre${a}.sl
        sed -i -e "s/outputroot/${outfileName}/g" job/sl/mu/${particleTag}_pos${posx}_${posy}_thre${a}.sl
        sed -i -e "s/particleTag/${particleTag}/g" job/sl/mu/${particleTag}_pos${posx}_${posy}_thre${a}.sl
        sed -i -e "s/energy/${energyTag}/g" job/sl/mu/${particleTag}_pos${posx}_${posy}_thre${a}.sl
        sed -i -e "s/value/${a}/g" job/sl/mu/${particleTag}_pos${posx}_${posy}_thre${a}.sl
    
        sbatch -o job/out/test-%A_%a.out --error="job/error/test-%A_%a.err" job/sl/mu/${particleTag}_pos${posx}_${posy}_thre${a}.sl
    
    
        # echo "... ... ... ..."
        # echo "Simulation Hit Digi : ADC Hit Tree"
        # echo "===  Simulation Digi   ===> ${digiDir}/${outfileName}"
      done
    done
  done
done

# echo "... ... ... ..."
# echo "Simulation Hit Digi : ADC Hit Tree"
# echo "===  Simulation Digi   ===> ${digiDir}/${fileName}"
#echo "=== EnergyAna Digi  ===> ${energyAnaDigiDir}/${fileName}"
#echo "=== EnergyAna Digi Hist  ===> ${energyAnaDigiHistDir}/${fileName}"

#cd /home/wangjx/HEP/CEPC2023/SiWECAL_analysis_2023_update/run
#source calib.sh
#cd /home/wangjx/HEP/CEPCScECAL_SML_Portable_update/Analysis





	## MC truth check
# vector<double> *Hit_Energy=nullptr;
# MC_Truth->SetBranchAddress("Hit_Energy",&Hit_Energy);
# TH1F *Ehisto = new TH1F("Ehisto","Ehisto",10000,0,10000);
# TH2F *E_nhit = new TH2F("E_nhit",";MeV;numer of hit",200,0,200, 200,0,200);
# for(int ientry=0;ientry<MC_Truth->GetEntries();ientry++){
#   MC_Truth->GetEntry(ientry);
#   double energy=0;
#   for(int cell=0;cell<Hit_Energy->size();cell++){
#     energy += Hit_Energy->at(cell);
#   }
#   Ehisto->Fill(energy);
#   E_nhit->Fill(energy,Hit_Energy->size());
# }
# Ehisto->Draw();
# E_nhit->Draw("colz");


# vector<double> *Hit_Energy=nullptr;
# Calib_Hit->SetBranchAddress("Hit_Energy",&Hit_Energy);
# TH1F *Ehisto = new TH1F("Ehisto","Ehisto",10000,0,10000);
# TH2F *E_nhit = new TH2F("E_nhit",";MeV;numer of hit",2000,0,2000, 2000,0,2000);
# for(int ientry=0;ientry<Calib_Hit->GetEntries();ientry++){
#   Calib_Hit->GetEntry(ientry);
#   double energy=0;
#   for(int cell=0;cell<Hit_Energy->size();cell++){
#     energy += Hit_Energy->at(cell);
#   }
#   Ehisto->Fill(energy);
#   E_nhit->Fill(energy,Hit_Energy->size());
# }
# Ehisto->Draw();
# E_nhit->Draw("colz");


	## decode check



# data 
# double TotalEnergyDep=0;
# vector<int> *CellID=nullptr;
# Calib_Hit->SetBranchAddress("TotalEnergyDep",&TotalEnergyDep);
# Calib_Hit->SetBranchAddress("CellID",&CellID);
# TH1F *Ehisto = new TH1F("Ehisto","Ehisto",10000,0,10000);
# TH2F *E_nhit = new TH2F("E_nhit",";MeV;numer of hit",200,0,200, 200,0,200);
# for(int ientry=0;ientry<Calib_Hit->GetEntries();ientry++){
#   Calib_Hit->GetEntry(ientry);
#   Ehisto->Fill(TotalEnergyDep);
#   E_nhit->Fill(TotalEnergyDep,CellID->size());
# }
# Ehisto->Draw();
# E_nhit->Draw("colz");

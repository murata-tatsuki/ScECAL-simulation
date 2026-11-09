#/bin/bash

workDir=${PWD}
echo "========== Work Dir : ${workDir}"
particleTag=e-
# energyTag=GeV

#resultDir="/home/wangjx/HEP/CEPC2023/Result_MC"
resultDir="/home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/Result_MC"
# truthDir="${resultDir}/truth/${particleTag}/${energyTag}"
# # digiDir="${resultDir}/decode/${particleTag}_new_edit/${energyTag}"
# digiDir="${resultDir}/decode/${particleTag}/threScan/${energyTag}"

shareDir="${workDir}/share"
pedFile="${shareDir}/pedestal2023_SPS.root"
HLRatioFile="${shareDir}/all_hl_electron2023_hlratio_v3.root"
MIPFile="${shareDir}/all_auto_muon_v4_trackfit.root"
#MIPFile="${shareDir}/all_auto_muon_v4.root"
SiPMGainFile="${shareDir}/20230504_1425_Calib_LED_all.root"
# ThresholdFile="${shareDir}/threshold_rev.root"
ThresholdFile="notreverse"

## cosmic ray parameters
# shareDir="${workDir}/share/cosmic_parameters"
# pedFile="${shareDir}/2020ped.root"
# HLRatioFile="${shareDir}/20201216_20210308_InterCalib.root"
# MIPFile="${shareDir}/20201216_20210308.root"
# SiPMGainFile="${shareDir}/20210702_160312_LED_Calib.root"

echo "... ..."

# ${workDir}/build/MCAnalysis ${mergeDir}/${fileName} ${truthDir}/${fileName} ${energyAnaTruthDir}/${fileName} ${energyAnaTruthHistDir}/${fileName} ${digiDir}/${fileName} ${energyAnaDigiDir}/${fileName} ${energyAnaDigiHistDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile}
# ${workDir}/build/MCAnalysis  ${truthDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile} ${digiDir}/${fileName}

# for i in `seq 0 10`; do
for energy in $( ls ${resultDir}/generate/${particleTag} ); do   
  echo ${energy}
  energyTag=${energy}


  truthDir="${resultDir}/truth/${particleTag}/sps/${energyTag}"
  digiDir="${resultDir}/decode/${particleTag}/sps/${energyTag}"
	mkdir -p "$truthDir"
	mkdir -p "$digiDir"

  jobOut=job/scan/${particleTag}/sps/${energyTag}/out
  jobErr=job/scan/${particleTag}/sps/${energyTag}/err
  rm -r ${jobOut}
  rm -r ${jobErr}
  mkdir -p ${jobOut}
  mkdir -p ${jobErr}

  for fileName in `ls ${resultDir}/generate/${particleTag}/sps/${energyTag}`; do

    echo ${fileName}
    # cp ${resultDir}/generate/${particleTag}/sps/${energyTag}/${fileName} ${truthDir}

    for i in `seq 0 10`; do
      a=$((i*10))
      mkdir -p job/sl/scan/${particleTag}/sps/${energyTag}
      mkdir -p ${digiDir}/threshold${a}
      outsl=job/sl/scan/${particleTag}/sps/${energyTag}/${fileName}_thre${a}.sl
      cp job/sl/example.sl ${outsl}

    	outfileName=${fileName}
    	# outfileName=${particleTag}_${energyTag}_100000_thre_${a}.root        # pedestal + ${a}

      # ${workDir}/build/MCAnalysis ${truthDir}/${fileName} ${pedFile} ${HLRatioFile} ${MIPFile} ${SiPMGainFile} ${digiDir}/${fileName}
      Arg0=${workDir}/build/MCAnalysis
      Arg1=${truthDir}/${fileName}
      Arg6=${a}
      Arg8=${a}
      Arg7=${digiDir}/threshold${a}/${fileName}

      if [[ -e ${Arg7} ]]
      then
        echo "${Arg7} has been decoded, skip ..."
        continue
      fi

      sed -i -e "s|arg0|${Arg0}|g" ${outsl}
      sed -i -e "s|arg1|${Arg1}|g" ${outsl}
      sed -i -e "s|arg2|${pedFile}|g" ${outsl}
      sed -i -e "s|arg3|${HLRatioFile}|g" ${outsl}
      sed -i -e "s|arg4|${MIPFile}|g" ${outsl}
      sed -i -e "s|arg5|${SiPMGainFile}|g" ${outsl}
      sed -i -e "s|arg6|${Arg6}|g" ${outsl}
      sed -i -e "s|arg7|${Arg7}|g" ${outsl}
      sed -i -e "s|arg8|${Arg8}|g" ${outsl}

      sbatch -o ${jobOut}/${fileName}-%A.out --error="${jobErr}/${fileName}-%A.err" ${outsl}

      
    done
  done
  sleep 3
done

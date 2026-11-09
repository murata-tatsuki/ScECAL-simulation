#!/bin/sh
path="$PWD"
cd $path

particle=e-
energy=250
condor_out="$path/out"
condor_err="$path/err"
condor_log="$path/log"
condor_cmd="$path/cmd"
condor_sh="$path/run"
condor_mac="$path/mac"
condor_root="$path/../../Result_MC/generate/${particle}/${energy}GeV"

# rm -rf $condor_out $condor_err $condor_log $condor_cmd $condor_sh $condor_mac $condor_root
mkdir -p $condor_out $condor_err $condor_log $condor_cmd $condor_sh $condor_mac $condor_root
mkdir -p ${condor_mac}/${particle}/${energy}GeV


# posX=$((-0.1846+50))
# posY=$((0.7962+50))
i=0
# posX=$((-50*i))
# posY=$((-50+j))

while [ ${i} -ne 100 ]
do
		echo ${i}
		posX=0
		posY=0


	result=1000
#--------Create mac file------------------------------
	echo "Create ${n} mac file"
	echo \
	"
	/control/verbose 0
	/run/verbose 0
	/event/verbose 0
	
	/mydet/generator fGParticleSource
	/gps/particle ${particle}
	/gps/energy ${energy} GeV
		#/gps/source/clear
		#/gps/source/add 1
	/gps/direction 0 0 1
		
	# 设置高斯分布
	/gps/pos/type Beam
	/gps/pos/shape Ellipse
	#/gps/pos/centre -0.193  0.9235  -60. cm
	#/gps/pos/centre 0 0 -60. cm
	#/gps/pos/sigma_r 8. cm
	#/gps/pos/sigma_x 1.135 cm
	#/gps/pos/sigma_y 0.9448 cm
	#/gps/pos/centre -0.1846  0.7962  -60. cm
	#/gps/pos/centre ${posX}  ${posY}  -60. cm
	/gps/pos/centre ${posX}  ${posY}  -60 mm
	/gps/pos/sigma_x 1.2954 cm
	/gps/pos/sigma_y 0.9838 cm

	/run/beamOn 1000

	" > $condor_mac/${particle}/${energy}GeV/${particle}_${energy}GeV_${i}.mac
	
#--------Create .sh file end------------------------------
	# echo \
	# "#!/bin/sh
	
	# source /cvmfs/sft.cern.ch/lcg/views/LCG_104/x86_64-centos7-gcc11-opt/setup.sh
	# /home/murata_t/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL/build/CEPCScECAL  $condor_mac/kek_${particle}_${energy}.mac $condor_root/kek_${particle}_${energy}.root
	
	# " > $condor_sh/${result}.sh
	# chmod +x $condor_sh/${result}.sh	
	# hep_sub -os CentOS7  $condor_sh/${result}.sh -g higgs -o $condor_out -e $condor_err
	# let "n+=1"

	let i++
done
# hadd merge_root electron_10000_40GeV.root  (from) generate_root 

#--------Creat cmd file------------------------------
#	if test -s $condor_cmd/${result}.cmd; 
#	then
#		echo "CMD File is not Empty"
#		rm  $condor_cmd/${result}.cmd
#	fi
#	cat >> $condor_cmd/${result}.cmd << EOF
#	  Universe             = vanilla
#	  Notification         = Never
#	  GetEnv               = True
#	  Executable           = $condor_sh/${result}.sh
#	  Output               = $condor_out/${result}.out
#	  Error                = $condor_err/${result}.err
#	  Log                  = $condor_log/${result}.log
#	  Queue								 
#EOF
#	
#	chmod +x $condor_sh/${result}.sh
#	chmod +x $condor_cmd/${result}.cmd 
#	
#	echo "condor_submit $condor_cmd/${result}.cmd"
#	condor_submit $condor_cmd/${result}.cmd 
#	
#	let "n+=1"
#done

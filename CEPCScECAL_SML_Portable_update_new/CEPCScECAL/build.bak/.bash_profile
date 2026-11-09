#alias juno='cd /afs/ihep.ac.cn/soft/juno/JUNO-ALL-SLC6/Release/J15v1r1/ExternalLibs/Build'


#source /afs/ihep.ac.cn/soft/juno/JUNO-ALL-SLC6/Release/J15v1r2/ExternalLibs/Geant4/9.4.p04/share/geant4-9.4.4/config/geant4-9.4.4.sh
#source /afs/ihep.ac.cn/soft/juno/JUNO-ALL-SLC6/Release/J15v1r1/setup.sh

#export G4WORKDIR=/afs/ihep.ac.cn/users/z/zhaoh/geant4
#export PATH=${PATH}:${CLHEP_BASE_DIR}/bin:${G4WORKDIR}/bin/Linux-g++:${ROOTSYS}/bin
#if [ "$HOSTNAME" = "lxslc706.ihep.ac.cn" ];then
#    export SHELL=/bin/tcsh
#    exec /bin/tcsh -l
#else
#    export CEPCworkspace=/cefs/higgs/wangjx/
#    export yazhou_dir=/cefs/higgs/niuyz/ECALPrototype/MultiLayer/CosmicRay_CycleID
    #export BAK_CEPCworkspace=/scratchfs/higgs/zhaoh

#export GARFIELD_HOME=/afs/ihep.ac.cn/users/z/zhaoh/garfield++
#export HEED_DATABASE=$GARFIELD_HOME/Heed/heed++/database

export PATH=/afs/ihep.ac.cn/users/w/wjx1019/.local/bin:/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin:$PATH
export LD_LIBRARY_PATH=/user/lib64:$LD_LIBRARY_PATH
#source /cvmfs/sft.cern.ch/lcg/views/LCG_97rc4python3/x86_64-centos7-gcc9-opt/setup.sh

#source /afs/ihep.ac.cn/users/s/shiyk/CEPC_Setup.sh
###source /cvmfs/geant4.cern.ch/geant4/11.1/x86_64-centos8-gcc11-optdeb-MT/CMake-setup.sh
source /cvmfs/sft.cern.ch/lcg/views/LCG_104/x86_64-centos7-gcc11-opt/setup.sh
#alias hq='hep_q -u'

cd /cefs/higgs/wangjx/
#export DISPLAY=10.188.57.50:0.0;
#cd /scratchfs/cepc/shiyk
#fi


export tbrun=/cefs/higgs/wangjx/ScECAL/Diagnose
export tbresult=/cefs/higgs/wangjx/ScECAL/Result_Diagnose

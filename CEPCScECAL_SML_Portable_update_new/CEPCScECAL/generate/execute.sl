#!/bin/bash
# LSF worker wrapper used by generator_e.sh and generator_sps_e.sh.
# Usage: bsub -q s bash execute.sl <executable> <macro> <output.root>

project_dir="${CEPCSC_ECAL_DIR:-/gpfs/group/ilc/users/murata/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL}"
source "$project_dir/setup.sh" || exit $?
path="$project_dir/generate"
cd "$path" || exit 1

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
# Replace configuration file by yours
#
#./meganalyzer -i example/bartenderMode.xml -r 1 -b

"$@"


RET=$?
echo "Exit status: $RET"
echo "================================================================"
END_DATE=`date`
echo "End of run is $END_DATE"
exit "$RET"

#!/bin/bash
# LSF worker wrapper for digitization.
# Usage: bsub -q s bash execute.sl <executable> <arguments...>

workDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$workDir/../CEPCScECAL/setup.sh" || exit 1
cd "$workDir" || exit 1

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

"$@"

RET=$?
echo "Exit status: $RET"
echo "================================================================"
END_DATE=`date`
echo "End of run is $END_DATE ($SECONDS sec)"

# Propagate digitization failures to LSF.
exit "$RET"

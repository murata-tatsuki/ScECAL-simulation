#!/bin/bash
# KEKCC LSF のアレイジョブとして実行

project_dir="${CEPCSC_ECAL_DIR:-/gpfs/group/ilc/users/murata/data_beamtest/simulation/CEPCScECAL_SML_Portable_update_new/CEPCScECAL}"
source "$project_dir/setup.sh" || exit $?
path="$project_dir/generate"
cd "$path" || exit 1

TXT_FILE=$1
PARTICLE=$2
ENERGY=$3
PREFIX=$4
CONDOR_ROOT=$5
MAC_DIR=$6

# Gaussian momentum spread: sigma_p / p0 (PS: 0.3%, SPS: 2%).
SPREAD=${7:-${MOMENTUM_SPREAD:-}}
if [ -z "$SPREAD" ]; then
    SPREAD=$(awk -v e="$ENERGY" 'BEGIN { print (e <= 5) ? 0.003 : 0.02 }')
fi

# LSF のアレイ番号 (1〜100) をファイル番号 (0〜99) に変換
i=$(( ${LSB_JOBINDEX:-1} - 1 ))

# 元コードと同じマクロファイル・ROOTファイルの出力先パス
MAC_FILE="${MAC_DIR}/${PREFIX}_${i}.mac"
OUT_ROOT="${CONDOR_ROOT}/${PREFIX}_${i}.root"

# 全100ジョブが同じ乱数系列（同じ計算）になるのを防ぐシード値
SEED1=$((12345 + i))
SEED2=$((67890 + i))

# マクロファイルを生成
cat << EOF > "${MAC_FILE}"
/control/verbose 0
/run/verbose 0
/event/verbose 0

/random/setSeeds ${SEED1} ${SEED2}

/mydet/generator fGParticleSource
/gps/particle ${PARTICLE}
/gps/energy ${ENERGY} GeV
/mydet/momentumSpread ${SPREAD}
/gps/direction 0 0 1

/mydet/hitmapFile ${TXT_FILE}

/run/beamOn 1000
EOF

# 元コードと全く同じコマンドを実行
"${project_dir}/build/CEPCScECAL" "${MAC_FILE}" "${OUT_ROOT}"
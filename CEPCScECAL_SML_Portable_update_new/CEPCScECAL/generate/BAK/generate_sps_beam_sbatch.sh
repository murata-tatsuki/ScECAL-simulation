#!/bin/sh
path="$PWD"
cd $path


# energies=(20 30 40 50 60 70 80 90 100 120 150 200 250)
energies=(20)

angle=0.01


for energy in "${energies[@]}"
do
  echo ${energy}
  i=0
  # posX=$((-50*i))
  # posY=$((-50+j))
  
  while [ ${i} -ne 470 ]
  do
    sbatch -o out/test-%A_%a.out --error="err/test-%A_%a.err" jobThrowing_sps_beam.sl ${energy} ${i} ${angle}
    # sbatch -o out/test-%A_%a.out --error="err/test-%A_%a.err" jobThrowing_sps.sl ${energy} ${i}
    let i++
  done
done

#!/bin/bash

for i in {1,2,5,10,20,30,40,50,60,70,80,90,100,120}
#for i in {1,2,5,10,20}
#for i in {10,20,30,40,50,60,70,80,100}
do
	sed -i "23c const int EventEnergy = ${i}; // GeV " energyProfile.cxx
	sed -i "23s/^/\t/" energyProfile.cxx
	root -q -l energyProfile.cxx
	
	sed -i "23c const int EventEnergy = ${i}; // GeV " energyFit.cxx
	sed -i "23s/^/\t/" energyFit.cxx
	root -q -l energyFit.cxx
	echo "-------------- ${i}GeV finished -----------" 
done

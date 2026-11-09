#include<stdio.h>
#include<iostream>
#include<vector>
#include<string>
#include"TFile.h"
#include"TTree.h"
#include"TCanvas.h"
#include"TLegend.h"
#include"TH1.h"
#include"TGraph.h"
#include<cmath>
#include"TAxis.h"
//#include"TH2.h"

using namespace std;

void plot()
{  
    const int LayerNo = 30;
    char EventParticle[100] ="electron";
    cout << EventParticle << endl;
    const int EventNo = 5000;
    const int EventEnergy = 20; //GeV
    char filename[100];
   // sprintf(filename,"%s_%d_%dGeV.root",EventParticle,EventNo,EventEnergy);
    sprintf(filename,"../root/electron_1.root");
    cout << filename << endl;

    TFile *simufile;
    TTree *simutree;
 //   TProfile *tp1 = new TProfile;
    TGraph *grScint;

    Double_t _PrimaryEnergy;
    vector<int>*	_ScintID;
    vector<int>*	_AbsorberID;
    vector<int>*	_PCBID;
    vector<double>*	_ScintEnDep;
    vector<double>*	_AbsorberEnDep;
    vector<double>*	_PCBEnDep;
    
    int WhichLayer;

    simufile = TFile::Open(filename);
    if(!simufile) cout << "Open file failed!"<< endl;
    simutree = (TTree*)simufile->Get("T");
    _PrimaryEnergy=0;	simutree->SetBranchAddress("PrimaryEnergy",&_PrimaryEnergy);
    _ScintID=0; 	simutree->SetBranchAddress("CrystalID",&_ScintID);
    _AbsorberID=0;	simutree->SetBranchAddress("AbsorberID",&_AbsorberID);
    _PCBID=0;		simutree->SetBranchAddress("PCBID",&_PCBID);
    _ScintEnDep=0;	simutree->SetBranchAddress("EnergyDep",&_ScintEnDep);
    _AbsorberEnDep=0;	simutree->SetBranchAddress("AbsorberEnDep",&_AbsorberEnDep);
    _PCBEnDep=0;	simutree->SetBranchAddress("PCBEnDep",&_PCBEnDep);
    int TreeEntryNo = simutree->GetEntries();
    //for(int i_entry=0; i_entry<TreeEntryNo; i_entry++)
    for(int i_entry=0; i_entry<TreeEntryNo; i_entry++)
    {
        double EnergyLayerDep[30]={0};
	grScint = new TGraph; 
        simutree->GetEntry(i_entry);
//	cout << _ScintID->size()<< endl;
	for(int i_vector=0; i_vector<_ScintID->size(); i_vector++)
	{
	    WhichLayer = floor(_ScintID->at(i_vector)/210.0);
	    if(WhichLayer==1) cout<< i_vector<< " "<< WhichLayer <<" "<<_ScintEnDep->at(i_vector)<<endl;
            EnergyLayerDep[WhichLayer] += _ScintEnDep->at(i_vector);
	}

        for(int i_layer=0; i_layer<LayerNo; i_layer++)
	{
	    grScint->SetPoint(i_layer,i_layer,EnergyLayerDep[i_layer]);
	}
	grScint->SetFillColor(40);
	grScint->GetXaxis()->SetRangeUser(-.5,29.5);
	grScint->GetYaxis()->SetRangeUser(0,100);
	grScint->SetTitle("Each Layer EnergyDep");

	TCanvas *c1 = new TCanvas("c1","Each Layer EnergyDep",800,600);
	c1->cd();
	c1->SetGrid();
	grScint->GetXaxis()->SetTitle("LayerNo");
	grScint->GetYaxis()->SetTitle("EnergyDep/MeV");
	grScint->Draw("AB");
	

    }


}

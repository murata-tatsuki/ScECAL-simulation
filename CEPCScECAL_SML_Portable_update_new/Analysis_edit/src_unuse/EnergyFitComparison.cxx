#include<stdio.h>
#include<iostream>
#include<vector>
#include<string>
#include"TFile.h"
#include"TTree.h"
#include"TCanvas.h"
#include"TLegend.h"
#include"TH1.h"
#include"TF1.h"
#include"TStyle.h"
#include"TVirtualPad.h"
#include"TPaveText.h"

using namespace std;

void EnergyFitComparison()
{   
	//gStyle->SetOptStat(0);
    string EventParticle("electron");
    cout << EventParticle << endl;
    const int EventNo = 1000;
	const int EventEnergy = 40; // GeV 
	const double MIPEnergy = 0.305; //MeV
    char nametmp[100];
    sprintf(nametmp,"%s_%d_%dGeV.root",EventParticle.c_str(),EventNo,EventEnergy);
    //sprintf(nametmp,"data/%s_%d_%dGeV.root",EventParticle.c_str(),EventNo,EventEnergy);
    cout << nametmp << endl;
   // string filename(nametmp);

    TFile *simufile;
    TTree *simutree;
	char outputpath[100];
	sprintf(outputpath,"../Result/energy_deposition/%s",nametmp);
	TFile *fileout = new TFile(outputpath,"recreate");
    Double_t _PrimaryEnergy;
    vector<int>*	_ScintID;
    vector<int>*	_AbsorID;
    vector<int>*	_PCBID;
    vector<double>*	 _EnergyDep;
    vector<double>*	_AbsorEnergyDep;
    vector<double>*	 _PCBEnergyDep;
    
    double EnergyLayerDep[30];
	
	char inputpath[100];
	sprintf(inputpath,"../Result/merge_root/%s",nametmp);
    simufile = TFile::Open(inputpath);
    if(!simufile) cout << "Open file failed!"<< endl;
    simutree = (TTree*)simufile->Get("T");
    if(!simutree) cout << "Open tree failed!"<< endl;
    
	_PrimaryEnergy=0;	simutree->SetBranchAddress("PrimaryEnergy",&_PrimaryEnergy);
    _ScintID=nullptr; 	simutree->SetBranchAddress("CrystalID",&_ScintID);
    _AbsorID=nullptr;		simutree->SetBranchAddress("AbsorberID",&_AbsorID);
    _PCBID=nullptr;		simutree->SetBranchAddress("PCBID",&_PCBID);
    _EnergyDep=nullptr;	simutree->SetBranchAddress("EnergyDep",&_EnergyDep);
    _AbsorEnergyDep=nullptr;	simutree->SetBranchAddress("AbsorberEnDep",&_AbsorEnergyDep);
    _PCBEnergyDep=nullptr;	simutree->SetBranchAddress("PCBEnDep",&_PCBEnergyDep);
    int TreeEntryNo = simutree->GetEntries();

	TH1F *h1 = new TH1F("EnergyDep","EnergyDep_in_Scintillator",EventEnergy>=40?1000:(EventEnergy>5?8000:32000),0,8000);
	TH1F *heven = new TH1F("EvenEnergyDep","EnergyDep_in_Scintillator",EventEnergy>=40?1000:(EventEnergy>5?8000:32000),0,8000);
	TH1F *hodd = new TH1F("OddEnergyDep","EnergyDep_in_Scintillator",EventEnergy>=40?1000:(EventEnergy>5?8000:32000),0,8000);
	h1->SetLineColor(1);
	h1->SetLineWidth(1);
    for(int i_entry=0; i_entry<TreeEntryNo; i_entry++)
    //for(int i_entry=0; i_entry<2; i_entry++)
    {
		double sum = 0;
		double evensum = 0;
		double oddsum = 0;
        simutree->GetEntry(i_entry);
		for(int i_vector=0; i_vector<_EnergyDep->size(); i_vector++)
		{
			if(_EnergyDep->at(i_vector) > 0.8*MIPEnergy) //over threshold
         	{
				sum += _EnergyDep->at(i_vector);
				if((i_vector/210)%2==0)
					evensum += _EnergyDep->at(i_vector);
				else
					oddsum  += _EnergyDep->at(i_vector);
			}
		}
		h1->Fill(sum);
		heven->Fill(evensum);
		hodd->Fill(oddsum);
		if(!i_entry%1000)	cout << "sum=  " << sum <<endl; 
    }
	
	double constant = h1->GetBinContent(h1->GetMaximumBin());
	double mean = h1->GetMean();
	double sigma = h1->GetRMS();
	cout << constant << " " << mean << " " << sigma << endl;
	TF1 *f1 = new TF1("f1","gaus");
	f1->SetParameters(constant,mean,sigma);
	f1->SetLineWidth(3);
	h1->Fit(f1);

	TH1F *h2 = new TH1F();
	h1->Copy(*h2);
	TF1 *f2 = new TF1("f2","crystalball");
	f2->SetLineColor(4);
	f2->SetParameters(constant,mean,sigma,2,1);
	f2->SetLineWidth(3);
	h2->Fit(f2);

	fileout->cd();
	TCanvas *c1 = new TCanvas("c1","c1",800,600);
	TLegend *lg1 = new TLegend(0.16,0.75,0.42,0.85);
	lg1->AddEntry(f1,"Gaussian Fit");
	lg1->AddEntry(f2,"Crystal_Ball_Func Fit");
	gStyle->SetOptStat(0);
	c1->cd();
//	c1->SetLogy();
	c1->SetGridy();
	h1->SetTitle(Form("EnergyDep_Scintillator(%d GeV e-)",EventEnergy));
	h1->GetXaxis()->SetTitle("MeV");
	h1->GetXaxis()->SetRangeUser(EventEnergy>=40?0.82*mean:(EventEnergy>5?0.68*mean:0.3*mean),EventEnergy>=40?1.14*mean:(EventEnergy>5?1.22*mean:1.45*mean));
	//h1->GetXaxis()->SetRangeUser(3200,4400);
	h1->GetYaxis()->SetTitle("Entries");
	h1->SetLineWidth(2);
//	TPaveStats *s1 = ((TPaveStats *)(h1->GetListOfFunctions()->FindObject("stats")));
//	if(s1) { s1->Delete(0); } // get out of sight
	h1->Draw();
	f1->Draw("sameL");
	//h2->Draw("same");
	//f2->Draw("sameL");
	//lg1->Draw("same");

	
	TPaveText *pt1 = new TPaveText(.16,.3,.42,.65,"blNDC");
	TText * tt1 = pt1->AddText("Gaussian Fit : ");
	TText * tt2 = pt1->AddText(Form("Mean : %.2f #pm %.2f", f1->GetParameter(1), f1->GetParError(1)));
	TText * tt3 = pt1->AddText(Form("Sigma : %.2f #pm %.2f", f1->GetParameter(2), f1->GetParError(2)));
	TText * tt30 = pt1->AddText("");
	/*TLine * line = pt1->AddLine(0,0,0,0);
	line->SetLineColor(1);
	line->SetLineWidth(4);
	TText * tt4 = pt1->AddText("Crystal_Ball_Func Fit : ");
	TText * tt5 = pt1->AddText(Form("Mean : %.2f #pm %.2f", f2->GetParameter(1), f2->GetParError(1)));
	TText * tt6 = pt1->AddText(Form("Sigma : %.2f #pm %.2f", f2->GetParameter(2), f2->GetParError(2)));*/
	pt1->Draw();

	c1->Print(Form("plot/energydep/e-_%dGeV.png",EventEnergy));
	c1->Write();
	heven->GetXaxis()->SetTitle("MeV");
	hodd->GetXaxis()->SetTitle("MeV");
	heven->Write();
	hodd->Write();


}

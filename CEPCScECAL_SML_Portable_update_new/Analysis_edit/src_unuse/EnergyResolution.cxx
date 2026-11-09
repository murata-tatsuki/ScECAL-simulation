#include<iostream>
#include<TGraphErrors.h>
#include<TCanvas.h>
#include<TF1.h>
#include<TStyle.h>
#include<cmath>
using namespace std;

void EnergyResolution()
{
	gStyle->SetOptFit(1111);
	auto c1 = new TCanvas("c1","linearity",700,500);
	c1->SetGrid();
	c1->GetFrame()->SetFillColor(21);

/*	double Energy[10] = {10,20,30,40,50,60,70,80,100,120};	
	double EnergyErr[10] = {0};
	double EnergyRe[10] = {346.3,719.3,1086,1457,1789,
							2201,2526,2861,3557,4348};
	double EnergyReErr[10] = {0.3,0.2,0.3,0.3,0.4,
							0.4,0.4,0.7,0.6,0.6};
	double sigma[10] = {33.4,52.63,62.55,76.81,84.03,
						93.94,98.13,146.6,124.7,130.8};
	double sigmaErr[10] = {0.3,0.18,0.21,0.24,0.29,
						0.31,0.33,0.6,0.5,0.4};*/
	double Energy[10] = {10,20,30,40,50,60,70,80,90,100};	
	double EnergyErr[10] = {0};
	double EnergyRe[10] = {425.49,846.65,1266.15,1685.09,2099.83,
							2515.3,2931.1,3342.15,3754.54,4168.12};
	double EnergyReErr[10] = {0.2,0.3,0.4,0.67,0.68,
							0.86,0.86,1.15,1.13,1.55};
	double sigma[10] = {19.8,28.95,36.46,41.76,48.72,
							54.38,58.2,64.74,71.91,73.84};
	double sigmaErr[10] = {0.15,0.22,0.32,0.51,0.53,
							0.64,0.67,0.8,0.82,1.17};

	auto gr1 = new TGraphErrors(10,Energy,EnergyRe,EnergyErr,EnergyReErr);
	gr1->GetYaxis()->SetRangeUser(0,4500);
	auto f1 = new TF1("f1","[0]+[1]*x",0,140);
	gr1->Fit(f1);
	c1->cd();
	gr1->GetYaxis()->SetTitle("Energy Reconstruction / MeV");
	gr1->GetXaxis()->SetTitle("Beam Energy / GeV");
	gr1->SetTitle("Energy Linearity");
	gr1->SetMarkerColor(4);
	gr1->SetMarkerStyle(3);
	gr1->Draw("AP");
	f1->Draw("same");


	auto c2 = new TCanvas("c2","res",700,500);
	c2->GetFrame()->SetFillColor(21);
	double res[10] = {0};
	double resErr[10] = {0};
	for(int i = 0; i< 10 ; i++)
	{
		res[i] = sigma[i]/ EnergyRe[i];
		resErr[i] = pow(sigmaErr[i]/sigma[i],2) + pow(EnergyReErr[i]/EnergyRe[i],2);
		cout << resErr[i] << endl;
		resErr[i] = sqrt(resErr[i]); 
	}
	auto gr2 = new TGraphErrors(10,Energy,res,EnergyErr,resErr);
	gr2->GetYaxis()->SetRangeUser(0,0.2);
	auto f2 = new TF1("f2","[0]+[1]/sqrt(x)",0,140);
	gr2->Fit(f2);
	gr2->GetYaxis()->SetTitle("Energy Resolution");
	gr2->GetXaxis()->SetTitle("Beam Energy / GeV");
	gr2->SetTitle("Energy Resolution");
	gr2->SetMarkerColor(4);
	gr2->SetMarkerStyle(3);
	gr2->Draw("AP");
	f2->Draw("same");

}

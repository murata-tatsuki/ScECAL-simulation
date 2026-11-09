#include <iostream>
#include <sstream>
#include <string>
#include <TStyle.h>
#include <TPad.h>
using namespace std;

void DrawTogether()
{
	//string datafiledir = "/home/wangjx/HEP/CEPC2023/Result_SPS/calib/e-/40GeV";
	//string simufiledir = "/home/wangjx/HEP/CEPCScECAL_SML_Portable/Result/event_profile";
	//string comparefiledir = "/home/wangjx/HEP/CEPCScECAL_SML_Portable/Result/data_simu_comparison";
	string datafiledir = "/home/wangjx/HEP/CEPC2023/Result_SPS/calib/e-/";
	string simufiledir = "/home/wangjx/HEP/CEPCScECAL_SML_Portable_test/Result/energy_analysis_truth/";
	string simudigifiledir = "/home/wangjx/HEP/CEPCScECAL_SML_Portable_test/Result/energy_analysis_digi/";
	string comparefiledir = "/home/wangjx/HEP/CEPCScECAL_SML_Portable_test/Result/data_simu_comparison/";
	//for(double i = 4.0 ; i <= 10.0; i += 3.0 )
	for(int i = 20 ; i <= 20 ; i = i + 20 )
	{
		gStyle->SetOptStat(0);
		stringstream i_str;
		i_str << fixed << setprecision(0) << i;
		string filename = comparefiledir + i_str.str() + "GeV_hl_electron.root";
		TFile * fileout = new TFile(TString(filename),"RECREATE");
		string datafileana = datafiledir +  i_str.str() + "GeV/" + i_str.str() + "GeV_hl_electron.root";
		string simufileana = simufiledir + "electron_" + i_str.str() + "GeV_1000.root";
		string simudigifileana = simudigifiledir + "electron_" + i_str.str() + "GeV_1000.root";
		
		TFile * filedata = TFile::Open(TString(datafileana),"READ");
		TH1F * edepdata = (TH1F*)filedata->Get("Edep");
		TProfile * hitnodata = (TProfile*)filedata->Get("HitMap_pfx");
		TProfile * layeredepdata = (TProfile*)filedata->Get("LayerEdep_pfx");

		TFile * filesimu = TFile::Open(TString(simufileana),"READ");
		string edepsimuname = "AllEnergyDep";
		string hitnosimuname = "HitNoProfile";
		string layeredepsimuname = "HitEnergyProfile";
		TH1F * edepsimu = (TH1F*)filesimu->Get(TString(edepsimuname));
		TProfile * hitnosimu = (TProfile*)filesimu->Get(TString(hitnosimuname));
		TProfile * layeredepsimu = (TProfile*)filesimu->Get(TString(layeredepsimuname));
		
		TFile * filesimudigi = TFile::Open(TString(simudigifileana),"READ");
		string edepsimudiginame = "AllEnergyDep";
		string hitnosimudiginame = "HitNoProfile";
		string layeredepsimudiginame = "HitEnergyProfile";
		TH1F * edepsimudigi = (TH1F*)filesimudigi->Get(TString(edepsimudiginame));
		TProfile * hitnosimudigi = (TProfile*)filesimudigi->Get(TString(hitnosimudiginame));
		TProfile * layeredepsimudigi = (TProfile*)filesimudigi->Get(TString(layeredepsimudiginame));

		fileout->cd();
		TCanvas * c1 = new TCanvas("AllEnergyDep","AllEnergyDep",1200,800);
		TLegend * lg1 = new TLegend(0.67,0.7,0.85,0.85);
		lg1->AddEntry(edepdata,"data");
		lg1->AddEntry(edepsimu,"simu_raw");
		lg1->AddEntry(edepsimudigi,"simu_digi");
		c1->cd();
		gPad->SetGrid();
		gStyle->SetOptStat(0);
		edepdata->SetLineColor(kBlue);
		edepdata->Scale(0.08);
		double mean = edepsimu->GetMean();
		double sigma = edepsimu->GetRMS();
		edepdata->GetXaxis()->SetRangeUser(mean-sigma*10,mean+sigma*10);
		edepdata->GetYaxis()->SetRangeUser(0,1.2 * edepdata->GetMaximum());
		edepdata->GetXaxis()->SetTitle("Event Energy / MeV");
		edepdata->GetYaxis()->SetTitle("Entry");
		edepdata->Draw();
		edepsimu->SetLineColor(28);
		edepsimu->SetLineWidth(3);
		edepsimu->Draw("same");
		edepsimudigi->SetLineColor(31);
		edepsimudigi->SetLineWidth(3);
		edepsimudigi->Draw("same");
		lg1->Draw("same");
		c1->Write();
		c1->Update();
	//	c1->Close();
	//	delete c1;

		TCanvas * c2 = new TCanvas("HitNoProfile","HitNoProfile",1200,800);
		TLegend * lg2 = new TLegend(0.67,0.7,0.85,0.85);
		lg2->AddEntry(hitnodata,"data");
		lg2->AddEntry(hitnosimu,"simu_raw");
		lg2->AddEntry(hitnosimudigi,"simu_digi");
		c2->cd();
		gPad->SetGrid();
		gStyle->SetOptStat(0);
		hitnodata->SetLineColor(kBlue);
		hitnodata->SetLineWidth(2);
		hitnodata->GetXaxis()->SetTitle("LayerNo");
		hitnodata->GetYaxis()->SetTitle("entry");
		hitnodata->GetYaxis()->SetRangeUser(0,1.3 * hitnodata->GetMaximum());
		hitnosimu->SetLineColor(28);
		hitnosimu->SetLineWidth(2);
		hitnosimu->SetLineWidth(2);
		hitnosimudigi->SetLineColor(31);
		hitnosimudigi->SetLineWidth(2);
		hitnosimudigi->SetLineWidth(2);
		hitnodata->Draw();
		hitnosimu->Draw("same");
		hitnosimudigi->Draw("same");
		lg2->Draw("same");
		c2->Write();
		c2->Update();
	//	c2->Close();
	//	delete c2; 
		
		string str3 = "HitNoProfile";
		TCanvas * c3 = new TCanvas("HitEnergyProfile","HitEnergyProfile",1200,800);
		TLegend * lg3 = new TLegend(0.67,0.7,0.85,0.85);
		lg3->AddEntry(layeredepdata,"data");
		lg3->AddEntry(layeredepsimu,"simu_raw");
		lg3->AddEntry(layeredepsimudigi,"simu_digi");
		c3->cd();
		gPad->SetGrid();
		gStyle->SetOptStat(0);
		layeredepdata->SetLineColor(kBlue);
		layeredepdata->SetLineWidth(2);
		layeredepdata->GetXaxis()->SetTitle("LayerNo");
		layeredepdata->GetYaxis()->SetTitle("Energy / MeV");
		layeredepdata->GetYaxis()->SetRangeUser(0,1.3 * layeredepdata->GetMaximum());
		layeredepdata->Draw();
		layeredepsimu->SetLineColor(28);
		layeredepsimu->SetLineWidth(2);
		layeredepsimudigi->SetLineColor(31);
		layeredepsimudigi->SetLineWidth(2);
		layeredepsimu->Draw("same");
		layeredepsimudigi->Draw("same");
		lg3->Draw("same");
		c3->Draw();
		c3->Update();
		c3->Write();
	//	c3->Close();
	//	delete c3;
		
//		fileout->Close();
		cout << "Outfile : " << filename << endl; 
	}
}

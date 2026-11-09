#include<iostream>
#include<TTree.h>
#include<TFile.h>
#include<string>
#include<vector>

using namespace std; 

const int decodeID[6][36] = 
{ 
		0, 42, 1, 43, 2, 44, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 54, 13, 55, 14, 56, 15, 57, 16, 58, 17, 59, 18, 60, 19, 61, 20, 62, 21, 22, 23,
		24, 66, 25, 67, 26, 68, 27, 69, 28, 70, 29, 71, 30, 72, 31, 73, 32, 74, 33, 75, 34, 76, 35, 77, 36, 78, 37, 79, 38, 80, 39, 81, 40, 82, 41, 83,
		149, 148, 147, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 63, 64, 65, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125,
		150, 192, 151, 193, 152, 194, 153, 195, 154, 196, 155, 197, 156, 198, 157, 199, 158, 200, 159, 201, 160, 202, 161, 203, 162, 204, 163, 205, 164, 206, 165, 207, 166, 208, 167, 209,
		191, 190, 189, 188, 146, 187, 145, 186, 144, 185, 143, 184, 142, 183, 141, 182, 140, 181, 139, 180, 138, 179, 178, 177, 176, 175, 174, 173, 172, 171, 170, 128, 169, 127, 168, 126,
		137, 136, 135, 134, 133, 132, 131, 130, 129, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 45, 46, 47, 48, 49, 50, 51, 52, 53, 210, 210, 210, 210, 210, 210 };

double* CellID2Position(int cellid)
{
	int LayerNo = cellid / (1e5);
	int ChipNo 	= (cellid%100000) / (1e4);
	int ChanNo  = (cellid%100);
	int ScintillatorNo = decodeID[ChipNo][ChanNo];
	const double _xInterval = 5.3;	// 300 um gap in width direction
	const double _yInterval = 45.4; // 400 um gap in length direction
	const int rowNu = 42;
	const int columnNu = 5;
	int _xID = ScintillatorNo % rowNu; // 0-41
	int _yID = ScintillatorNo / rowNu; // 0-4
	static double _position[3] = { 0 };
	double x0 = _xInterval * _xID - _xInterval * (rowNu - 1) / 2.;//42 position
	double y0 = _yInterval * _yID - _yInterval * (columnNu - 1) / 2.;//5 position
	// for prototype test
	if (LayerNo % 2 == 0) 
	{
		_position[0] = -y0; 
		_position[1] = -x0;
		_position[2] = 1 + LayerNo / 2 * 19.9;
	}
	else
	{
		_position[0] = -x0; 
		_position[1] = -y0;
		_position[2] = 12.2 + (LayerNo - 1) / 2 * 19.9;
		//_position[2] = 12.95+(LayerNo-1)/2*19.9;
	}
	return _position;
}

int CopyNo2CellID(int copyno)
{
	int LayerNo  = copyno / 210;
	int DecodeID = copyno % 210;
	int ChipNo   = 0;
	int ChanNo   = 0;
	for(int i_chip = 0 ; i_chip < 6 ; i_chip++)
	{
		for(int i_chan = 0 ; i_chan < 36; i_chan++)
		{
			if(decodeID[i_chip][i_chan]==DecodeID)
			{
				ChipNo = i_chip;
				ChanNo = i_chan;
				break;
			}
			else	
				continue;
		}
	}
	return (LayerNo*1e5 + ChipNo*1e4 + ChanNo);
}

//void Convert(string fileinname, string fileoutname)
void Convert()
{
	//TString FileInName(fileinname);
	//TString FileOutName(fileoutname);
	TString FileInName("../Result/merge_root/electron_1000_40GeV.root");
	TString FileOutName("../Result/merge_root_convert/electron_1000_40GeV.root");

	TFile* filein = TFile::Open(FileInName,"READ");
	TTree* treein = (TTree*)filein->Get("T");
	if(!treein) cout << "@@@@@@@@ NO TREE !! @@@@@@@@" << endl;
	
	//int _primaryEnergy;
	std::vector<int>* 	 _crystalID = nullptr;
	std::vector<double>* _energyDep = nullptr;
	//T->SetBranchAddress("PrimaryEnergy",&_primaryEnergy);
	treein->SetBranchAddress("CrystalID",&_crystalID);
	treein->SetBranchAddress("EnergyDep",&_energyDep);

	TFile* fileout = new TFile(FileOutName,"RECREATE");
	TTree* treeout = new TTree("Simu_Hit","simulation_hit_result");
	int _eventNo;
	vector<int>	   _cellID;
	vector<double> _hitEnergy;
	vector<double> _hitX;
	vector<double> _hitY;
	vector<double> _hitZ;
	treeout->Branch("Event_Num",&_eventNo);
	treeout->Branch("CellID",&_cellID);
	treeout->Branch("Hit_Energy",&_hitEnergy);
	treeout->Branch("Hit_X",&_hitX);
	treeout->Branch("Hit_Y",&_hitY);
	treeout->Branch("Hit_Z",&_hitZ);

	for(int i_entry = 0; i_entry < treein->GetEntries(); i_entry++)
	{
		treein->GetEntry(i_entry);
		if(_cellID.size()) 		_cellID.clear();
		if(_hitEnergy.size()) 	_hitEnergy.clear();
		if(_hitX.size()) 		_hitX.clear();
		if(_hitY.size()) 		_hitY.clear();
		if(_hitZ.size()) 		_hitZ.clear();
		int _eventNo = i_entry;
		for(size_t i_vector = 0 ; i_vector < _crystalID->size(); i_vector++)
		{
			int cellid  = CopyNo2CellID( (int)(_crystalID->at(i_vector)) );
			int layerid = cellid / 1e5;
			int chipid  = (cellid%100000) / 1e4;
			int chanid  = cellid % 100;
			_cellID.push_back(cellid);
			_hitEnergy.push_back(_energyDep->at(i_vector));//MeV
			double* position = CellID2Position(cellid);
			_hitX.push_back(position[0]);
			_hitY.push_back(position[1]);
			_hitZ.push_back(position[2]);
		}
		treeout->Fill();
	}
	
	fileout->cd();
	treeout->Write();
}

#include <iostream>
#include "MCDigi.h"
#include "Extract.h"

using namespace std;

int main(int argc, char* argv[])
{
	MCDigi MCD;
	Extract EXTR;
	
	// simulation truth
	//cout << "=== === === === === === === === === === === === === === === " << endl;
	//cout << "Process : Raw Convert" << endl;
	//MCD.Raw2FormatConvert(argv[1], argv[2]);
	//cout << "Finish  : Raw Convert" << endl;
	//cout << "=== === === === === === === === === === === === === === === " << endl;

	// cout << "Process : Simulation Truth " << endl;
	// MCD.Process(argv[2], argv[3], argv[4]);
	// cout << "... ... ... ... ... ... ... ... ... ... ... ... ... ... ... " << endl;	
	// cout << "=== === === === === === === === === === === === === === === " << endl;
	// cout << "... ... ... ... ... ... ... ... ... ... ... ... ... ... ... " << endl;	
	int thre = argc<8 ? 0 : stoi(argv[8]);
	cout << "threshold file " << argv[6] << endl;
	cout << "threshold " << thre << endl;
	
	cout << "=== === === === === === === === === === === === === === === " << endl;
	cout << "Process : Simulation Digi" << endl;
	EXTR.PedestalExtract(argv[2]);
	EXTR.HLGainRatioExtract(argv[3]);
	EXTR.MIPPeakValueExtract(argv[4]);
	EXTR.SiPMGainExtract(argv[5]);
	EXTR.TresholdExtract(argv[6], thre);
	MCD.SimuDigi(argv[1], argv[7], EXTR);
	cout << "Finish  : Simulation Digi" << endl;
	cout << "=== === === === === === === === === === === === === === === " << endl;

	return 0;
}

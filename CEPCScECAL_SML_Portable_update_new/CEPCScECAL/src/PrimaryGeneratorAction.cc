#include "PrimaryGeneratorAction.hh"
#include "PrimaryGeneratorMessenger.hh"
#include "G4Event.hh"
#include "G4HEPEvtInterface.hh"
#include "G4ParticleTable.hh"
#include "G4IonTable.hh"
#include "G4ParticleDefinition.hh"
#include "G4Geantino.hh"
#include "G4SystemOfUnits.hh"
#include "Randomize.hh"
#include "globals.hh"
#include "G4ios.hh"
#include "G4GeneralParticleSource.hh"
#include "G4SPSPosDistribution.hh" // 追記: 位置分布を変更するため
#include "HistoManager.hh"

// ROOT ヘッダの追記
#include <TFile.h>
#include <TH2D.h>

PrimaryGeneratorAction::PrimaryGeneratorAction( DetectorConstruction* det, HistoManager* histo)
 : G4VUserPrimaryGeneratorAction(), fGParticleSource(0), fDetector(det), fHistoManager_Particle(histo), fHitMap2D(nullptr)
{
  fGParticleSource  = new G4GeneralParticleSource();
  useHEPEvt = false;
  a = 11;
  messenger = new PrimaryGeneratorMessenger(this);

  // ==========================================
  // ROOTファイルから HitMap を読み込む
  // ==========================================
  TFile* file = TFile::Open("beam_hitmap.root", "READ"); // 作成したROOTファイル名
  if (file && !file->IsZombie()) {
    fHitMap2D = (TH2D*)file->Get("h_hitmap_smooth"); // ヒストグラム名
    if (fHitMap2D) {
      fHitMap2D->SetDirectory(0); // ファイルを閉じてもメモリに残す設定
      G4cout << "HitMap successfully loaded from beam_hitmap.root!" << G4endl;
    } else {
      G4cerr << "Error: Histogram not found in ROOT file!" << G4endl;
    }
    file->Close();
    delete file;
  } else {
    G4cerr << "Warning: Cannot open beam_hitmap.root. Using default GPS settings." << G4endl;
  }
}

PrimaryGeneratorAction::~PrimaryGeneratorAction()
{
  delete fGParticleSource;
  delete messenger;
  if (fHitMap2D) delete fHitMap2D; // メモリ解放
}

void PrimaryGeneratorAction::GeneratePrimaries(G4Event* anEvent)
{
  fHistoManager_Particle->fParticleInfo.reset();
  if (useHEPEvt) { 
    // ...
  } else {
    // ==========================================
    // HitMap があれば、GPS の位置をイベントごとに上書き
    // ==========================================
    if (fHitMap2D) {
      double x_mm = 0.0;
      double y_mm = 0.0;
      fHitMap2D->GetRandom2(x_mm, y_mm);

      // 分布タイプをPointにし、サンプリングした座標をセット (Zは -60mm)
      fGParticleSource->GetCurrentSource()->GetPosDist()->SetPosDisType("Point");
      fGParticleSource->GetCurrentSource()->GetPosDist()->SetCentreCoords(G4ThreeVector(x_mm * mm, y_mm * mm, -60.0 * mm));
    }

    // 粒子の生成
    fGParticleSource->GeneratePrimaryVertex(anEvent);
    
    // HistoManager への記録 (既存のコードそのまま)
    G4ThreeVector direction = fGParticleSource->GetParticleMomentumDirection();
    G4ThreeVector position = fGParticleSource->GetParticlePosition();
    G4int PDG = fGParticleSource->GetParticleDefinition()->GetPDGEncoding();
    G4double mass = fGParticleSource->GetParticleDefinition()->GetPDGMass();
    G4double energy = fGParticleSource->GetParticleEnergy();
    
    fHistoManager_Particle->fParticleInfo.fPrimaryPDG = PDG;
    fHistoManager_Particle->fParticleInfo.fPrimaryEnergy = energy;
    fHistoManager_Particle->fParticleInfo.fPrimaryPosX = position.x();
    fHistoManager_Particle->fParticleInfo.fPrimaryPosY = position.y();
    fHistoManager_Particle->fParticleInfo.fPrimaryPosZ = position.z();
    fHistoManager_Particle->fParticleInfo.fPrimaryDirection.push_back(direction.x());
    fHistoManager_Particle->fParticleInfo.fPrimaryDirection.push_back(direction.y());
    fHistoManager_Particle->fParticleInfo.fPrimaryDirection.push_back(direction.z());
  }
}
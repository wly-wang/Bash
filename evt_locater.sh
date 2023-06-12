#!/bin/bash
#This script must be ran on one of the uboonegpvm
#Arguments: run, subrun, event

ROOT_FILES_DIR="/pnfs/uboone/persistent/users/jiaoyang/for_William/muons_reco2"

echo "Run number: ${1}.${2}, Event Number: ${3}"

for FILE in ${ROOT_FILES_DIR}/*.root 
#for FILE in ${ROOT_FILES_DIR}/muons_artrootfile_semi_analytical_100cm_reco2_1.root #this line is for testing only, so doesn't loop through all files.
do
        root -b -l ${FILE} <<-TEST                       
        TTree *Events = (TTree*)_file0->Get("Events");
        Events->SetScanField(0);
        const char* filePath = gFile->GetName();        
        .> test.log
        Events->Scan("raw::DAQHeader_daq__Swizzler.obj.fRun", "raw::DAQHeader_daq__Swizzler.obj.fRun == ${1} && raw::DAQHeader_daq__Swizzler.obj.fSubRun == ${2} && raw::DAQHeader_daq__Swizzler.obj.fEvent == ${3}");                        
        std::cout<< filePath  << std::endl;   
        .>
        .q                                               
        TEST
        mv test.log test_${FILE##*/}.log
done
grep -rH " 1 selected " /uboone/app/users/wwang/evt_finding_analyzer/*.log

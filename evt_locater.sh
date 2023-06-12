#!/bin/bash

#Arguments: run, subrun, event

ROOT_FILES_DIR="/pnfs/uboone/persistent/users/jiaoyang/for_William/muons_reco2"

echo "Run number: ${1}.${2}, Event Number: ${3}"

for FILE in ${ROOT_FILES_DIR}/*.root
#for FILE in ${ROOT_FILES_DIR}/muons_artrootfile_semi_analytical_100cm_reco2_1.root 
do
        root -b -l ${FILE} <<-TEST                       
#open root and work in root environment until TEST
        TTree *Events = (TTree*)_file0->Get("Events");
        Events->SetScanField(0);
        const char* filePath = gFile->GetName();        
#a variable which will get the file path using gFile
        .> test.log                                      
#create and open a .log file called test.log.

        Events->Scan("raw::DAQHeader_daq__Swizzler.obj.fRun", "raw::DAQHeader_daq__Swizzler.obj.fRun == ${1} && raw::DAQHeader_daq__Swizzler.obj.fSubRun == ${2} && raw::DAQHeader_daq__Swizzler.obj.fEvent == ${3}");                        

#The main scan command that returns the number of entries found and spits out the row number for the event
        std::cout<< filePath  << std::endl               
#print the path of the current art-root file in loop
        .>                                               
#this basically closes the .log file
        .q                                               
#exits root
        TEST                                             

        timestamp=$(date +%Y%m%d%H%M%S)
#get the current timestamp
        mv test.log ${timestamp}.log
#renaming the .log file each loop with timestamp to get a unique name.
done
grep -r " 1 selected " /uboone/app/users/wwang/evt_finding_analyzer/*.log

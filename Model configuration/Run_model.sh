#!/bin/bash

#------------------------------
# Run the coupled model
#------------------------------


#SBATCH --job-name=test
#SBATCH --time=11:59:00
#SBATCH --nodes=1
#SBATCH --ntasks=25
#SBATCH --cpus-per-task=1
#SBATCH --exclusive


THEDATE=`date`
echo '*********************************************************'
echo 'Start job '$THEDATE
echo '*********************************************************'
echo 'SLURM_NODELIST = '$SLURM_NODELIST
echo 'SLURM_NPROCS = '$SLURM_NPROCS
#echo 'SLURM_JOB_ID = '$SLURM_JOB_ID


# Load Snow environment variables
shopt -s expand_aliases
source /network/rit/lab/snowclus/modules/2019i.bash


# Set up parameters

Np=25
NpC=1
NpO=12
NpA=12

echo 'NpC = '$NpC
echo 'NpO = '$NpO
echo 'NpA = '$NpA


DIR=/network/rit/home/fz172169/MITgcm/Ridge/fric
runDir=/network/rit/lab/roselab_rit/mitgcm_run/test
scrDir=$DIR/scripts

mkdir $runDir/out
outDir=$runDir/out

# path to executables
exC=$DIR/build_cpl/mitgcmuv
exO=$DIR/build_ocn/mitgcmuv
exA=$DIR/build_atm/mitgcmuv

rnkC=0
rnkO=1
rnkA=`expr $rnkO + $NpO`
cplDir=rank_$rnkC
ocnDir=rank_$rnkO
atmDir=rank_$rnkA


#-----------------------------------------------------------------------------#
#     - Load PC parameters                                                    #
#     - Determine stop iteration for this period                              #
#-----------------------------------------------------------------------------#
varlist="period iitO iitA fitO fitA nitC nitO nitA \
         pChkptFreq taveFreq cpl_taveFreq dumpFreq monitorFreq       \
	     thSIce_diagFreq landFlag land_diagFreq  \
	     dtA dtO dtC LocalScratch diagFlag diagInterval"
cd $runDir
source pc.vars

sitO=$(($iitO+$nitO))
sitA=$(($iitA+$nitA))
iitO0=`$scrDir/add0upto10c $iitO`
iitA0=`$scrDir/add0upto10c $iitA`
sitO0=`$scrDir/add0upto10c $sitO`
sitA0=`$scrDir/add0upto10c $sitA`

echo "Period:                         "$period

rm -f cplmonitor
echo "Simulation directory:           "$runDir        >  cplmonitor
echo "Period:                         "$period        >> cplmonitor
echo "Period START iteration:"                        >> cplmonitor
echo "    Ocean         "$iitO                        >> cplmonitor
echo "    Atmosphere    "$iitA                        >> cplmonitor
echo "Period STOP iteration:"                         >> cplmonitor
echo "    Ocean         "$sitO                        >> cplmonitor
echo "    Atmosphere    "$sitA                        >> cplmonitor
echo "Overall FINAL iteration:"                       >> cplmonitor
echo "    Ocean         "$fitO                        >> cplmonitor
echo "    Atmosphere    "$fitA                        >> cplmonitor


#-----------------------------------------------------------------------------#
#     - Set coupled data file, and cpl_taveFreq in the ocean data.cpl file    #
#     - Set ocean and atmosphere data files                                   #
#-----------------------------------------------------------------------------#
$scrDir/setdatacpl $runDir/$cplDir $runDir/$ocnDir $nitC $cpl_taveFreq
$scrDir/setdata $runDir/$ocnDir $iitO $nitO $pChkptFreq \
                $taveFreq $dumpFreq $monitorFreq
$scrDir/setdata $runDir/$atmDir $iitA $nitA $pChkptFreq \
                $taveFreq $dumpFreq $monitorFreq
$scrDir/setdatapkg $runDir/$atmDir $thSIce_diagFreq $landFlag $land_diagFreq
$scrDir/setdatadiag $runDir/$ocnDir $diagFlag
$scrDir/setdatadiag $runDir/$atmDir $diagFlag

#-----------------------------------------------------------------------------#
#   Move pickup files to ocean rank, copy atmospheric pickup files forward    #
#-----------------------------------------------------------------------------#
oldper=$((period-1))
for tile in `seq $NpO`; do
#    tile30=`$scrDir/add0upto3c $tile`
    cp $outDir/Cpl$oldper/Ocn/pickup*$iitO0* \
       $runDir/rank_$tile/.
done
#cp $outDir/Cpl$oldper/Ocn/pickup*$iitO0* $runDir/$ocnDir/

for tile in `seq $NpA`; do
#    tile30=`$scrDir/add0upto3c $tile`
    cp $outDir/Cpl$oldper/Atm/pickup*$iitA0* \
       $runDir/rank_$((tile+$NpO))/.
#    #cp -p $outDir/Cpl$oldper/Atm/pickup_aimCo2.$iitA0* $runDir/rank_$((tile+$NpO))/
done
#cp $outDir/Cpl$oldper/Atm/pickup*$iitA0* $runDir/$atmDir/


echo '*************************'  >> cplmonitor
echo 'Running the coupled model'  >> cplmonitor
echo '*************************'  >> cplmonitor
mpirun -n $NpC $exC : -n $NpO $exO : -n $NpA $exA > MPImonitor$period 2>&1
#mpirun --mca btl '^openib' -n $NpC $exC : -n $NpO $exO : -n $NpA $exA > MPImonitor$period 2>&1
status=$?
echo "Ended with status:  "$status   >> cplmonitor

if [ $status -ne 0 ] ; then exit; fi


#-----------------------------------------------------------------------------#
#                             Check for pickups                               #
#-----------------------------------------------------------------------------#
pickO=$ocnDir/pickup.$sitO0.data
pickA=$atmDir/pickup.$sitA0.data
if [ -f $pickO ]; then echo "Ocn pickup present:  "$pickO >> cplmonitor
else echo "No Ocn pickup:  "$pickO >> cplmonitor; exit; fi
if [ -f $pickA ]; then echo "Atm pickup present:  "$pickA >> cplmonitor
else echo "No Atm pickup:  "$pickA >> cplmonitor; exit; fi


#-----------------------------------------------------------------------------#
#                       Move old data (just copy pickups)                     #
#-----------------------------------------------------------------------------#
$scrDir/movedataCpl2 $NpC $runDir $ocnDir $atmDir $outDir \
                     $period $sitO0 $sitA0 cplmonitor $NpO $NpA

rm rank_*/pickup*$iitO0*
rm rank_*/pickup*$iitA0*


#-----------------------------------------------------------------------------#
#                      Reset periodic coupling parameters                     #
#-----------------------------------------------------------------------------#
# make a copy of the current state of pc.vars before modifying
cp pc.vars $outDir/Cpl$period/MiscLog/
source pc.vars
iitO=$sitO
iitA=$sitA
period=$(($period+1))
if [ $diagInterval -gt 0 -a `expr $period % $diagInterval` -eq 0 ]; then
    diagFlag=.TRUE.
else
    diagFlag=.FALSE.; fi
rm -f pc.vars
for i in $varlist; do echo $i'='`eval echo '$'$i` >> pc.vars.temp; done
mv pc.vars.temp pc.vars


#-----------------------------------------------------------------------------#
#                         Resubmit coupled model                              #
#-----------------------------------------------------------------------------#
if [ $iitO -ge $fitO ]; then
    echo "New iitO exceeds fitO;  All done!" >> cplmonitor; 
elif [ $iitA -ge $fitA ]; then
    echo "New iitA exceeds fitA;  All done!" >> cplmonitor; 
else
    sbatch $DIR/Run_model.sh; fi


THEDATE=`date`
echo '*********************************************************'
echo 'End of job '$THEDATE
echo '*********************************************************'

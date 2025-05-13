#PBS -N jevs_global_det_wave_prep_00
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=08:00:00
#PBS -l place=shared,select=1:ncpus=1:mem=15GB
#PBS -l debug=true

set -x 

cd $PBS_O_WORKDIR

export model=evs
export HOMEevs=/lfs/h2/emc/vpppg/noscrub/$USER/EVS_stand_alone/EVS_gfsv17/EVS

export SENDCOM=YES
export SENDMAIL=NO
export KEEPDATA=YES
export job=${PBS_JOBNAME:-jevs_global_det_wave_prep}
export jobid=$job.${PBS_JOBID:-$$}
export SITE=$(cat /etc/cluster_name)
export vhr=00

source $HOMEevs/versions/run.ver
module reset
module load prod_envir/${prod_envir_ver}
source $HOMEevs/dev/modulefiles/global_det/global_det_prep.sh

evs_ver_2d=$(echo $evs_ver | cut -d'.' -f1-2)

export MAILTO='qi.shi@noaa.gov'

export envir=prod
export NET=evs
export STEP=prep
export COMPONENT=global_det
export RUN=wave


export DATAROOT=/lfs/h2/emc/stmp/$USER/evs_test/$envir/tmp
export TMPDIR=$DATAROOT
export COMIN=/lfs/h2/emc/vpppg/noscrub/$USER/$NET/$evs_ver_2d
export COMOUT=/lfs/h2/emc/vpppg/noscrub/$USER/EVS_stand_alone/EVS_gfsv17/$NET/$evs_ver_2d/$STEP/$COMPONENT/$RUN

export MODELNAME="gfs"
export OBSNAME="prepbufr_gdas ndbc jason3"

# LOOP through INITDATEs
START_DATE=20241102
END_DATE=20241109

current_date=$START_DATE

while [ "$current_date" -le "$END_DATE" ]; do
    export INITDATE=$current_date
    echo "=== Running JEVS_GLOBAL_DET_PREP for INITDATE=$INITDATE ==="
    $HOMEevs/jobs/JEVS_GLOBAL_DET_PREP
    echo "=== Finished job for $INITDATE. Sleeping 10 minutes... ==="
    sleep 600  # 10 minutes

    # Move to next date
    current_date=$(date -d "$current_date +1 day" +%Y%m%d)
done

echo "=== All jobs completed from $START_DATE to $END_DATE ==="

# CALL executable job script here
#$HOMEevs/jobs/JEVS_GLOBAL_DET_PREP

#####################################################################
# Purpose: This does the prep work for the global deterministic wave
#####################################################################

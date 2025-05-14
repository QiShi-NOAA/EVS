#PBS -N jevs_global_det_atmos_prep_00
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=03:00:00
#PBS -l place=exclhost,select=1:ncpus=1:mem=100GB
#PBS -l debug=true

set -x 

cd $PBS_O_WORKDIR

export model=evs
export HOMEevs=/lfs/h2/emc/vpppg/noscrub/$USER/EVS_stand_alone/EVS_gfsv16/EVS

export SENDCOM=YES
export SENDMAIL=NO
export KEEPDATA=NO
export job=${PBS_JOBNAME:-jevs_global_det_atmos_prep}
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
export RUN=atmos

export DATAROOT=/lfs/h2/emc/stmp/$USER/evs_test/$envir/tmp
export TMPDIR=$DATAROOT
export COMIN=/lfs/h2/emc/vpppg/noscrub/$USER/$NET/$evs_ver_2d
export COMOUT=/lfs/h2/emc/vpppg/noscrub/$USER/EVS_stand_alone/EVS_gfsv16/$NET/$evs_ver_2d/$STEP/$COMPONENT/$RUN

export MODELNAME="gfs"
export OBSNAME="osi_saf ghrsst_ospo ccpa_accum24hr prepbufr_gdas prepbufr_nam"


# LOOP through INITDATEs
START_DATE=20241201
END_DATE=20241210

current_date=$START_DATE

while [ "$current_date" -le "$END_DATE" ]; do
    export INITDATE=$current_date
    echo "=== Running JEVS_GLOBAL_DET_PREP for INITDATE=$INITDATE ==="

    $HOMEevs/jobs/JEVS_GLOBAL_DET_PREP

     echo "=== Finished job for $INITDATE. Sleeping 15 minutes... ==="
     sleep 900  # 15 minutes

    # Move to next date
    current_date=$(date -d "$current_date +1 day" +%Y%m%d)
done

echo "=== All jobs completed from $START_DATE to $END_DATE ==="


# CALL executable job script here
#$HOMEevs/jobs/JEVS_GLOBAL_DET_PREP

######################################################################
# Purpose: This does the prep work for the global deterministic atmospheric
######################################################################

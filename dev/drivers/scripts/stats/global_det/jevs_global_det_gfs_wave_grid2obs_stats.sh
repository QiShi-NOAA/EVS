#PBS -N jevs_global_det_gfs_wave_grid2obs_stats_00
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=05:00:00
#PBS -l place=vscatter,select=1:ncpus=25:mem=50GB
#PBS -l debug=true

set -x 

cd $PBS_O_WORKDIR

export model=evs
export HOMEevs=/lfs/h2/emc/vpppg/noscrub/$USER/EVS_stand_alone/EVS_gfsv16/EVS

export SENDCOM=YES
export SENDMAIL=NO
export KEEPDATA=NO
export job=${PBS_JOBNAME:-jevs_global_det_gfs_wave_grid2obs_stats}
export jobid=$job.${PBS_JOBID:-$$}
export SITE=$(cat /etc/cluster_name)
export vhr=00

source $HOMEevs/versions/run.ver
module reset
module load prod_envir/${prod_envir_ver}
source $HOMEevs/dev/modulefiles/global_det/global_det_stats.sh

evs_ver_2d=$(echo $evs_ver | cut -d'.' -f1-2)

export machine=WCOSS2
export USE_CFP=YES
export nproc=25

export OMP_NUM_THREADS=1

export MAILTO='qi.shi@noaa.gov'

export envir=prod
export NET=evs
export STEP=stats
export COMPONENT=global_det
export RUN=wave
export VERIF_CASE=grid2obs
export MODELNAME=gfs

export DATAROOT=/lfs/h2/emc/stmp/$USER/evs_test/$envir/tmp
export TMPDIR=$DATAROOT
export COMIN=/lfs/h2/emc/vpppg/noscrub/$USER/EVS_stand_alone/EVS_gfsv16/$NET/$evs_ver_2d
export COMOUT=/lfs/h2/emc/vpppg/noscrub/$USER/EVS_stand_alone/EVS_gfsv16/$NET/$evs_ver_2d/$STEP/$COMPONENT

# LOOP through INITDATEs 
START_DATE=20241110
END_DATE=20241119

current_date=$START_DATE

while [ "$current_date" -le "$END_DATE" ]; do
    export VDATE=$current_date
    echo "=== Running JEVS_GLOBAL_DET_PREP for VDATE=$VDATE ==="

    $HOMEevs/jobs/JEVS_GLOBAL_DET_STATS
    echo "=== Finished job for $VDATE. Sleeping 20 minutes... ==="
    sleep 1200  # 20 minutes

    # Move to next date
    current_date=$(date -d "$current_date +1 day" +%Y%m%d)
done

echo "=== All jobs completed from $START_DATE to $END_DATE ==="



# CALL executable job script here
#$HOMEevs/jobs/JEVS_GLOBAL_DET_STATS

#######################################################################
# Purpose: This does the statistics work for the global deterministic
#          wave grid-to-obs component for GFS
#######################################################################

#!/bin/bash
##############################################################
# Name of Script: evs_wave_leadaverages.sh                    
# Modifed for EVS-GLWU: Samira Ardani (samira.ardani@noaa.gov)
# Cited to: Deanna Spindler (Deanna.Spindler@noaa.gov)                  
# Purpose of Script: Make the lead_averages.py command files  
#                                                             

#################################
# Make the command files for cfp 
#################################

# set up plot variables

periods='LAST31DAYS LAST90DAYS'

inithours='01 07 13 19'
fhrs='000,024,048,072,096,120,144'
# fhr is hardcoded below!
wave_vars='HTSGW WIND'
stats_list='stats1 stats2 stats3 stats4 stats5'
ptype='lead_average'
region='GreatLakes'
export region=${region}

export GRID2OBS_CONF="${PARMevs}/metplus_config/${STEP}/${COMPONENT}/${RUN}_${VERIF_CASE}"

cd ${DATA}
mkdir -p ${DATA}/ndbc_standard
touch plot_all_${MODELNAME}_${RUN}_g2o_plots.sh

# write the commands
for period in ${periods} ; do
  if [ ${period} = 'LAST31DAYS' ] ; then
    plot_start_date=${PDYm31}
  elif [ ${period} = 'LAST90DAYS' ] ; then
    plot_start_date=${PDYm90}
  fi
  for vhr in ${inithours} ; do
    for wvar in ${wave_vars} ; do
      for stats in ${stats_list}; do
        echo "export VERIF_CASE=${VERIF_CASE} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export RUN=${RUN} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export USHevs=${USHevs}/${COMPONENT} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export FIXevs=${FIXevs}  " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export DATA=${DATA} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export MODNAM=${MODNAM} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export PERIOD=${period} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export VERIF_CASE=${VERIF_CASE} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export plot_start_date=${plot_start_date} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export plot_end_date=${VDATE} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export VHR=${vhr} " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        case ${stats} in
          'stats1')
            echo "export METRIC='me, rmse' " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
            ;;
          'stats2')
            echo "export METRIC=pcor " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
            ;;
          'stats3')
            echo "export METRIC='fbar, obar' " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
            ;;
          'stats4')
            echo "export METRIC=esd " >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
            ;; 
          'stats5')
            echo "export METRIC=si "  >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
            ;;
          'stats6')
            echo "export METRIC=p95 "  >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
            ;;
        esac
        echo "export FHR='000,024,048,072,096,120,144'" >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "export WVAR=${wvar}"      >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        case ${wvar} in
          'WIND')
            echo "export OBS_LEVEL=Z10"  >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
            ;;
          *)
            echo "export OBS_LEVEL=L0"  >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
            ;;
        esac
        echo "export PTYPE=${ptype}" >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        echo "${GRID2OBS_CONF}/py_plotting_wave.config"  >> plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        
        chmod +x plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh
        
        echo "${DATA}/plot_${wvar}_${vhr}_${stats}_${ptype}_${period}.sh" >> plot_all_${MODELNAME}_${RUN}_g2o_plots.sh
        
      done  # end of stats
    done  # end of wave vars
  done  # end of inithours
done  # end of periods
  
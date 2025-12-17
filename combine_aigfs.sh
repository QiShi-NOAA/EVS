#PBS -N combine_aigfs
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=1
#PBS -l debug=true

# === CONFIGURABLE ===
DATE=$(date -d "24 hours ago" '+%Y%m%d')
echo "${DATE}"
INPUT_BASE="/lfs/h1/ops/prod/com/aigfs/v1.0/aigfs.${DATE}"
OUTPUT_BASE="/lfs/h2/emc/vpppg/noscrub/qi.shi/EVS_graphcastGFS/evs/v1.0/prep/global_det/aigfs.${DATE}"

# Loop over initial hours
for INIT_HOUR in 00 06 12 18; do
    #echo "Processing INIT HOUR: $INIT_HOUR Z"

    # Input and output directories
    IN_DIR="${INPUT_BASE}/${INIT_HOUR}/model/atmos/grib2"
    OUT_DIR="${OUTPUT_BASE}/${INIT_HOUR}/atmos"

    # Create output directory if it doesn't exist
    mkdir -p "$OUT_DIR"

    # Loop over forecast hours
    for (( fh=0; fh<=384; fh+=6 )); do	    
        FHR=$(printf "%03d" $fh)

        # File paths
        PRES_FILE="${IN_DIR}/aigfs.t${INIT_HOUR}z.pres.f${FHR}.grib2"
        SFC_FILE="${IN_DIR}/aigfs.t${INIT_HOUR}z.sfc.f${FHR}.grib2"
        COMBINED_FILE="${OUT_DIR}/aigfs.t${INIT_HOUR}z.combined.f${FHR}.grib2"

        # Check if input files exist
        if [[ -f "$PRES_FILE" && -f "$SFC_FILE" ]]; then
            echo " Combining f${FHR} for t${INIT_HOUR}z..."

            # Remove any existing combined file
            rm -f "$COMBINED_FILE"

            # Copy PRES file as base
            cp "$PRES_FILE" "$COMBINED_FILE"

            # Append SFC file
            wgrib2 "$SFC_FILE" -append -grib_out "$COMBINED_FILE"

            echo " Created: $COMBINED_FILE"
        else
            echo " Missing file(s) for t${INIT_HOUR}z f${FHR} — skipping."
        fi
    done
done

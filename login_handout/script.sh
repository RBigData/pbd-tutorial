#!/bin/sh

sc=`uname -a | awk '{ print $2 }'`

outdir="${HOME}/pbdR_examples/"

if [ ! -d "${outdir}" ]; then
  mkdir $outdir
fi

# remove last character (login node number)
scl1=`echo $sc | sed 's/.$//'`

# Nautilus
if [ $sc = "conseil" -o $sc = "nautilus" ]; then
  path="/path/to/scripts.tar.gz"
  tmpdir="/lustre/wherever"
# Kraken
elif [ $scl1 = "krakenpf" ]; then
  path="/path/to/scripts.tar.gz"
  tmpdir="lustre/wherever"
# Lens
elif [ $scl1 = "lens-login" ]; then
  path=""
  tmpdir=""
# Chester
elif [ $scl1 = "chester-login" ]; then
  path="/lustre/scratch/sw/r/3.0.1.new/chest/gnu4.7.3/EXAMPLES/scripts.tar.gz"
  tmpdir="/lustre/scratch/$USER/R_TEMP"
fi


if [ ! -d $tmpdir ]; then
  mkdir ${tmpdir}/R_TEMP/
fi


cp ${path} ${outdir}
cd ${outdir}
tar xvf scripts.tar.gz
cd scripts/



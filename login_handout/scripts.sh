#!/bin/sh

sc=`uname -a | awk '{ print $2 }'`

outdir="${HOME}/pbdR_examples/"

if [ ! -d "${outdir}" ]; then
	mkdir $outdir
fi


# Nautilus
if [ $sc = "conseil" -o $sc = "nautilus" ]; then
	path="/path/to/scripts.tar.gz"
	tmpdir="/lustre/wherever"
# Kraken
#elif [ $sc = "
fi



if [ ! -d $tmpdir ]; then
	mkdir ${tmpdir}/R_TEMP/
fi


cp ${path} ${outdir}
cd ${outdir}
tar xvf scripts.tar.gz
cd scripts/


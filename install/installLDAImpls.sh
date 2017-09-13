#!/bin/bash

LDAINSTALL_PATH=$PWD

cd ..
mkdir -p build
cd build

# ----------------------------------------------------------------------------
# memusg (python script for checking virtual memory of a process)
git clone https://github.com/jhclark/memusg.git
cd memusg
destinationFile="memusg"
# change one line in code to print in MB instead of kb
pattern="out.write(\"memusg: vmpeak: {} kb\\\n\".format(vmpeak))"
replacement="out.write(\"memusg: vmpeak: {} MB\\\n\".format(vmpeak/(1024*8)))"
sed -i "s#$pattern#$replacement#g" $destinationFile

cd ..

# ----------------------------------------------------------------------------
# LightLDA
git clone https://github.com/Microsoft/LightLDA.git
cd LightLDA
sh build.sh
cd ..




# ----------------------------------------------------------------------------
# LDA++ 3rd party lib
# WARNING: boost and Eigen3 must be already installed
EIGEN3_AND_BOOST_PREFIX_PATH="/usr/local;/usr/lib/x86_64-linux-gnu"
mkdir -p docopt_inst
cd docopt_inst
DOCOPT_PREFIX_PATH=$PWD
cd ..


git clone https://github.com/docopt/docopt.cpp.git
cd docopt.cpp
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX="$DOCOPT_PREFIX_PATH" ..
make -j4
make install
cd ../..


# ----------------------------------------------------------------------------
# LDA++
git clone https://github.com/angeloskath/supervised-lda.git
cd supervised-lda
mkdir -p build
cd build

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$EIGEN3_AND_BOOST_PREFIX_PATH;$DOCOPT_PREFIX_PATH" ..
make -j4
cd ../..



# ----------------------------------------------------------------------------
# pLDA
# notes: require MPICH
git clone https://github.com/openbigdatagroup/plda.git
cd plda
make all
cd ..



# ----------------------------------------------------------------------------
# paraLDA
# Notes : results not correct : only first word ID for each topic have counts
git clone https://github.com/bcatctr/paraLDA.git
cd paraLDA
make -j4
cd ..

cd $LDAINSTALL_PATH
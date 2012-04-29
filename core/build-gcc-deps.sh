#!/bin/bash -x
# Build deps for GCC

if [ ! "$SNOWFLAKE_BASE" ]
then
    SNOWFLAKE_BASE="$PWD"
fi

# Fail on any command failing:
set -e

. "$SNOWFLAKE_BASE"/defs.sh

# Switch to the CC prefix for all of this
PREFIX="$CC_PREFIX/$TRIPLE"

GMP_VERSION=5.0.4
MPFR_VERSION=3.1.0
MPC_VERSION=0.9

# GMP
fetchextract ftp://ftp.gmplib.org/pub/gmp-$GMP_VERSION/ gmp-$GMP_VERSION .tar.bz2
cp -f config.sub gmp-$GMP_VERSION/configfsf.sub
buildinstall '' gmp-$GMP_VERSION --host="$TRIPLE" --enable-static --disable-shared

# MPFR
fetchextract http://www.mpfr.org/mpfr-current/ mpfr-$MPFR_VERSION .tar.bz2
cp -f config.sub mpfr-$MPFR_VERSION/config.sub
buildinstall '' mpfr-$MPFR_VERSION --host="$TRIPLE" --enable-static --disable-shared CC="$TRIPLE-gcc"

# MPC
fetchextract http://www.multiprecision.org/mpc/download/ mpc-$MPC_VERSION .tar.gz
cp -f config.sub mpc-$MPC_VERSION/config.sub
buildinstall '' mpc-$MPC_VERSION --host="$TRIPLE" --enable-static --disable-shared

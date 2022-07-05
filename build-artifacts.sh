#!/usr/bin/env bash
# Builds the bios bits artifacts that are consumed by the QEMU tests. 
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author: Ani Sinha <ani@anisinha.ca>

set -e
set -x

DF=Dockerfile
TAG="bits-build"
TMP=$(mktemp -d --suffix bits-build)

cp $DF $TMP
cd $TMP

docker build \
       --rm \
       --no-cache \
       -t $TAG \
       -f $DF .

ver=$(docker run -it $TAG cat bits-version) 
ver=`echo $ver | tr -d '\r'`

id=$(docker create $TAG)
docker cp $id:/root/bits/bits-$ver.zip .
docker cp $id:/root/bits/bits-$ver-grub.tar.gz .
docker rm -v $id
docker ps -aq | xargs docker rm
docker image rm $TAG

echo "generated bios bits build artifacts are in $TMP"
echo "all done"

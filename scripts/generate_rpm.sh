#! /bin/bash

NAME="${PROJECT}-${VERSION}-1"
PREFIX="usr"
SPREFIX=${PREFIX}
SUBPREFIX="opt/${PROJECT}/${VERSION}"
SSUBPREFIX="opt\/${PROJECT}\/${VERSION}"

export PREFIX
export SUBPREFIX
export SPREFIX
export SSUBPREFIX

bash generate_tarball.sh ${NAME}.tar.gz

RPMBUILD=`realpath ~/rpmbuild/BUILDROOT/${NAME}.x86_64`
mkdir -p ${RPMBUILD} 
FILES=$(tar -xvzf ${NAME}.tar.gz -C ${RPMBUILD})
PFILES=""
for f in ${FILES[@]}; do
  if [ -f ${RPMBUILD}/${f} ]; then
    PFILES="${PFILES}/${f}\n"
  fi
done
echo -e ${PFILES} &> ~/rpmbuild/BUILD/filenames.txt

mkdir -p ${PROJECT} 
echo -e "Name: ${PROJECT} 
Version: ${VERSION}
License: MIT
Vendor: ${VENDOR} 
Source: ${URL} 
Requires: openssl-devel, gmp-devel, libstdc++-devel, bzip2, bzip2-devel, mongodb, mongodb-server
URL: ${URL} 
Packager: ${VENDOR} <${EMAIL}>
Summary: ${DESC}
Release: 1
%description
${DESC}
%files -f filenames.txt" &> ${PROJECT}.spec

rpmbuild -bb ${PROJECT}.spec
mv ~/rpmbuild/RPMS/x86_64 ./
rm -r ${PROJECT} ~/rpmbuild/BUILD/filenames.txt ${PROJECT}.spec

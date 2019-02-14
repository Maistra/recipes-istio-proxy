#!/bin/bash

set -e

VERSION=2.7
SHA256=1ee8c8699a0eff6b6a203e59b43330536b22bbcbe6448f54c7091e5efb0763c9

if [ "${FETCH}" ]; then
  if [ ! -d "gperftools-$VERSION" ]; then
    curl https://github.com/gperftools/gperftools/releases/download/gperftools-"$VERSION"/gperftools-"$VERSION".tar.gz -sLo gperftools-"$VERSION".tar.gz \
      && echo "$SHA256" gperftools-"$VERSION".tar.gz | sha256sum --check
    tar xf gperftools-"$VERSION".tar.gz
  fi
else
  cp -rf ${RECIPES_DIR}/gperftools-"$VERSION" .
  cd gperftools-"$VERSION"
  aclocal
  automake
  export LDFLAGS="${LDFLAGS} -lpthread"
  ./configure --prefix="$THIRDPARTY_BUILD" --enable-shared=no --enable-frame-pointers --disable-libunwind

  # Don't build tests, since malloc_extension_c_test hardcodes -lstdc++, which breaks build when linking against libc++.
  make V=1 install-libLTLIBRARIES install-perftoolsincludeHEADERS
fi

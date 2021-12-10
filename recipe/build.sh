#!/bin/bash

# work-around https://bitbucket.org/icl/lapackpp/issues/12
export CXXFLAGS="${CXXFLAGS} -DLAPACK_FORTRAN_ADD_"

cmake -S . -B build             \
    -DCMAKE_INSTALL_LIBDIR=lib        \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}  \
    -DCMAKE_BUILD_TYPE=Release  \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DBUILD_SHARED_LIBS=ON      \
    -Dbuild_tests=OFF           \
    ${CMAKE_ARGS} || { cat build/CMakeFiles/CMakeOutput.log; cat build/CMakeFiles/CMakeError.log; exit 1; }

cmake --build build --parallel ${CPU_COUNT}

cmake --build build --target install

#!/bin/bash

# work-around https://bitbucket.org/icl/lapackpp/issues/12
export CXXFLAGS="${CXXFLAGS} -DLAPACK_FORTRAN_ADD_"

# avoid try_run calls in cross-compilation
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
    export CMAKE_ARGS="${CMAKE_ARGS} -DLAPACK_FOUND=ON"
    export CMAKE_ARGS="${CMAKE_ARGS} -Dlapackpp_defs_=-DLAPACK_HAVE_LAPACK;-DLAPACK_VERSION=30900;-DLAPACK_HAVE_LAPACKE"
    export CMAKE_ARGS="${CMAKE_ARGS} -DLAPACK_LIBRARIES=${PREFIX}/lib/liblapack${SHLIB_EXT};blaspp"
    export CMAKE_ARGS="${CMAKE_ARGS} -Dlapack_libraries_cached=${PREFIX}/lib/liblapack${SHLIB_EXT};blaspp"
    export CMAKE_ARGS="${CMAKE_ARGS} -Dlapack_config_cache=${PREFIX}/lib/liblapack${SHLIB_EXT};blaspp"
    export CMAKE_ARGS="${CMAKE_ARGS} -Dlapack=generic"
    export CMAKE_ARGS="${CMAKE_ARGS} -Dlapack_cached=generic"
    export CMAKE_ARGS="${CMAKE_ARGS} -Dlapacke_found=ON"
    export CMAKE_ARGS="${CMAKE_ARGS} -Dlapacke_libraries=${PREFIX}/lib/liblapacke${SHLIB_EXT}"
fi
export CMAKE_ARGS="${CMAKE_ARGS} --loglevel DEBUG"

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

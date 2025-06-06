# This port needs to be updated at the same time as libbson
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mongodb/mongo-c-driver
    REF "${VERSION}"
    SHA512 6cd5bdd487d84f2f3c9224266e83055bb3b9359205526b9da89813f9c5690c8b6cccb91e4a63473455eea929f831b6f561d894aa429c01ee3dbd6694667be89a
    HEAD_REF master
    PATCHES
        disable-dynamic-when-static.patch
        fix-dependencies.patch
        fix-include-directory.patch
        fix-mingw.patch
        remove_abs_patch.cmake
)
file(WRITE "${SOURCE_PATH}/VERSION_CURRENT" "${VERSION}")
file(TOUCH "${SOURCE_PATH}/src/utf8proc-editable")
file(GLOB vendored_libs "${SOURCE_PATH}/src/utf8proc-*" "${SOURCE_PATH}/src/zlib-*/*.h")
file(REMOVE_RECURSE ${vendored_libs})

# Cannot use string(COMPARE EQUAL ...)
set(ENABLE_STATIC OFF)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(ENABLE_STATIC ON)
endif()

vcpkg_check_features(OUT_FEATURE_OPTIONS OPTIONS
    FEATURES
        snappy      ENABLE_SNAPPY
        zstd        ENABLE_ZSTD
)

if("openssl" IN_LIST FEATURES)
    list(APPEND OPTIONS -DENABLE_SSL=OPENSSL)
elseif(VCPKG_TARGET_IS_WINDOWS)
    list(APPEND OPTIONS -DENABLE_SSL=WINDOWS)
elseif(VCPKG_TARGET_IS_OSX OR VCPKG_TARGET_IS_IOS)
    list(APPEND OPTIONS -DENABLE_SSL=DARWIN)
else()
    list(APPEND OPTIONS -DENABLE_SSL=OFF)
endif()

if(VCPKG_TARGET_IS_ANDROID)
    vcpkg_list(APPEND OPTIONS -DENABLE_SRV=OFF)
endif()

vcpkg_find_acquire_program(PKGCONFIG)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        ${OPTIONS}
        "-DBUILD_VERSION=${VERSION}"
        -DUSE_BUNDLED_UTF8PROC=OFF
        -DUSE_SYSTEM_LIBBSON=ON
        -DENABLE_CLIENT_SIDE_ENCRYPTION=OFF
        -DENABLE_EXAMPLES=OFF
        -DENABLE_SASL=OFF
        -DENABLE_SHM_COUNTERS=OFF
        -DENABLE_STATIC=${ENABLE_STATIC}
        -DENABLE_TESTS=OFF
        -DBUILD_TESTING=OFF
        -DENABLE_UNINSTALL=OFF
        -DENABLE_ZLIB=SYSTEM
        "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}"
    MAYBE_UNUSED_VARIABLES
        PKG_CONFIG_EXECUTABLE
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

if("snappy" IN_LIST FEATURES AND VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libmongoc-static-1.0.pc" " -lSnappy::snappy" "")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libmongoc-static-1.0.pc" "Requires: " "Requires: snappy ")
    if(NOT VCPKG_BUILD_TYPE)
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libmongoc-static-1.0.pc" " -lSnappy::snappy" "")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libmongoc-static-1.0.pc" "Requires: " "Requires: snappy ")
    endif()
endif()
vcpkg_fixup_pkgconfig()

# deprecated
vcpkg_cmake_config_fixup(PACKAGE_NAME libmongoc-1.0 CONFIG_PATH "lib/cmake/libmongoc-1.0" DO_NOT_DELETE_PARENT_CONFIG_PATH)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    vcpkg_cmake_config_fixup(PACKAGE_NAME libmongoc-static-1.0 CONFIG_PATH "lib/cmake/libmongoc-static-1.0" DO_NOT_DELETE_PARENT_CONFIG_PATH)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/mongoc/mongoc-macros.h"
        "#define MONGOC_MACROS_H" "#define MONGOC_MACROS_H\n#ifndef MONGOC_STATIC\n#define MONGOC_STATIC\n#endif")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/libmongoc-1.0/libmongoc-1.0-config.cmake" "mongoc_shared" "mongoc_static")
endif()
# recommended
vcpkg_cmake_config_fixup(PACKAGE_NAME mongoc-1.0 CONFIG_PATH "lib/cmake/mongoc-1.0")

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION  "${CURRENT_PACKAGES_DIR}/share/${PORT}")

vcpkg_install_copyright(
    FILE_LIST
        "${SOURCE_PATH}/COPYING"
        "${SOURCE_PATH}/THIRD_PARTY_NOTICES"
        "${SOURCE_PATH}/src/libmongoc/THIRD_PARTY_NOTICES"
)

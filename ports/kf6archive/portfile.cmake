vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/KArchive
    REF ba9cc0de5c86809ec0a4ef6a7dd683932c64ba32
    SHA512 2d3bd5474dd719b4a00b34d655a3558f312ee41fdad3b25b05e5704644a782a1dd1f88a58819ba53054b493272317186d1c559714f92375fa444fbcea3a37114
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        WITH_BZIP2=ON
        WITH_LIBLZMA=ON
        WITH_OPENSSL=ON
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/kf6archive)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/INSTALL" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)
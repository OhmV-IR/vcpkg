# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/variant2
    REF boost-${VERSION}
    SHA512 dde14a2adebde9e3827bfd2e7b0f2a8bf9e9099794bd0de09a51b01ab2d981f18c773acd786cd46ea243c85a442533177cb3657da525a641d2ccf189ab33dfc6
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)

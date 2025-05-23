# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/bimap
    REF boost-${VERSION}
    SHA512 ccb9b7c6a6c81cca5756a2e4ff594d3172558784efc1520a182dcad7f9a79180c34921fb6b90772594f6d2a5a7d65f0557a617dc7e9dc0ce96db9ce6f3a9c808
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)

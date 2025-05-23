# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/xpressive
    REF boost-${VERSION}
    SHA512 c962f39a7055894a4172f0afa75092375de7be31ab89bdf2e8678bd147eaea8f2914093a71832d93eee40ef7c6241c7c44e95e6d41110c95124d7c6241178b43
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)

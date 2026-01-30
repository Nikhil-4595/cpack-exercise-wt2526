# Basic package information
set(CPACK_PACKAGE_NAME "cpackexample")
set(CPACK_PACKAGE_VENDOR "Nikhil / University Of Stuttgart")
set(CPACK_PACKAGE_CONTACT "n.k.2449837@gmail.com")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "Finite Element / Boost / YAML example packaged with CPack"
)

# Debian wants an extended description (not empty)
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION
"Finite element demo application

 This package contains a small FEM-based example using deal.II, Boost
 and yaml-cpp, packaged with CMake and CPack for the SSE exercise."
)

# Version
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})

# Homepage / project URL (your fork)
set(CPACK_PACKAGE_HOMEPAGE_URL
    "https://github.com/Nikhil-4595/cpack-exercise-wt2526"
)

# Only create TGZ and DEB binaries
set(CPACK_GENERATOR "TGZ;DEB")

# Install into /usr so binary ends up in /usr/bin, etc.
set(CPACK_PACKAGING_INSTALL_PREFIX "/usr")

# Debian-specific fields
# Lintian wants a 'phrase' (Name <email>) as maintainer
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Nikhil <${CPACK_PACKAGE_CONTACT}>")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE   "${CPACK_PACKAGE_HOMEPAGE_URL}")
set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)

# Strip binaries in packages -> fixes 'unstripped-binary-or-object'
set(CPACK_STRIP_FILES YES)

# Let Debian tools detect shared-library dependencies
# -> fixes 'undeclared-elf-prerequisites' and adds proper Depends:
set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS YES)

# Enable CPack
include(CPack)

#!/bin/bash
version=$1
version=${version:-$(git describe --tags | grep -o '[0-9].[0-9].[0-9]')}
mkdir -p install/usr/local
mkdir -p install/DEBIAN

cd install/DEBIAN

(cat << EOF
Package: libwebsockets
Version: ${version}
Section: X11
Priority: optional
Depends: libssl-dev, openssl
Architecture: amd64
Maintainer: oyoung
CopyRight: community
Provider: Jeans Oyoung
Description: WebSocket C Library
EOF
) > control

(cat << EOF
#!/bin/bash
EOF
) > preinst
(cat << EOF
#!/bin/bash
EOF
) > postinst
(cat << EOF
#!/bin/bash
EOF
) > prerm
(cat << EOF
#!/bin/bash
EOF
) > postrm
chmod +x preinst postinst prerm postrm

cd ../..

cmake -Bbuild -H. -DCMAKE_INSTALL_PREFIX=install/usr/local
cmake --build build --target install

sed 's|^prefix=".*"|prefix="/usr/local"|' -i install/usr/local/lib/pkgconfig/libwebsockets.pc
sed 's|^prefix=".*"|prefix="/usr/local"|' -i install/usr/local/lib/pkgconfig/libwebsockets_static.pc

fakeroot dpkg -b install libwebsockets_${version}_amd64.deb || exit 1
rm -rf install

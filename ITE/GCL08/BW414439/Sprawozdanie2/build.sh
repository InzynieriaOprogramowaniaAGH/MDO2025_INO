#!/bin/bash

dh_make --single --createorig -c gpl3 --email "bw@example.com" --yes

cat << 'EOF' > debian/rules
#!/usr/bin/make -f

%:
	dh \$@ --buildsystem=meson
EOF

chmod +x debian/rules

debuild -us -uc

mv ../*.deb /out

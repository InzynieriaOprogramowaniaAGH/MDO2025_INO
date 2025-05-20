Name:           cjson
Version:        1.7.15
Release:        1%{?dist}
Summary:        Ultralight JSON parser in ANSI C

License:        MIT
URL:            https://github.com/DaveGamble/cJSON
Source0:        cjson.tar.gz

BuildRequires:  cmake gcc make
Requires:       glibc

%description
Ultralight JSON parser written in ANSI C. Easy to integrate, lightweight, and portable.

%prep
%setup -q -n cJSON

%build
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make

%install
cd build
make DESTDIR=%{buildroot} install

# Uporządkuj nagłówki zgodnie z <cjson/cJSON.h>
mkdir -p %{buildroot}%{_includedir}/cjson
mv %{buildroot}%{_includedir}/cJSON.h %{buildroot}%{_includedir}/cjson/cJSON.h

%files
%{_libdir}/libcjson.so*
%{_includedir}/cjson/cJSON.h

%changelog
* 2025-05-20 Meg Paskowski <mpaskowski@example.com> - 1.7.15-1
- Initial release with corrected library and include paths

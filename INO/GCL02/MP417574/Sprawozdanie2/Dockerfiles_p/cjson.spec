Name:           cjson
Version:        1.7.15
Release:        1%{?dist}
Summary:        Ultralight JSON parser in ANSI C

License:        MIT
URL:            https://github.com/DaveGamble/cJSON
Source0:        cjson.tar.gz

BuildRequires:  cmake gcc make
Requires:       gcc

%description
Ultralight JSON parser written in ANSI C. Easy to integrate, lightweight, and portable.

%prep
%setup -q -n cJSON

%build
mkdir build && cd build
cmake ..
make

%install
mkdir -p %{buildroot}/usr/lib
cp build/libcjson.so %{buildroot}/usr/lib/

mkdir -p %{buildroot}/usr/include
cp cJSON.h %{buildroot}/usr/include/

%files
/usr/lib/libcjson.so
/usr/include/cJSON.h

%changelog
* 2025 Meg Paskowski <mpaskowski@example.com>
- Initial RPM release of cJSON
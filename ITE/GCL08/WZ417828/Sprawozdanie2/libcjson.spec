Name:           libcjson
Version:        1.7.18
Release:        1
Summary:        cJSON library
License:        MIT
URL:            https://github.com/DaveGamble/cJSON
BuildArch:      x86_64

Source0:        libcjson.so.1.7.18
Source1:        cJSON.h

%description
cJSON is a JSON parser and generator in C.

%prep
# brak rozpakowywania — pliki są już w SOURCES

%build
# brak kompilacji — biblioteka jest już skompilowana

%install
mkdir -p %{buildroot}/usr/lib64
mkdir -p %{buildroot}/usr/include

cp %{_sourcedir}/libcjson.so.1.7.18 %{buildroot}/usr/lib64/
ln -sf libcjson.so.1.7.18 %{buildroot}/usr/lib64/libcjson.so.1
ln -sf libcjson.so.1        %{buildroot}/usr/lib64/libcjson.so

cp %{_sourcedir}/cJSON.h    %{buildroot}/usr/include/

%files
/usr/lib64/libcjson.so*
/usr/include/cJSON.h

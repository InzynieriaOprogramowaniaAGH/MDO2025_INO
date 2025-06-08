Name:           libcjson
Version:        1.7.18
Release:        1
Summary:        cJSON library
License:        MIT
URL:            https://github.com/DaveGamble/cJSON
BuildArch:      x86_64

# Pliki, które wcześniej skopiujesz do RPMBUILD/SOURCES
Source0:        libcjson.so.1.7.18
Source1:        cJSON.h

%description
cJSON is a JSON parser and generator in C.

%prep
# brak rozpakowywania — pliki są już w SOURCES

%build
# brak kompilacji — biblioteka jest już skompilowana

%install
# Tworzymy strukturę instalacyjną
mkdir -p %{buildroot}/usr/lib64
mkdir -p %{buildroot}/usr/include

# Kopiujemy bibliotekę i tworzymy dowiązania
cp %{_sourcedir}/libcjson.so.1.7.18 %{buildroot}/usr/lib64/
ln -sf libcjson.so.1.7.18 %{buildroot}/usr/lib64/libcjson.so.1
ln -sf libcjson.so.1        %{buildroot}/usr/lib64/libcjson.so

# Kopiujemy nagłówek
cp %{_sourcedir}/cJSON.h    %{buildroot}/usr/include/

%files
/usr/lib64/libcjson.so*
/usr/include/cJSON.h

%changelog
- Adapted spec to Jenkins pipeline (no tarball, using SOURCES copy)
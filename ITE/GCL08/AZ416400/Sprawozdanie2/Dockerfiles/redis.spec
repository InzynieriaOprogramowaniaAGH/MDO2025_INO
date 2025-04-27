Name:           redis
Version:        7.2.0
Release:        1%{?dist}
Summary:        Redis server built externally

License:        BSD
URL:            https://redis.io/
Source0:        redis-7.2.0.tar.gz

BuildArch:      x86_64

%define debug_package %{nil}

%description
Redis packaged from precompiled binaries.

%prep
%setup -q

%build

%install
mkdir -p %{buildroot}/usr/local/bin
install -m 0755 redis-server %{buildroot}/usr/local/bin/redis-server
install -m 0755 redis-cli %{buildroot}/usr/local/bin/redis-cli

%files
/usr/local/bin/redis-server
/usr/local/bin/redis-cli

%changelog
* Sun Apr 27 2025 - 7.2.0
- Packaged redis-server and redis-cli binaries into RPM

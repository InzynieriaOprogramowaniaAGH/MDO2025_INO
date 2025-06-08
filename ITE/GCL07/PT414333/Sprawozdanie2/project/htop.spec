%define name htop
%define version 3.3.0

Name:           %{name}
Version:        %{version}
Release:        1%{?dist}
Summary:        Interactive process viewer

License:        GPL-2.0-or-later

%description
htop is an interactive process viewer.  It is a text-mode application
and requires ncurses.

%prep
%autosetup

%build
%configure
%make_build

%install
%make_install

%files
%{_bindir}/htop
%{_mandir}/man1/htop.1.gz
/usr/share/applications/htop.desktop
/usr/share/icons/hicolor/scalable/apps/htop.svg
/usr/share/pixmaps/htop.png

%changelog
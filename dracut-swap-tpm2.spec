Name:       dracut-swap-tpm2
Version:    0.0.1
Release:    1%{?dist}
Summary:    TPM2-backed swap space encryption with hibernation support
License:    GPL
BuildArch:  noarch
Source0:    .


Requires:   dracut
Requires:   tpm2-tools
Requires:   cryptsetup
Requires:   util-linux

BuildRequires: gettext-envsubst

%define _topdir ./rpmbuild

%description
TPM2-backed swap space encryption with hibernation support

%prep

%install
rm -rf $RPM_BUILD_ROOT
cd %{_sourcedir}
make DESTDIR="$RPM_BUILD_ROOT/%{_prefix}/.." install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_prefix}/lib/dracut/modules.d/80swap-tpm2
%{_bindir}/tpm2-rotate-swapkey
%{_prefix}/lib/systemd/system/tpm2-rotate-swapkey.service

%changelog
* Thu Oct   1 2026 Karim Vergnes <me@thesola.io> - 0.0.1
- First package version

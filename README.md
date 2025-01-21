
<div align="center">
  <span align="center"> <img width="128" height="128" class="center" src="https://github.com/ellie-commons/jort/blob/main/data/icons/128/io.github.ellie_commons.jort.svg" alt="Jort icon - a sticky note"></span>
  <h1 align="center">Jort</h1>
  <h3 align="center">Neither pants nor shorts, just like jorts. A sticky notes app for elementary OS</h3>
</div>

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/io.github.ellie_commons.jort)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

## Donations

Most of the code was from Lainsce. This is from an old version of jort

[Be a backer on Lainsce on Patreon](https://www.patreon.com/lainsce)

## Dependencies

Please make sure you have these dependencies first before building.

```bash
granite
gtk+-3.0
gtksourceview-3.0
libjson-glib
libgee-0.8
meson
vala
```

You can

```bash
sudo apt install granite gtksourceview-3.0 libjson-glib libgee-0.8 meson vala
```

## Building

Simply clone this repo, then:

```bash
meson build && cd build
meson configure -Dprefix=/usr
sudo ninja install
```

or
```bash
flatpak-builder --force-clean --user --install-deps-from=appcenter --repo=repo --install builddir ./io.github ellie_commons.jort.yaml
```

## Notes Storage
Notes are stored in `~/.local/share/io.github.ellie_commons.jort/`

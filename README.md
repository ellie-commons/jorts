
<div align="center">
  <img alt="An icon representing a stack of little squared blue sticky notes. The first one, and the second one hinted below, have scribbles over them" src="data/icons/hicolor/128.png" />
  <h1>Jorts</h1>
  <h3>Neither jeans nor shorts, just like jorts. A sticky notes app for elementary OS</h3>
<span align="center"> <img class="center" src="https://github.com/ellie-commons/jorts/blob/main/data/screenshots/default.png" alt="A blue sticky note"></span>
</div>

  <a href="https://elementary.io">
    <img src="https://ellie-commons.github.io/community-badge.svg" alt="Made for elementary OS">
  </a>

<br/>

## Installation

You can download and install Jorts from various sources:

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg?new)](https://appcenter.elementary.io/io.github.ellie_commons.jorts) 
[<img src="https://flathub.org/assets/badges/flathub-badge-en.svg" width="160" alt="Download on Flathub">](https://flathub.org/apps/io.github.ellie_commons.jorts)

## 🛣️ Roadmap

Jorts is a cute simple little notes app, and i wanna keep it this way

right now im working on:
- Maybe an option to show window title buttons, because now this is on flathub i may get flak from users about the lack of it
- Probably some cleaner code if i come around to it
- Maybe a toggle lists if i find how to do it without more UI noise

Feel free to check [the project board](https://github.com/orgs/ellie-commons/projects/4)

## 💝 Donations

On the right you can donate to various contributors:
 - teamcons, the main devs and maintainers behind jorts
 - wpkelso, the author of the modern icon and its Pride variant
 - lains, the initial creator of the app (It was Notejot, now something very different)


## 🏗️ Building

Installation is as simple as installing the above, downloading and extracting the zip archive, changing to the new repo's directory,
and run the following command:

On elementary OS or with its appcenter remote installed

```bash
flatpak-builder --force-clean --user --install-deps-from=appcenter --install builddir ./io.github.ellie_commons.jorts.yml
```

On other systems:

```bash
flatpak run org.flatpak.Builder --force-clean --sandbox --user --install --install-deps-from=flathub --ccache --mirror-screenshots-url=https://dl.flathub.org/media/ --repo=repo builddir io.github.ellie_commons.jorts.flathub.yml
```


## 💾 Notes Storage

Notes are stored in `~/.var/app/io.github.ellie_commons.jorts/data`

You can get it all by entering in a terminal:

```bash
cp ~/.var/app/io.github.ellie_commons.jorts/data ~/
```

"saved_state.json" contains all notes in JSON format. "backup_state.json" is a monthly backup of it.

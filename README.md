
<div align="center">
  <img alt="An icon representing a stack of little squared blue sticky notes. The first one, and the second one hinted below, have scribbles over them" src="data/icons/default/hicolor/128.png" />
  <h1>Jorts</h1>
  <h3>Neither jeans nor shorts, just like jorts. A sticky notes app for elementary OS</h3>

  <a href="https://elementary.io">
    <img src="https://ellie-commons.github.io/community-badge.svg" alt="Made for elementary OS">
  </a>
  
<span align="center"> <img class="center" src="https://github.com/ellie-commons/jorts/blob/main/data/screenshots/spread.png" alt="Several colourful sticky notes in a spread. Most are covered in scribbles. One in forefront is blue and has the text 'Lovely little colourful squares for all of your notes! 🥰'"></span>
</div>

<br/>

## 🦺 Installation

You can download and install Jorts from various sources:

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg?new)](https://appcenter.elementary.io/io.github.ellie_commons.jorts) 
[<img src="https://flathub.org/assets/badges/flathub-badge-en.svg" width="160" alt="Download on Flathub">](https://flathub.org/apps/io.github.ellie_commons.jorts)

## ❓ FAQ

### Where settings

- Right-click on the app icon, and it is in the menu that appears
- You can also Ctrl+P to show the dialog
- Or run in a terminal:

```bash
flatpak run io.github.ellie_commons.jorts --preferences
```


### Where tray icon

Theres none. The app closes on its own when no window is open. Doesn't make sense to use resources if unused.

If you want to quit everything at once, use Ctrl+Q


### Where close note

Theres none. If you dont need a note you delete it, theyre supposed to be ephemeral.
You can still alt+F4 or right-click->Close, but there is no reopen mechanism, and i dont wanna make one. Everything shows upon reopening the app anyway


### Where Bold/Italic/etc

I really want to avoid UI noise and resource usage. Notes are just, notes. The more complicated they become the less they are ephemeral notes and the more this looks like some notekeeping app. Which is what NoteJot, this was forked from, became.
Now i know i added some stuff when maintaining the old version of NoteJot, but it doesn't mean it should have more, or everything.



## 🛣️ Roadmap

Jorts is a cute simple and lightweight little notes app, and i wanna keep it this way
Top priority is to have the clearest, simplest, most efficient code ever



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

"saved_state.json" contains all notes in JSON format. The structure is quite simple, if not pretty.

The app reads from it only during startup (rest of the time it writes in) so you could quite easily swap it up to swap between sets of notes.

# Code Structure

Each Note is an instance of MainWindow initiated by Application.
Each Note is responsible for its own storage and theming
Components should be as stupidly simple as possible.

### MainWindow
Said MainWindow/Note has:
 - A Headerbar with an editable label
 - A Sourceview/Sourcebuffer, where all the text happes
 - An ActionBar, with buttons and a popover

### Services
Each Note relies on the following supporting services:
 - Stash, which provides the storage utilities. Each Note is responsible for saving itself
 - Themer, to build the themes
 - Utils, which provides small functions that are better in a clean separate place instead of drown in the code.

TODO:
  - Stash should replace Storage
  - NoteManager complements Storage, and should be replaced too.

### Widgets
Each Note is built with the following custom widgets:
 - ColorPill, which is not plumbed in yet but would be the buttons to theme a note on popover
 - EditableLabel, in GTK3 a custom Widget, in GTK4 should be the GTK one extended for the app
 - SettingsPopover, which should be the thing with the settings (mostly the ColorPills), which is not plumbed in yet.

TODO: ColorPill and SettingsPopover


### Resources
Application.css includes all nonspecific css

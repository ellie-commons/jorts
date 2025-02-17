# Code Structure
Each Note is an instance of MainWindow initiated by Application.
Components should be as stupidly simple as possible.

### MainWindow
Each Note has:
 - A Headerbar with an editable label
 - A Sourceview/Sourcebuffer, where all the text happen
 - An ActionBar, with buttons and a popover

### Services
Each Note relies on the following supporting services:
 - Stash, which manage saving and loading operations
 - Themer, which manage theming
 - Utils, which provides various utilities

### Widgets
Each Note is built with the following custom widgets:
 - ColorPill, which is not plumbed in yet but would be the buttons to theme a note on popover
 - EditableLabel, in GTK3 a custom Widget, in GTK4 should be the GTK one extended for the app
 - SettingsPopover, which is the menu with settings.

### Resources
Application.css includes all nonspecific css
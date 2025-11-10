sources = files (
    'Objects' / 'Zoomkind.vala',
    'Objects' / 'Zoom.vala',
    'Objects' / 'Themes.vala',
    'Objects' / 'NoteData.vala',

    'Utils' / 'Random.vala',

    'Services' / 'Constants.vala',
    'Services' / 'Storage.vala',
    'Services' / 'NoteManager.vala',
    'Services' / 'Themer.vala',
    'Services' / 'ZoomController.vala',

    'Widgets' / 'EditableLabel.vala',
    'Widgets' / 'TextView.vala',
    'Widgets' / 'ActionBar.vala',

    'Widgets' / 'PopoverWidgets' / 'ColorPill.vala',
    'Widgets' / 'PopoverWidgets' / 'ColorBox.vala',
    'Widgets' / 'PopoverWidgets' / 'MonospaceBox.vala',
    'Widgets' / 'PopoverWidgets' / 'ZoomBox.vala',

    'Views' / 'PopoverView.vala',
    'Views' / 'PreferencesView.vala',
    'Views' / 'NoteView.vala',

    'Windows' / 'PreferenceWindow.vala',
    'Windows' / 'StickyNoteWindow.vala',

    'Application.vala',
)

if windows_build
    sources += ico_src
else
    sources += files('Utils' / 'Libportal.vala')
endif

#================================
# Let's define our executable
# win_subsystem doesnt seem to bother standard builds

executable(
    meson.project_name(),
    gresource,
    config_file,
    sources,
    dependencies: dependencies,
    win_subsystem: 'windows',
    install : true
)

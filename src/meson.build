sources = files (
    'Objects' / 'Zoomkind.vala',
    'Objects' / 'Themes.vala',
    'Objects' / 'NoteData.vala',

    'Utils' / 'ZoomConvert.vala',
    'Utils' / 'Random.vala',
    'Utils' / 'Libportal.vala',

    'Services' / 'Constants.vala',
    'Services' / 'Storage.vala',
    'Services' / 'NoteManager.vala',
    'Services' / 'Themer.vala',

    'Widgets' / 'TextView.vala',
    'Widgets' / 'ColorPill.vala',
    'Widgets' / 'ColorBox.vala',
    'Widgets' / 'ZoomBox.vala',
    'Widgets' / 'MonospaceBox.vala',

    'Views' / 'PopoverView.vala',
    'Views' / 'PreferencesView.vala',
    'Views' / 'NoteView.vala',

    'Windows' / 'PreferenceWindow.vala',    
    'Windows' / 'StickyNoteWindow.vala',

    'Application.vala',
)

#================================
# Let's define our executable
executable(
    meson.project_name(),
    gresource,
    config_file,
    sources,
    dependencies: dependencies,
    install : true
)

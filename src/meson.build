
sources = [
    'Objects/NoteData.vala', 

    'Services/Constants.vala',
    'Services/Jason.vala',
    'Services/Stash.vala',
    'Services/Themer.vala',
    'Services/Utils.vala',

    'Widgets/StickyView.vala',
    'Widgets/ColorPill.vala',
    'Widgets/ColorBox.vala',

    'Views/PopoverView.vala',
    'Views/PreferencesView.vala',

    'Application.vala',
    'Preferences.vala',    
    'StickyNoteWindow.vala',
]

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
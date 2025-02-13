# Name our project
project('io.github.ellie_commons.jorts', ['vala', 'c'],
    version: '2.0.0'
)

gnome = import('gnome')
gnome.post_install(glib_compile_schemas: true)



#================================
# Import the stylesheet

# Le stylesheet
gresource = gnome.compile_resources(
    'gresource',
    'data' / 'io.github.ellie_commons.jorts.gresource.xml',
    source_dir: 'data'
)

#================================
# Include the translations module
i18n = import('i18n')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')



#================================
# Let's define our executable
executable(
    meson.project_name(),
    gresource,
    'src/Objects/noteData.vala',    
    'src/Services/Stash.vala',
    'src/Services/Themer.vala',
    'src/Services/Utils.vala',
    'src/Widgets/EditableLabel.vala',
    'src/Widgets/ColorPill.vala',
    'src/Widgets/SettingsPopover.vala',
    'src/Application.vala',
    'src/MainWindow.vala',
    dependencies: [
        dependency('granite'),
        dependency('gobject-2.0'),
        dependency('gtksourceview-3.0'),
        dependency('json-glib-1.0'),
        dependency('gee-0.8'),
        dependency('gtk+-3.0')
    ],
    install : true
)


#================================
# 



# Add subfolders for Meson to look
subdir('data')
subdir('po')

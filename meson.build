# Name our project
project('io.github.ellie_commons.jorts', ['vala', 'c'],
    version: '3.1.3'
)

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')


#================================
# Import the stylesheet

## Set de config data
config_data = configuration_data()
config_data.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

# Le stylesheet
gresource = gnome.compile_resources(
    'gresource',
    'data' / 'io.github.ellie_commons.jorts.gresource.xml',
    source_dir: 'data'
)


#================================
# Let's define our executable
executable(
    meson.project_name(),
    gresource,
    config_file,
    'src/Objects/noteData.vala', 

    'src/Services/Constants.vala',
    'src/Services/Jason.vala',
    'src/Services/Stash.vala',
    'src/Services/Themer.vala',
    'src/Services/Utils.vala',

    'src/Widgets/StickyView.vala',
    'src/Widgets/ColorPill.vala',
    'src/Widgets/ColorBox.vala',
    'src/Widgets/SettingsPopover.vala',

    'src/Application.vala',
    'src/Preferences.vala',    
    'src/MainWindow.vala',
    dependencies: [
        dependency('granite-7'),
        dependency('gobject-2.0'),
        dependency('json-glib-1.0'),
        dependency('gee-0.8'),
        dependency('gtk4')
    ],
#   win_subsystem: 'windows',
    install : true
)
# ,
#   win_subsystem: 'windows',

#================================


# Add subfolders for Meson to look
subdir('data')
subdir('po')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true
  )

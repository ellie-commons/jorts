# Name our project
project('io.github.teamcons.jort', ['vala', 'c'],
    version: '2.0.0'
)

# Import main lib files
gnome = import('gnome')
i18n = import('i18n')

# Set this for convenience
conf = configuration_data()

# Get the package data directory under Meson
pkgdatadir = join_paths([ get_option('prefix'),
                          get_option('datadir'),
                          'io.github.teamcons.jort' ])

conf.set_quoted('PKGDATADIR', pkgdatadir)

# Other configs
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf
add_global_arguments('-DDATADIR="' + get_option('datadir') + '"', language: 'c')
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')


gresource = gnome.compile_resources(
    'as-resources',
    'data' / 'io.github.teamcons.jort.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)


# Arguments for C
c_args = [
  '-include', 'config.h',
  '-w'
]

cc = meson.get_compiler('c')

# Let's define our executable
executable(
    meson.project_name(),
    gresource,
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Widgets/EditableLabel.vala',
    'src/Services/NoteManager.vala',
    'src/Services/Storage.vala',
    c_args: c_args,
    dependencies: [
        dependency('granite'),
        dependency('gobject-2.0'),
        dependency('gtksourceview-3.0'),
        dependency('json-glib-1.0'),
        dependency('gee-0.8'),
        dependency('gtk+-3.0')
    ],
    vala_args: [
        meson.source_root() + '/vapi/config.vapi',
        '--vapidir=' + meson.source_root() + '/vapi/',
    ],
    install : true
)

# Add in a post install script
meson.add_install_script(meson.source_root() + '/meson/post_install.py')

# Add subfolders for Meson to look
subdir('data')
subdir('po')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true,
)

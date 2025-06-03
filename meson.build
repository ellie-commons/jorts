# Name our project
project('io.github.ellie_commons.jorts', ['vala', 'c'],
    version: '3.2.1'
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

dependencies = [
        dependency('granite-7'),
        dependency('gobject-2.0'),
        dependency('json-glib-1.0'),
        dependency('gee-0.8'),
        dependency('gtk4')
    ]



#================================


# Add subfolders for Meson to look
subdir('data')
subdir('po')
subdir('src')


gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true
  )

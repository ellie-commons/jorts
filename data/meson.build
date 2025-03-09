
#======== Internationalization ========
#Translate and install our .desktop file
i18n.merge_file(
    input: 'io.github.ellie_commons.jorts.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: meson.project_source_root() / 'po',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications'
)

#Translate and install our .appdata file
i18n.merge_file(
    input: 'io.github.ellie_commons.jorts.metainfo.xml.in',
    output: meson.project_name() + '.metainfo.xml',
    po_dir: meson.project_source_root() / 'po',
    install: true,
    install_dir: get_option('datadir') / 'metainfo'
)


#======== ICONS ========

# Install our icons in all the required sizes
icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        'icons' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: meson.project_name() + '.svg'
    )
    install_data(
        'icons' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: meson.project_name() + '.svg'
    )
endforeach


#======== SETTINGS ========
install_data (
    'io.github.ellie_commons.jorts.gschema.xml',
    install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
    rename: meson.project_name() + '.gschema.xml'
)
/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2025 Stella (teamcons.carrd.co) and the Ellie_Commons community (github.com/ellie-commons/)
 */

 public class Jorts.PopoverView : Gtk.Box {

    public Gtk.Button zoom_out_button;
    public Gtk.Button zoom_in_button;
    public Gtk.Button zoom_default_button;
    public Jorts.ColorBox color_button_box;
    public string theme {get; set;}

    construct {

        orientation = VERTICAL;
        spacing = 12;
        margin_top = 12;
        margin_bottom = 12;

        color_button_box = new Jorts.ColorBox () {
            theme = theme,
            margin_start = 12,
            margin_end = 12
        };

        zoom_out_button = new Gtk.Button.from_icon_name ("zoom-out-symbolic") {
            tooltip_markup = Granite.markup_accel_tooltip (
                Jorts.Constants.ACCELS_ZOOM_OUT,
                _("Zoom out")
                )
            };

        zoom_default_button = new Gtk.Button () {
            tooltip_markup = Granite.markup_accel_tooltip (
                Jorts.Constants.ACCELS_ZOOM_DEFAULT,
                _("Default zoom level")
                )
            };

        zoom_in_button = new Gtk.Button.from_icon_name ("zoom-in-symbolic") {
            tooltip_markup = Granite.markup_accel_tooltip (
                Jorts.Constants.ACCELS_ZOOM_IN,
                _("Zoom in")
                )
            };


        var font_size_box = new Gtk.Box (HORIZONTAL, 0) {
            homogeneous = true,
            hexpand = true,
            margin_start = 12,
            margin_end = 12
        };

        font_size_box.append (this.zoom_out_button);
        font_size_box.append (this.zoom_default_button);
        font_size_box.append (this.zoom_in_button);
        font_size_box.add_css_class (Granite.STYLE_CLASS_LINKED);

        /*
            APPENDS
        */

        append (color_button_box);
        append (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        append (font_size_box);

        show ();

    }
}

/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2017-2024 Lains
 * SPDX-FileCopyrightText: 2025 Stella & Charlie (teamcons.carrd.co)
 * SPDX-FileCopyrightText: 2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


 public class Jorts.PopoverView : Gtk.Popover {

    public Jorts.ColorBox color_button_box;
    public Gtk.Button zoom_in_button;
    public Gtk.Button zoom_default_button;
    public Gtk.Button zoom_out_button;

    public string theme {get; set;}
    public int zoom {get; set;}


        /* THEME SELECTION */
    public string selected;
    public signal void theme_changed (string selected);


    /* FONT SELECTION */
    public signal void zoom_changed (string zoomkind);



    construct {

        set_position (Gtk.PositionType.TOP);
        set_halign (Gtk.Align.END);

        var everything = new Gtk.Box (VERTICAL, 12) {
            margin_top = 12,
            margin_bottom = 12
        };


        color_button_box = new Jorts.ColorBox ();

        ///TRANSLATORS: These are displayed on small linked buttons in a menu. User can click them to change zoom
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

        font_size_box.append (zoom_out_button);
        font_size_box.append (zoom_default_button);
        font_size_box.append (zoom_in_button);
        font_size_box.add_css_class (Granite.STYLE_CLASS_LINKED);

        /* APPENDS */

        everything.append (color_button_box);
        everything.append (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        everything.append (font_size_box);

        set_child (everything);



        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        color_button_box.theme_changed.connect ((selected) => {this.theme_changed (selected);});

        // Emit a signal when a button is toggled that will be picked by StickyNoteWindow
        zoom_out_button.clicked.connect (() => {this.zoom_changed ("zoom_out");});
        zoom_default_button.clicked.connect (() => {this.zoom_changed ("reset");});
        zoom_in_button.clicked.connect (() => {this.zoom_changed ("zoom_in");});


    }


    // Called by the StickyNoteWindow when adjusting to new zoomlevel
    // StickyNoteWindow reacts to a signal by the popover
    public void on_zoom_changed (int zoom) {

        //TRANSLATORS: %d is replaced by a number. Ex: 100, to display 100%
        //It must stay as "%d" in the translation so the app can replace it with the current zoom level.
        var label = _("%d%%").printf (zoom);
        zoom_default_button.set_label (label);
    }



}

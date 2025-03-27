/*
* Copyright (c) 2017-2024 Lains
* Copyright (c) 2025 Stella (teamcons on GitHub) and the Ellie_Commons community
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

/* I just dont wanna clutter my mainwindow, damn.
So the whole settings popover is here, deal with it.

>Grid
->Label notecolor
->GtkBox
-->Lots of ColorPills


*/


public class jorts.SettingsPopover : Gtk.Popover {


    /* THEME SELECTION */

    public string selected;
    public signal void theme_changed (string selected);


    /* FONT SELECTION */
    public Gtk.Button zoom_out_button;
    public Gtk.Button zoom_in_button;
    public Gtk.Button zoom_default_button;

    public signal void zoom_changed (string zoomkind);



    public SettingsPopover (string theme) {

        this.set_position (Gtk.PositionType.TOP);
        this.set_halign (Gtk.Align.END);

        // Everything is in this
        var setting_grid = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            margin_top = 12,
            margin_bottom = 12
        };



        /* 
            THEME SELECTION
        */

        
        //  //TRANSLATORS: The label is displayed above colored pills the user can click to choose a theme color
        //  var color_button_label = new Granite.HeaderLabel (_("Sticky Note Colour"));
        //  color_button_label.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);
        //  color_button_label.tooltip_text = _("Choose a colour for this sticky note");
        //  color_button_label.margin_top = 9;

        //setting_grid.append (color_button_label);


        //TODO: Multiline
        var color_button_box = new jorts.ColorBox(theme) {
            margin_start = 12,
            margin_end = 12
        };


        color_button_box.theme_changed.connect ((selected) => {this.theme_changed(selected);});



        /* 
            ZOOM SELECTION
        */


        zoom_out_button = new Gtk.Button.from_icon_name ("zoom-out-symbolic") {
            tooltip_markup = Granite.markup_accel_tooltip (
                jorts.Constants.ACCELS_ZOOM_OUT,
                _("Zoom out")
                )
            };
        this.zoom_default_button = new Gtk.Button () {
            tooltip_markup = Granite.markup_accel_tooltip (
                jorts.Constants.ACCELS_ZOOM_DEFAULT,
                _("Default zoom level")
                )
            };

            this.zoom_in_button = new Gtk.Button.from_icon_name ("zoom-in-symbolic") {
            tooltip_markup = Granite.markup_accel_tooltip (
                jorts.Constants.ACCELS_ZOOM_IN,
                _("Zoom in")
                )
            };

        // Emit a signal when a button is toggled that will be picked by MainWindow
        this.zoom_out_button.clicked.connect (() => {this.zoom_changed("zoom_out");});
        this.zoom_default_button.clicked.connect (() => {this.zoom_changed("reset");});
        this.zoom_in_button.clicked.connect (() => {this.zoom_changed("zoom_in");});
        
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


        setting_grid.append (color_button_box);
        setting_grid.append (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        setting_grid.append (font_size_box);

        setting_grid.show ();
        set_child(setting_grid);


    }



    // Called by the Mainwindow when adjusting to new zoomlevel
    // Mainwindow reacts to a signal by the popover
    public void set_zoomlevel (int zoom) {

        //TRANSLATORS: %d is replaced by a number. Ex: 100, to display 100%
        //It must stay as "%d" in the translation so the app can replace it with the current zoom level.
        var label = _("%d%%").printf (zoom);
        this.zoom_default_button.set_label (label);  
    }




}

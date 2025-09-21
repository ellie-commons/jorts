/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* The popover menu to tweak individual notes
* Contains a setting for color, one for monospace font, one for zoom
*/
public class Jorts.PopoverView : Gtk.Popover {

    private Jorts.ColorBox color_button_box;
    private Jorts.MonospaceBox monospace_box;
    private Jorts.ZoomBox font_size_box;

    public Themes color {
        get {return color_button_box.color;}
        set {color_button_box.color = value;}
    }

    public bool monospace {
        get {return monospace_box.monospace;}
        set {monospace_box.monospace = value;}
    }

    public int zoom {
        get {return font_size_box.zoom;}
        set {font_size_box.zoom = value;}
    }

    public signal void theme_changed (Jorts.Themes selected);
    public signal void zoom_changed (Jorts.Zoomkind zoomkind);
    public signal void monospace_changed (bool if_monospace);

    /****************/
    construct {
        position = Gtk.PositionType.TOP;
        halign = Gtk.Align.END;

        var view = new Gtk.Box (VERTICAL, 12) {
            margin_top = 12,
            margin_bottom = 12
        };

        color_button_box = new Jorts.ColorBox ();
        monospace_box = new Jorts.MonospaceBox ();
        font_size_box = new Jorts.ZoomBox ();

        /* APPENDS */
        view.append (color_button_box);
        view.append (monospace_box);
        //view.append (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        view.append (font_size_box);

        child = view;

        color_button_box.theme_changed.connect ((selected) => {theme_changed (selected);});
        monospace_box.monospace_changed.connect ((monospace) => {monospace_changed (monospace);});
        font_size_box.zoom_changed.connect ((zoomkind) => {zoom_changed (zoomkind);});
    }
}

/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

public class Jorts.PopoverView : Gtk.Popover {

    public Jorts.ColorBox color_button_box;
    public Jorts.MonospaceBox monospace_box;
    public Jorts.ZoomBox font_size_box;

    public Jorts.Themes theme;
    public int zoom;

        /* THEME SELECTION */
    public signal void theme_changed (Jorts.Themes selected);
    public signal void zoom_changed (Jorts.Zoomkind zoomkind);
    public signal void monospace_changed (bool if_monospace);

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

        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        color_button_box.theme_changed.connect ((selected) => {theme_changed (selected);});
        monospace_box.monospace_changed.connect ((monospace) => {monospace_changed (monospace);});
        font_size_box.zoom_changed.connect ((zoomkind) => {zoom_changed (zoomkind);});
    }
}

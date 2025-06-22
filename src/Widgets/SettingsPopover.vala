/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2025 Stella (teamcons.carrd.co) and the Ellie_Commons community (github.com/ellie-commons/)
 */

/* I just dont wanna clutter my StickyNoteWindow, damn.
So the whole settings popover is here, deal with it.

>Grid
->Label notecolor
->GtkBox
-->Lots of ColorPills


*/


public class Jorts.SettingsPopover : Gtk.Popover {

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

        var popview = new Jorts.PopoverView () {
            theme = theme
        };

        set_child (popview);

        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        popview.color_button_box.theme_changed.connect ((selected) => {this.theme_changed (selected);});

        // Emit a signal when a button is toggled that will be picked by StickyNoteWindow
        popview.zoom_out_button.clicked.connect (() => {this.zoom_changed ("zoom_out");});
        popview.zoom_default_button.clicked.connect (() => {this.zoom_changed ("reset");});
        popview.zoom_in_button.clicked.connect (() => {this.zoom_changed ("zoom_in");});


    }



    // Called by the StickyNoteWindow when adjusting to new zoomlevel
    // StickyNoteWindow reacts to a signal by the popover
    public void set_zoomlevel (int zoom) {

        //TRANSLATORS: %d is replaced by a number. Ex: 100, to display 100%
        //It must stay as "%d" in the translation so the app can replace it with the current zoom level.
        var label = _("%d%%").printf (zoom);
        this.zoom_default_button.set_label (label);
    }




}

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

    public signal void theme_changed (string? selected);

    public SettingsPopover () {

        // Everything is in this
        var setting_grid = new Gtk.Grid ();
        setting_grid.margin = 12;
        setting_grid.column_spacing = 6;
        setting_grid.row_spacing = 6;
        setting_grid.orientation = Gtk.Orientation.VERTICAL;
        setting_grid.show_all ();


        // Choose theme section
        var color_button_label = new Granite.HeaderLabel (_("Note Color"));
        setting_grid.attach (color_button_label, 0, 0, 1, 1);

        var color_button_blueberry = new ColorPill (_("Blueberry"), "blueberry");
        var color_button_lime = new ColorPill (_("Lime"), "lime");
        var color_button_mint = new ColorPill (_("Mint"), "mint");
        var color_button_banana = new ColorPill (_("Banana"), "banana");
        var color_button_strawberry = new ColorPill (_("Strawberry"), "strawberry");
        var color_button_orange = new ColorPill (_("Orange"), "orange");
        var color_button_bubblegum = new ColorPill (_("Bubblegum"), "bubblegum");
        var color_button_grape = new ColorPill (_("Grape"),"grape");
        var color_button_latte = new ColorPill (_("Latte"),"latte");
        var color_button_cocoa = new ColorPill (_("Cocoa"), "cocoa");
        var color_button_slate = new ColorPill (_("Slate"),"slate");

        //TODO: Multiline
        var color_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

        // GTK4: append
        color_button_box.pack_start (color_button_blueberry, false, true, 0);
        color_button_box.pack_start (color_button_mint, false, true, 0);
        color_button_box.pack_start (color_button_lime, false, true, 0);
        color_button_box.pack_start (color_button_banana, false, true, 0);
        color_button_box.pack_start (color_button_orange, false, true, 0);
        color_button_box.pack_start (color_button_strawberry, false, true, 0);
        color_button_box.pack_start (color_button_bubblegum, false, true, 0);
        color_button_box.pack_start (color_button_grape, false, true, 0);
        color_button_box.pack_start (color_button_latte, false, true, 0);
        color_button_box.pack_start (color_button_cocoa, false, true, 0);
        color_button_box.pack_start (color_button_slate, false, true, 0);

        setting_grid.attach (color_button_box, 0, 1, 1, 1);

        this.add (setting_grid);




        
        color_button_strawberry.clicked.connect (() => {
            this.theme_changed("STRAWBERRY");
        });

        color_button_orange.clicked.connect (() => {
            this.theme_changed("ORANGE");
        });

        color_button_mint.clicked.connect (() => {
            this.theme_changed("MINT");
        });

        color_button_banana.clicked.connect (() => {
            this.theme_changed("BANANA");
        });

        color_button_lime.clicked.connect (() => {
            this.theme_changed("LIME");
        });

        color_button_blueberry.clicked.connect (() => {
            this.theme_changed("BLUEBERRY");
        });

        color_button_bubblegum.clicked.connect (() => {
            this.theme_changed("BUBBLEGUM");
        });

        color_button_grape.clicked.connect (() => {
            this.theme_changed("GRAPE");
        });

        color_button_latte.clicked.connect (() => {
            this.theme_changed("LATTE");
        });

        color_button_cocoa.clicked.connect (() => {
            this.theme_changed("COCOA");
        });

        color_button_slate.clicked.connect (() => {
            this.theme_changed("SLATE");
        });


    }

}

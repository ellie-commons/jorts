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
    public string selected;
    public signal void theme_changed (string selected);

    public SettingsPopover (string theme) {

        // Everything is in this
        var setting_grid = new Gtk.Grid ();
        setting_grid.set_margin_start (12);
        setting_grid.set_margin_end (12);
        setting_grid.set_margin_top (12);
        setting_grid.set_margin_bottom (12);

        setting_grid.column_spacing = 6;
        setting_grid.row_spacing = 6;
        setting_grid.orientation = Gtk.Orientation.VERTICAL;
  
        // Choose theme section
        var color_button_label = new Granite.HeaderLabel (_("Sticky Note Colour"));
    
        setting_grid.attach (color_button_label, 0, 0, 1, 1);

        var color_button_blueberry = new ColorPill (_("Blueberry"), "blueberry");
        var color_button_lime = new ColorPill (_("Lime"), "lime");
        var color_button_mint = new ColorPill (_("Mint"), "mint");
        var color_button_banana = new ColorPill (_("Banana"), "banana");
        var color_button_strawberry = new ColorPill (_("Strawberry"), "strawberry");
        var color_button_orange = new ColorPill (_("Orange"), "orange");
        var color_button_bubblegum = new ColorPill (_("Bubblegum"), "bubblegum");
        var color_button_grape = new ColorPill (_("Grape"),"grape");
        //var color_button_latte = new ColorPill (_("Latte"),"latte");
        var color_button_cocoa = new ColorPill (_("Cocoa"), "cocoa");
        var color_button_slate = new ColorPill (_("Slate"),"slate");

        color_button_lime.set_group (color_button_blueberry);
        color_button_mint.set_group (color_button_blueberry);
        color_button_banana.set_group (color_button_blueberry);
        color_button_strawberry.set_group (color_button_blueberry);
        color_button_orange.set_group (color_button_blueberry);
        color_button_bubblegum.set_group (color_button_blueberry);
        color_button_grape.set_group (color_button_blueberry);
        //color_button_latte.set_group (color_button_blueberry);
        color_button_cocoa.set_group (color_button_blueberry);
        color_button_slate.set_group (color_button_blueberry);

        color_button_blueberry.set_active ((theme == "BLUEBERRY"));
        color_button_lime.set_active ((theme == "LIME"));
        color_button_mint.set_active ((theme == "MINT"));
        color_button_banana.set_active ((theme == "BANANA"));
        color_button_strawberry.set_active ((theme == "STRAWBERRY"));
        color_button_orange.set_active ((theme == "ORANGE"));
        color_button_bubblegum.set_active ((theme == "BUBBLEGUM"));
        color_button_grape.set_active ((theme == "GRAPE"));
        //color_button_latte.set_group (color_button_blueberry);
        color_button_cocoa.set_active ((theme == "COCOA"));
        color_button_slate.set_active ((theme == "SLATE"));



        //TODO: Multiline
        var color_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
            accessible_role = Gtk.AccessibleRole.LIST
        };
        color_button_box.set_halign (Gtk.Align.CENTER);
        color_button_box.set_valign (Gtk.Align.CENTER);
        // GTK4: append
        color_button_box.append (color_button_blueberry);
        color_button_box.append (color_button_mint);
        color_button_box.append (color_button_lime);
        color_button_box.append (color_button_banana);
        color_button_box.append (color_button_orange);
        color_button_box.append (color_button_strawberry);
        color_button_box.append (color_button_bubblegum);
        color_button_box.append (color_button_grape);
        //color_button_box.append (color_button_latte);
        color_button_box.append (color_button_cocoa);
        color_button_box.append (color_button_slate);

        setting_grid.attach (color_button_box, 0, 1, 1, 1);

        setting_grid.show ();
        this.set_child(setting_grid);


        color_button_blueberry.toggled.connect (() => {
            this.theme_changed("BLUEBERRY");
        });

        color_button_orange.toggled.connect (() => {
            this.theme_changed("ORANGE");
        });

        color_button_mint.toggled.connect (() => {
            this.theme_changed("MINT");
        });

        color_button_banana.toggled.connect (() => {
            this.theme_changed("BANANA");
        });

        color_button_lime.toggled.connect (() => {
            this.theme_changed("LIME");
        });

        color_button_strawberry.toggled.connect (() => {
            this.theme_changed("STRAWBERRY");
        });

        color_button_bubblegum.toggled.connect (() => {
            this.theme_changed("BUBBLEGUM");
        });

        color_button_grape.toggled.connect (() => {
            this.theme_changed("GRAPE");
        });

        //  color_button_latte.toggled.connect (() => {
        //      this.theme_changed("LATTE");
        //  });

        color_button_cocoa.toggled.connect (() => {
            this.theme_changed("COCOA");
        });

        color_button_slate.toggled.connect (() => {
            this.theme_changed("SLATE");
        });
    }
}

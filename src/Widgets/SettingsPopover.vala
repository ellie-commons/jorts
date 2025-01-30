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



public class jorts.SettingsPopover : Gtk.Popover {

    public signal void changed (string? selected);

    public SettingsPopover () {



        var color_button_strawberry = new Gtk.Button ();
        color_button_strawberry.has_focus = false;
        color_button_strawberry.halign = Gtk.Align.CENTER;
        color_button_strawberry.height_request = 24;
        color_button_strawberry.width_request = 24;
        color_button_strawberry.tooltip_text = _("Strawberry");
        color_button_strawberry.get_style_context ().add_class ("color-button");
        color_button_strawberry.get_style_context ().add_class ("strawberry");

        var color_button_orange = new Gtk.Button ();
        color_button_orange.has_focus = false;
        color_button_orange.halign = Gtk.Align.CENTER;
        color_button_orange.height_request = 24;
        color_button_orange.width_request = 24;
        color_button_orange.tooltip_text = _("Orange");

        var color_button_orange_context = color_button_orange.get_style_context ();
        color_button_orange_context.add_class ("color-button");
        color_button_orange_context.add_class ("orange");

        var color_button_banana = new Gtk.Button ();
        color_button_banana.has_focus = false;
        color_button_banana.halign = Gtk.Align.CENTER;
        color_button_banana.height_request = 24;
        color_button_banana.width_request = 24;
        color_button_banana.tooltip_text = _("Banana");

        var color_button_banana_context = color_button_banana.get_style_context ();
        color_button_banana_context.add_class ("color-button");
        color_button_banana_context.add_class ("banana");

        var color_button_lime = new Gtk.Button ();
        color_button_lime.has_focus = false;
        color_button_lime.halign = Gtk.Align.CENTER;
        color_button_lime.height_request = 24;
        color_button_lime.width_request = 24;
        color_button_lime.tooltip_text = _("Lime");

        var color_button_lime_context = color_button_lime.get_style_context ();
        color_button_lime_context.add_class ("color-button");
        color_button_lime_context.add_class ("lime");

        var color_button_blueberry = new Gtk.Button ();
        color_button_blueberry.has_focus = false;
        color_button_blueberry.halign = Gtk.Align.CENTER;
        color_button_blueberry.height_request = 24;
        color_button_blueberry.width_request = 24;
        color_button_blueberry.tooltip_text = _("Blueberry");

        var color_button_blueberry_context = color_button_blueberry.get_style_context ();
        color_button_blueberry_context.add_class ("color-button");
        color_button_blueberry_context.add_class ("blueberry");


        var color_button_bubblegum = new Gtk.Button ();
        color_button_bubblegum.has_focus = false;
        color_button_bubblegum.halign = Gtk.Align.CENTER;
        color_button_bubblegum.height_request = 24;
        color_button_bubblegum.width_request = 24;
        color_button_bubblegum.tooltip_text = _("Bubblegum");

        var color_button_bubblegum_context = color_button_blueberry.get_style_context ();
        color_button_bubblegum_context.add_class ("color-button");
        color_button_bubblegum_context.add_class ("bubblegum");


        var color_button_grape = new Gtk.Button ();
        color_button_grape.has_focus = false;
        color_button_grape.halign = Gtk.Align.CENTER;
        color_button_grape.height_request = 24;
        color_button_grape.width_request = 24;
        color_button_grape.tooltip_text = _("Grape");

        var color_button_grape_context = color_button_grape.get_style_context ();
        color_button_grape_context.add_class ("color-button");
        color_button_grape_context.add_class ("grape");

        var color_button_cocoa = new Gtk.Button ();
        color_button_cocoa.has_focus = false;
        color_button_cocoa.halign = Gtk.Align.CENTER;
        color_button_cocoa.height_request = 24;
        color_button_cocoa.width_request = 24;
        color_button_cocoa.tooltip_text = _("Cocoa");

        var color_button_cocoa_context = color_button_cocoa.get_style_context ();
        color_button_cocoa_context.add_class ("color-button");
        color_button_cocoa_context.add_class ("cocoa");

        var color_button_silver = new Gtk.Button ();
        color_button_silver.has_focus = false;
        color_button_silver.halign = Gtk.Align.CENTER;
        color_button_silver.height_request = 24;
        color_button_silver.width_request = 24;
        color_button_silver.tooltip_text = _("Silver");

        var color_button_silver_context = color_button_silver.get_style_context ();
        color_button_silver_context.add_class ("color-button");
        color_button_silver_context.add_class ("silver");


        var color_button_slate = new Gtk.Button ();
        color_button_slate.has_focus = false;
        color_button_slate.halign = Gtk.Align.CENTER;
        color_button_slate.height_request = 24;
        color_button_slate.width_request = 24;
        color_button_slate.tooltip_text = _("Slate");

        var color_button_slate_context = color_button_slate.get_style_context ();
        color_button_slate_context.add_class ("color-button");
        color_button_slate_context.add_class ("slate");

        var color_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        // GTK4: append
        // THE HECK IS THESE
        color_button_box.pack_start (color_button_strawberry, false, true, 0);
        color_button_box.pack_start (color_button_orange, false, true, 0);
        color_button_box.pack_start (color_button_banana, false, true, 0);
        color_button_box.pack_start (color_button_lime, false, true, 0);
        color_button_box.pack_start (color_button_blueberry, false, true, 0);
        color_button_box.pack_start (color_button_bubblegum, false, true, 0);
        color_button_box.pack_start (color_button_grape, false, true, 0);
        color_button_box.pack_start (color_button_cocoa, false, true, 0);
        color_button_box.pack_start (color_button_silver, false, true, 0);
        color_button_box.pack_start (color_button_slate, false, true, 0);

        var color_button_label = new Granite.HeaderLabel (_("Note Color"));

        var setting_grid = new Gtk.Grid ();
        setting_grid.margin = 12;
        setting_grid.column_spacing = 6;
        setting_grid.row_spacing = 6;
        setting_grid.orientation = Gtk.Orientation.VERTICAL;
        setting_grid.attach (color_button_label, 0, 0, 1, 1);
        setting_grid.attach (color_button_box, 0, 1, 1, 1);
        setting_grid.show_all ();






    }

}

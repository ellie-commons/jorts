/*
* Copyright (c) 2025 Stella - teamcons.carrd.co
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
*
*/



public class jorts.SettingsPopover : Gtk.Popover {

    Public string selected




    public SettingsPopover () {
        Object ();
    }

    construct {
            var color_button_strawberry = new Gtk.Button ();
            color_button_strawberry.has_focus = false;
            color_button_strawberry.halign = Gtk.Align.CENTER;
            color_button_strawberry.height_request = 24;
            color_button_strawberry.width_request = 24;
            color_button_strawberry.tooltip_text = _("Strawberry");
            color_button_strawberry.get_style_context ().add_class ("color-button");
            color_button_strawberry.get_style_context ().add_class ("color-strawberry");

            var color_button_orange = new Gtk.Button ();
            color_button_orange.has_focus = false;
            color_button_orange.halign = Gtk.Align.CENTER;
            color_button_orange.height_request = 24;
            color_button_orange.width_request = 24;
            color_button_orange.tooltip_text = _("Orange");

            var color_button_orange_context = color_button_orange.get_style_context ();
            color_button_orange_context.add_class ("color-button");
            color_button_orange_context.add_class ("color-orange");

            var color_button_banana = new Gtk.Button ();
            color_button_banana.has_focus = false;
            color_button_banana.halign = Gtk.Align.CENTER;
            color_button_banana.height_request = 24;
            color_button_banana.width_request = 24;
            color_button_banana.tooltip_text = _("Banana");

            var color_button_banana_context = color_button_banana.get_style_context ();
            color_button_banana_context.add_class ("color-button");
            color_button_banana_context.add_class ("color-banana");

            var color_button_lime = new Gtk.Button ();
            color_button_lime.has_focus = false;
            color_button_lime.halign = Gtk.Align.CENTER;
            color_button_lime.height_request = 24;
            color_button_lime.width_request = 24;
            color_button_lime.tooltip_text = _("Lime");

            var color_button_lime_context = color_button_lime.get_style_context ();
            color_button_lime_context.add_class ("color-button");
            color_button_lime_context.add_class ("color-lime");

            var color_button_blueberry = new Gtk.Button ();
            color_button_blueberry.has_focus = false;
            color_button_blueberry.halign = Gtk.Align.CENTER;
            color_button_blueberry.height_request = 24;
            color_button_blueberry.width_request = 24;
            color_button_blueberry.tooltip_text = _("Blueberry");

            var color_button_blueberry_context = color_button_blueberry.get_style_context ();
            color_button_blueberry_context.add_class ("color-button");
            color_button_blueberry_context.add_class ("color-blueberry");


            var color_button_bubblegum = new Gtk.Button ();
            color_button_bubblegum.has_focus = false;
            color_button_bubblegum.halign = Gtk.Align.CENTER;
            color_button_bubblegum.height_request = 24;
            color_button_bubblegum.width_request = 24;
            color_button_bubblegum.tooltip_text = _("Bubblegum");

            var color_button_bubblegum_context = color_button_blueberry.get_style_context ();
            color_button_bubblegum_context.add_class ("color-button");
            color_button_bubblegum_context.add_class ("color-bubblegum");


            var color_button_grape = new Gtk.Button ();
            color_button_grape.has_focus = false;
            color_button_grape.halign = Gtk.Align.CENTER;
            color_button_grape.height_request = 24;
            color_button_grape.width_request = 24;
            color_button_grape.tooltip_text = _("Grape");

            var color_button_grape_context = color_button_grape.get_style_context ();
            color_button_grape_context.add_class ("color-button");
            color_button_grape_context.add_class ("color-grape");

            var color_button_cocoa = new Gtk.Button ();
            color_button_cocoa.has_focus = false;
            color_button_cocoa.halign = Gtk.Align.CENTER;
            color_button_cocoa.height_request = 24;
            color_button_cocoa.width_request = 24;
            color_button_cocoa.tooltip_text = _("Cocoa");

            var color_button_cocoa_context = color_button_cocoa.get_style_context ();
            color_button_cocoa_context.add_class ("color-button");
            color_button_cocoa_context.add_class ("color-cocoa");

            var color_button_silver = new Gtk.Button ();
            color_button_silver.has_focus = false;
            color_button_silver.halign = Gtk.Align.CENTER;
            color_button_silver.height_request = 24;
            color_button_silver.width_request = 24;
            color_button_silver.tooltip_text = _("Silver");

            var color_button_silver_context = color_button_silver.get_style_context ();
            color_button_silver_context.add_class ("color-button");
            color_button_silver_context.add_class ("color-silver");


            var color_button_slate = new Gtk.Button ();
            color_button_slate.has_focus = false;
            color_button_slate.halign = Gtk.Align.CENTER;
            color_button_slate.height_request = 24;
            color_button_slate.width_request = 24;
            color_button_slate.tooltip_text = _("Slate");

            var color_button_slate_context = color_button_slate.get_style_context ();
            color_button_slate_context.add_class ("color-button");
            color_button_slate_context.add_class ("color-slate");

            var color_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            // GTK4: append
            // THE HECK IS THESE
            color_button_box.pack_start (color_button_strawberry, false, true, 0);
            color_button_box.pack_start (color_button_orange, false, true, 0);
            color_button_box.pack_start (color_button_banana, false, true, 0);
            color_button_box.pack_start (color_button_lime, false, true, 0);
            color_button_box.pack_start (color_button_blueberry, false, true, 0);
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

            var popover = new Gtk.Popover (null);
            popover.add (setting_grid);

            var app_button = new Gtk.MenuButton();
            app_button.has_tooltip = true;
            app_button.tooltip_text = (_("Settings"));
            app_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            app_button.popover = popover;


            // All the "change theme when theme button changed"
            // TODO: cleaner theme management
            color_button_strawberry.clicked.connect (() => {
                this.theme = "STRAWBERRY";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            color_button_orange.clicked.connect (() => {
                this.theme = "ORANGE";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            color_button_banana.clicked.connect (() => {
                this.theme = "BANANA";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            color_button_lime.clicked.connect (() => {
                this.theme = "LIME";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            color_button_blueberry.clicked.connect (() => {
                this.theme = "BLUEBERRY";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            color_button_bubblegum.clicked.connect (() => {
                this.theme = "BUBBLEGUM";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            color_button_grape.clicked.connect (() => {
                this.theme = "GRAPE";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            color_button_cocoa.clicked.connect (() => {
                this.theme = "COCOA";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            color_button_silver.clicked.connect (() => {
                this.theme = "SILVER";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            color_button_slate.clicked.connect (() => {
                this.theme = "SLATE";
                update_theme(this.theme);
                ((Application)this.application).update_storage();
            });

            // GTK4: Append
            //actionbar.pack_end (app_button);
    }






}
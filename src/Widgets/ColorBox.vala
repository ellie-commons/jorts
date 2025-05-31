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

/*
I just dont wanna rewrite the same button over and over

*/



public class Jorts.ColorBox : Gtk.Box {

    public signal void theme_changed (string selected);

    public ColorBox (string theme) {

        orientation = Gtk.Orientation.HORIZONTAL;

        accessible_role = Gtk.AccessibleRole.LIST;
        spacing = 0;

            //TRANSLATORS: Shown as a tooltip when people hover a color theme
            var color_button_blueberry = new ColorPill (_("Blueberry"), "blueberry");
            var color_button_lime = new ColorPill (_("Lime"), "lime");
            var color_button_mint = new ColorPill (_("Mint"), "mint");
            var color_button_banana = new ColorPill (_("Banana"), "banana");
            var color_button_strawberry = new ColorPill (_("Strawberry"), "strawberry");
            var color_button_orange = new ColorPill (_("Orange"), "orange");
            var color_button_bubblegum = new ColorPill (_("Bubblegum"), "bubblegum");
            var color_button_grape = new ColorPill (_("Grape"),"grape");
            var color_button_cocoa = new ColorPill (_("Cocoa"), "cocoa");
            var color_button_slate = new ColorPill (_("Slate"),"slate");

            color_button_lime.set_group (color_button_blueberry);
            color_button_mint.set_group (color_button_blueberry);
            color_button_banana.set_group (color_button_blueberry);
            color_button_strawberry.set_group (color_button_blueberry);
            color_button_orange.set_group (color_button_blueberry);
            color_button_bubblegum.set_group (color_button_blueberry);
            color_button_grape.set_group (color_button_blueberry);
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
            color_button_cocoa.set_active ((theme == "COCOA"));
            color_button_slate.set_active ((theme == "SLATE"));

            // Emit a signal when a button is toggled
            color_button_blueberry.toggled.connect (() => {this.theme_changed ("BLUEBERRY");});
            color_button_orange.toggled.connect (() => {this.theme_changed ("ORANGE");});
            color_button_mint.toggled.connect (() => {this.theme_changed ("MINT");});
            color_button_banana.toggled.connect (() => {this.theme_changed ("BANANA");});
            color_button_lime.toggled.connect (() => {this.theme_changed ("LIME");});
            color_button_strawberry.toggled.connect (() => {this.theme_changed ("STRAWBERRY");});
            color_button_bubblegum.toggled.connect (() => {this.theme_changed ("BUBBLEGUM");});
            color_button_grape.toggled.connect (() => {this.theme_changed ("GRAPE");});
            color_button_cocoa.toggled.connect (() => {this.theme_changed ("COCOA");});
            color_button_slate.toggled.connect (() => {this.theme_changed ("SLATE");});

            append (color_button_blueberry);
            append (color_button_mint);
            append (color_button_lime);
            append (color_button_banana);
            append (color_button_orange);
            append (color_button_strawberry);
            append (color_button_bubblegum);
            append (color_button_grape);
            append (color_button_cocoa);
            append (color_button_slate);

    }
}

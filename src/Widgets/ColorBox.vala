/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2017-2024 Lains
 * SPDX-FileCopyrightText: 2025 Stella & Charlie (teamcons.carrd.co)
 * SPDX-FileCopyrightText: 2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


/*
I just dont wanna rewrite the same button over and over

*/



public class Jorts.ColorBox : Gtk.Box {

    public signal void theme_changed (string selected);

    public string theme {get; set;}

    private Jorts.ColorPill color_button_blueberry;
    private Jorts.ColorPill color_button_lime;
    private Jorts.ColorPill color_button_mint;
    private Jorts.ColorPill color_button_banana;
    private Jorts.ColorPill color_button_strawberry;
    private Jorts.ColorPill color_button_orange;
    private Jorts.ColorPill color_button_bubblegum;
    private Jorts.ColorPill color_button_grape;
    private Jorts.ColorPill color_button_cocoa;
    private Jorts.ColorPill color_button_slate;

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;

        accessible_role = Gtk.AccessibleRole.LIST;
        spacing = 0;
        margin_start = 12;
        margin_end = 12;

            //TRANSLATORS: Shown as a tooltip when people hover a color theme
            color_button_blueberry = new ColorPill (_("Blueberry"), "blueberry");
            color_button_lime = new ColorPill (_("Lime"), "lime");
            color_button_mint = new ColorPill (_("Mint"), "mint");
            color_button_banana = new ColorPill (_("Banana"), "banana");
            color_button_strawberry = new ColorPill (_("Strawberry"), "strawberry");
            color_button_orange = new ColorPill (_("Orange"), "orange");
            color_button_bubblegum = new ColorPill (_("Bubblegum"), "bubblegum");
            color_button_grape = new ColorPill (_("Grape"),"grape");
            color_button_cocoa = new ColorPill (_("Cocoa"), "cocoa");
            color_button_slate = new ColorPill (_("Slate"),"slate");

            color_button_lime.set_group (color_button_blueberry);
            color_button_mint.set_group (color_button_blueberry);
            color_button_banana.set_group (color_button_blueberry);
            color_button_strawberry.set_group (color_button_blueberry);
            color_button_orange.set_group (color_button_blueberry);
            color_button_bubblegum.set_group (color_button_blueberry);
            color_button_grape.set_group (color_button_blueberry);
            color_button_cocoa.set_group (color_button_blueberry);
            color_button_slate.set_group (color_button_blueberry);

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


    public void set_toggles (string theme) {
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
    }



}

/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* A box mimicking the one in elementary OS Appearance settings page
* It shows a row with all the colours
*/
public class Jorts.ColorBox : Gtk.Box {

    private Themes _color = Constants.DEFAULT_THEME;
    public Jorts.Themes color {
        get {return _color;}
        set {set_all_toggles (value);}
    }
    public signal void theme_changed (Themes selected);


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

    // TODO: We could loop instead of by-hand definition
    public ColorBox () {
        orientation = Gtk.Orientation.HORIZONTAL;

        accessible_role = Gtk.AccessibleRole.LIST;
        spacing = 0;
        margin_start = 12;
        margin_end = 12;

            //TRANSLATORS: Shown as a tooltip when people hover a color theme
            color_button_blueberry = new ColorPill (Jorts.Themes.BLUEBERRY);
            color_button_lime = new ColorPill (Jorts.Themes.LIME);
            color_button_mint = new ColorPill (Jorts.Themes.MINT);
            color_button_banana = new ColorPill (Jorts.Themes.BANANA);
            color_button_strawberry = new ColorPill (Jorts.Themes.STRAWBERRY);
            color_button_orange = new ColorPill (Jorts.Themes.ORANGE);
            color_button_bubblegum = new ColorPill (Jorts.Themes.BUBBLEGUM);
            color_button_grape = new ColorPill (Jorts.Themes.GRAPE);
            color_button_cocoa = new ColorPill (Jorts.Themes.COCOA);
            color_button_slate = new ColorPill (Jorts.Themes.SLATE);

            color_button_blueberry.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>1"}, Jorts.Themes.BLUEBERRY.to_nicename ());

            color_button_lime.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>2"}, Jorts.Themes.LIME.to_nicename ());

            color_button_mint.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>3"}, Jorts.Themes.MINT.to_nicename ());

            color_button_banana.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>4"}, Jorts.Themes.BANANA.to_nicename ());

            color_button_strawberry.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>5"}, Jorts.Themes.STRAWBERRY.to_nicename ());

            color_button_orange.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>6"}, Jorts.Themes.ORANGE.to_nicename ());

            color_button_bubblegum.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>7"}, Jorts.Themes.BUBBLEGUM.to_nicename ());

            color_button_grape.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>8"}, Jorts.Themes.GRAPE.to_nicename ());

            color_button_cocoa.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>9"}, Jorts.Themes.COCOA.to_nicename ());

            color_button_slate.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>0"}, Jorts.Themes.SLATE.to_nicename ());


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
            color_button_blueberry.selected.connect (on_selected);
            color_button_orange.selected.connect (on_selected);
            color_button_mint.selected.connect (on_selected);
            color_button_banana.selected.connect (on_selected);
            color_button_lime.selected.connect (on_selected);
            color_button_strawberry.selected.connect (on_selected);
            color_button_bubblegum.selected.connect (on_selected);
            color_button_grape.selected.connect (on_selected);
            color_button_cocoa.selected.connect (on_selected);
            color_button_slate.selected.connect (on_selected);

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

    private void on_selected (Jorts.Themes color) {
        _color = color;
        theme_changed (color);
    }

    private void set_all_toggles (Jorts.Themes color) {
        _color = color;
        color_button_blueberry.set_active ((color == color_button_blueberry.color));
        color_button_lime.set_active ((color == color_button_lime.color));
        color_button_mint.set_active ((color == color_button_mint.color));
        color_button_banana.set_active ((color == color_button_banana.color));
        color_button_strawberry.set_active ((color == color_button_strawberry.color));
        color_button_orange.set_active ((color == color_button_orange.color));
        color_button_bubblegum.set_active ((color == color_button_bubblegum.color));
        color_button_grape.set_active ((color == color_button_grape.color));
        color_button_cocoa.set_active ((color == color_button_cocoa.color));
        color_button_slate.set_active ((color == color_button_slate.color));
    }

}

/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/*

/**
* I just dont wanna rewrite the same button over and over
*/
public class Jorts.ColorPill : Gtk.CheckButton {
        public Jorts.Themes color;
        public signal void selected (Jorts.Themes color);

        public ColorPill (Jorts.Themes? theme = (null)) {
                this.color = theme;

                add_css_class ("colorpill");
                add_css_class (theme.to_css_class ());
                set_size_request (24, 24);
                set_tooltip_text (theme.to_nicename ());
                add_css_class (Granite.STYLE_CLASS_COLOR_BUTTON);

                margin_top = 0;
                margin_bottom = 0;
                margin_start = 0;
                margin_end = 0;

                this.toggled.connect (on_connect);
        }

        public void on_connect () {
                selected (color);
        }
}

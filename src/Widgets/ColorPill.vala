/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/*
I just dont wanna rewrite the same button over and over
*/

public class Jorts.ColorPill : Gtk.CheckButton {
        public ColorPill (string tooltip, string colorclass) {

                add_css_class ("colorpill");
                add_css_class (colorclass);
                set_size_request (24, 24);
                set_tooltip_text (tooltip);
                add_css_class (Granite.STYLE_CLASS_COLOR_BUTTON);

                margin_top = 0;
                margin_bottom = 0;
                margin_start = 0;
                margin_end = 0;
        }
}

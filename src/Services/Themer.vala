/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/*

generate_css(theme)
--> On the fly generation of a whole stylesheet depending on a elementary OS accent color name

init_all_themes()
--> Loop through a list of defined accent colors to generate stylesheets and load them all

*/


namespace Jorts.Themer {

    /*************************************************/
    // Here we go
    // Take up a elementary OS color name and gurgle back a CSS string
    public static string generate_css (string theme) {
        debug ("Generating css");
        string style = (N_("""
            /* Accent color 
            mix(@${accent_color}_500, @${accent_color}_700, 0.3) */
            
            window.${accent_color} {
                background-color: @${accent_color}_100;
            }


            window.${accent_color} undershoot.top {
                background:
                    linear-gradient(
                        @${accent_color}_100 0%,
                        alpha(@${accent_color}_100, 0) 50%
                    );
            }

            window.${accent_color} undershoot.bottom {
                background:
                    linear-gradient(
                        alpha(@${accent_color}_100, 0) 50%,
                        @${accent_color}_100 100%
                    );
            }


            /* WEIRD: if we dont personally just redefine overshoot effect, the grey theme doesnt have any*/
            window.${accent_color} overshoot.top {
            background: linear-gradient(to top, alpha(mix(@${accent_color}_500, @${accent_color}_700, 0.3), 0) 80%, alpha(mix(@${accent_color}_500, @${accent_color}_700, 0.3), 0.25) 100%); }

            window.${accent_color} overshoot.right {
            background: linear-gradient(to right, alpha(mix(@${accent_color}_500, @${accent_color}_700, 0.3), 0) 80%, alpha(mix(@${accent_color}_500, @${accent_color}_700, 0.3), 0.25) 100%); }

            window.${accent_color} overshoot.bottom {
            background: linear-gradient(to bottom, alpha(mix(@${accent_color}_500, @${accent_color}_700, 0.3), 0) 80%, alpha(mix(@${accent_color}_500, @${accent_color}_700, 0.3), 0.25) 100%); }

            window.${accent_color} overshoot.left {
            background: linear-gradient(to left, alpha(mix(@${accent_color}_500, @${accent_color}_700, 0.3), 0) 80%, alpha(mix(@${accent_color}_500, @${accent_color}_700, 0.3), 0.25) 100%); }

            window.${accent_color} text selection {
                color: shade(@${accent_color}_100, 1.88);
                background-color: @${accent_color}_900;
            }

            window.${accent_color} titlebar,
            window.${accent_color} titlebar image,
            window.${accent_color} .themedbutton,
            window.${accent_color} .themedbutton image,
            window.${accent_color} windowcontrols,
            window.${accent_color} windowcontrols image,
            window.${accent_color} {
                color: @${accent_color}_900;
            }

            window.${accent_color} titlebar,
            window.${accent_color} textview,
            window.${accent_color} editablelabel.editing {
                background-color: transparent;
                border-bottom-color: @${accent_color}_100;
                color: shade(@${accent_color}_900, 0.77);
            }

            /* Fix the emoticon entry having note color background */
            window.${accent_color} entry {
                background-color: white;
                color: black;
            }

            window.${accent_color} editablelabel {
                color: @${accent_color}_900;
            }

            window.${accent_color} editablelabel:hover,
            window.${accent_color} editablelabel:focus {
                border: 1px solid alpha(mix(@${accent_color}_500, @${accent_color}_700, 0.3),0.88);
            }

            window.${accent_color} editablelabel.editing {
                border: 1px solid @${accent_color}_700;
                /*  box-shadow: inset 0 0 2px 2px mix(@${accent_color}_100, @${accent_color}_500, 0.3);  */
            }

            window.${accent_color}:backdrop editablelabel {
                color: alpha(@${accent_color}_900, 0.75);
            }

            window.${accent_color}:backdrop editablelabel,
            window.${accent_color}:backdrop actionbar,
            window.${accent_color}:backdrop actionbar image,
            window.${accent_color}:backdrop windowcontrols,
            window.${accent_color}:backdrop windowcontrols image {
                color: alpha(@${accent_color}_900, 0.65);
            }

        """));

        style = style.replace ("${accent_color}", theme);
        return style;
    }

    /*************************************************/
    // Called once, at the start of the app
    // Loads the standard sheet, then do all the different themes
    public static void init_all_themes () {
        debug ("[THEMER] Init all themes");

        // Then generate all theme classes
        foreach (unowned var theme in Jorts.Themes.all_string ()) {
            var theme_provider = new Gtk.CssProvider ();
            var style = Jorts.Themer.generate_css (theme);

            theme_provider.load_from_string (style);

            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                theme_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }
    }
}

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

generate_css(theme)
init_all_themes()

*/


namespace jorts.Themer {

    /*************************************************/
    // Here we go
    // Take up a elementary OS color name and gurgle back a CSS string
    public static string generate_css (string theme) {
        debug("Generating css");
        string style = "";

        style = (N_("""
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

            window.${accent_color} textview text selection,
            window.${accent_color} editablelabel text selection {
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
            window.${accent_color} textview text,
            window.${accent_color} editablelabel.editing text {
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
                border: 1px solid shade(mix(@${accent_color}_500, @${accent_color}_700, 0.3),0.7);
                box-shadow: inset 0 0 2px 2px mix(@${accent_color}_100, @${accent_color}_500, 0.3);
            }

            window.${accent_color}:backdrop editablelabel {
                color: alpha(@${accent_color}_900, 0.75);
            }

            window.${accent_color}:backdrop editablelabel,
            window.${accent_color}:backdrop actionbar,
            window.${accent_color}:backdrop actionbar image,
            window.${accent_color}:backdrop windowcontrols,
            window.${accent_color}:backdrop windowcontrols image {
                color: alpha(@${accent_color}_900, 0.75);
            }

        """));

        style = style.replace ("${accent_color}",theme);

        return style;
    }



    /*************************************************/    
    // Called once, at the start of the app
    // Loads the standard sheet, then do all the different themes
    public static void init_all_themes() {
        debug("Init all themes");

        // Use standard sheet
        var app_provider = new Gtk.CssProvider ();
        app_provider.load_from_resource ("/io/github/ellie_commons/jorts/Application.css");
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            app_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION + 1
        );

        // Then generate all theme classes
        foreach (unowned var theme in jorts.Constants.THEMES) {
            var theme_provider = new Gtk.CssProvider ();
            var style = jorts.Themer.generate_css (theme);

            theme_provider.load_from_string (style);

            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                theme_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }
    }
}

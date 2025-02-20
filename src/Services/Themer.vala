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

themearray
--> Global array of all the themes

generate_css(theme)
TODO: this would need to be static

init_all_themes()
--> generate_css for everything in themearray

*/


namespace jorts.Themer {

    // As seen on TV!
    const string[] themearray = {
        "BLUEBERRY",
        "MINT",
        "LIME",
        "BANANA",
        "ORANGE",
        "STRAWBERRY",
        "BUBBLEGUM",
        "GRAPE",
        //"LATTE",
        "COCOA",
        "SLATE"
    };

    // Here we go
    public static string generate_css (string theme) {
        string style = "";

        style = (N_("""
            window.%s {
                background-color: @%s_100;
            }

            window.%s undershoot.top {
                background:
                    linear-gradient(
                        @%s_100 0%,
                        alpha(@%s_100, 0) 50%
                    );
            }

            window.%s undershoot.bottom {
                background:
                    linear-gradient(
                        alpha(@%s_100, 0) 50%,
                        @%s_100 100%
                    );
            }

            window.%s textview text selection {
                color: shade(@%s_100, 1.88);
                background-color: @%s_900;
            }

            window.%s titlebar,
            window.%s titlebar image,
            window.%s headertitle,
            window.%s actionbar,
            window.%s actionbar image {
                color: @%s_900;
            }

            window.%s titlebar,
            window.%s textview,
            window.%s textview text {
                background-color: @%s_100;
                border-bottom-color: @%s_100;
                color: shade(@%s_900, 0.77);
            }

            window.%s editablelabel {
                color: @%s_900;
            }

            window.%s editablelabel.editing text {
                border: 1px solid @s_900;
            }


            window.%s:backdrop textview text,
            window.%s:backdrop headertitle,
            window.%s:backdrop titlebar,
            window.%s:backdrop editablelabel,
            window.%s:backdrop actionbar,
            window.%s:backdrop actionbar image {
                color: shade(@%s_500, 0.77);
            }


        """));

        style = style.replace ("%s",theme);

        return style;
    }

    public static void init_all_themes() {
        foreach (unowned var theme in jorts.Themer.themearray) {
            // Palette color
              var theme_provider = new Gtk.CssProvider ();
              var style = jorts.Themer.generate_css (theme);

              //print ("Generated: " + theme + "\n");

            theme_provider.load_from_string (style);


              Gtk.StyleContext.add_provider_for_display (
                  Gdk.Display.get_default (),
                  theme_provider,
                  Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
              );
          }
    }
}

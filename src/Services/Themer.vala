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
    // Called once, at the start of the app
    // Loads the standard sheet, then do all the different themes
    public static void init_all_themes () {
        debug ("[THEMER] Init all themes");

        // Use standard sheet
        var app_provider = new Gtk.CssProvider ();
        app_provider.load_from_resource ("/io/github/ellie_commons/jorts/Application.css");
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            app_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION + 1
        );

        // Use standard sheet
        var theme_provider = new Gtk.CssProvider ();
        theme_provider.load_from_resource ("/io/github/ellie_commons/jorts/Themes.css");
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            theme_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION + 1
        );



    }
}

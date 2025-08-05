/*
* Copyright (c) 2017-2024 Lains
* Copyright (c) 2025 Stella, Charlie, (teamcons on GitHub) and the Ellie_Commons community
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
General oversight of loading and supporting functions
At some point i may move lots of this in its own file


Application creates a NoteManager.


*/

public class Jorts.Application : Gtk.Application {

    public static GLib.Settings gsettings;
    public Jorts.NoteManager manager;


    private static Jorts.PreferenceWindow preferences;

    public Application () {
        Object (flags: ApplicationFlags.HANDLES_COMMAND_LINE,
                application_id: Jorts.Constants.RDNN);
    }



    /*************************************************/
    public override void startup () {
        debug ("Jorts startup sequence…");
        base.startup ();

        // The localization thingamabob
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (GETTEXT_PACKAGE);
            
        // Force the eOS icon theme, and set the blueberry as fallback, if for some reason it fails for individual notes
        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();
        gtk_settings.gtk_icon_theme_name = "elementary";
        gtk_settings.gtk_theme_name =   "io.elementary.stylesheet." + Jorts.Constants.DEFAULT_THEME.ascii_down();

        // Also follow dark if system is dark lIke mY sOul.
        gtk_settings.gtk_application_prefer_dark_theme = (
	            granite_settings.prefers_color_scheme == DARK
            );
	
        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = (
                    granite_settings.prefers_color_scheme == DARK
                );
        });

        // build all the stylesheets
        Jorts.Themer.init_all_themes ();
    }

    /*************************************************/        
    static construct {
        gsettings = new GLib.Settings (Jorts.Constants.RDNN);
    }

    /*************************************************/
    construct {
        manager = new Jorts.NoteManager (this);

        var quit_action = new SimpleAction ("quit", null);
        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Control>q"});
        quit_action.activate.connect (() => {
            manager.save_to_stash ();
            this.quit ();
        });
        var new_action = new SimpleAction ("new", null);
        add_action (new_action);
        set_accels_for_action ("app.action_new", {"<Control>n"});
        new_action.activate.connect (() => {
            manager.create_note (null);
        });

        var delete_action = new SimpleAction ("delete", null);
        add_action (delete_action);
        set_accels_for_action ("app.action_delete", {"<Control>w"});

        var save_action = new SimpleAction ("save", null);
        add_action (save_action);
        set_accels_for_action ("app.save", {"<Control>s"});
        save_action.activate.connect (manager.save_to_stash);

        var zoom_out = new SimpleAction ("zoom_out", null);
        add_action (zoom_out);
        set_accels_for_action ("app.zoom_out", { "<Control>minus", "<Control>KP_Subtract", null });

        var zoom_default = new SimpleAction ("zoom_default", null);
        add_action (zoom_default);
        set_accels_for_action ("app.zoom_default", {"<Control>equal", "<control>0", "<Control>KP_0", null });

        var zoom_in = new SimpleAction ("zoom_in", null);
        add_action (zoom_in);
        set_accels_for_action ("app.zoom_in", { "<Control>plus", "<Control>KP_Add", null });

        var toggle_scribbly = new SimpleAction ("toggle_scribbly", null);
        add_action (toggle_scribbly);
        set_accels_for_action ("app.toggle_scribbly", { "<Control>h", null });
        toggle_scribbly.activate.connect (() => {
            this.toggle_scribbly ();
        });

        var toggle_hidebar = new SimpleAction ("toggle_hidebar", null);
        add_action (toggle_hidebar);
        set_accels_for_action ("app.toggle_hidebar", { "<Control>t", null });
        toggle_hidebar.activate.connect (this.toggle_hidebar);

        var show_pref = new SimpleAction ("show_preferences", null);
        add_action (show_pref);
        set_accels_for_action ("app.show_preferences", { "<Control>p", null });
        show_pref.activate.connect (on_show_pref);
    }

    // Clicked: Either show all windows, or rebuild from storage
    protected override void activate () {
        debug ("Jorts, activate!");

        // Test Lang
        //GLib.Environment.set_variable ("LANGUAGE", "pt_br", true);
        if (manager.open_notes.size > 0) {
            show_all ();
        } else {
            manager.init_all_notes ();
        }     
	}

    public void toggle_scribbly () {
        if (Application.gsettings.get_boolean ("scribbly-mode-active")) {
            gsettings.set_boolean ("scribbly-mode-active",false);
        } else {
            gsettings.set_boolean ("scribbly-mode-active",true);
        }
    }

    public void toggle_hidebar () {
        if (Application.gsettings.get_boolean ("hide-bar")) {
            gsettings.set_boolean ("hide-bar",false);
        } else {
            gsettings.set_boolean ("hide-bar",true);
        }
    }

    public void show_all () {
        foreach (var window in manager.open_notes) {
            if (window.visible) {
                window.present ();
            }
        }
    }

    public void on_show_pref () {
        debug ("\nShowing preferences!");
        preferences = new Jorts.PreferenceWindow (this);
        add_window (preferences);
        preferences.show ();
        preferences.present ();
    }

    /*************************************************/
    protected override int command_line (ApplicationCommandLine command_line) {
        string[] args = command_line.get_arguments ();

        switch (args[1]) {
            case "--new-note":
                activate ();

                    /*var data = new Jorts.NoteData (
                        args[2] ?? Jorts.Utils.random_title (),
                        args[3] ?? Jorts.Utils.random_theme (),
                        args[4] ?? "",
                        (int?)args[5] ?? Jorts.Constants.DEFAULT_ZOOM,
                        (int?)args[6] ?? Jorts.Constants.DEFAULT_WIDTH,
                        (int?)args[7] ?? Jorts.Constants.DEFAULT_HEIGHT);
                    */
                    //create_note (data);

                manager.create_note ();
                break;

            case "--preferences":
                activate ();
                on_show_pref ();
                break;

            default:
                activate ();
                break;
        }
    return 0;
    }

    public static int main (string[] args) {
        var app = new Application ();
        return app.run (args);
    }
}

/*
* Copyright (c) 2017 Lains
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
namespace jorts {
    public class Application : Gtk.Application {
        public Gee.ArrayList<MainWindow> open_notes = new Gee.ArrayList<MainWindow>();
        private static bool create_new_window = false;

        public static GLib.Settings gsettings;
        public static Settings animation_settings;
        public Application () {
            Object (flags: ApplicationFlags.HANDLES_COMMAND_LINE,
                    application_id: jorts.Constants.app_rdnn);
        }

	    public int64 latest_zoom;
        private bool squiggly_mode_active = false;

        public override void startup () {
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
            gtk_settings.gtk_theme_name =   "io.elementary.stylesheet." + jorts.Constants.default_theme.ascii_down();

            // Also follow dark if system is dark lIke mY sOul.
            gtk_settings.gtk_application_prefer_dark_theme = (
	                granite_settings.prefers_color_scheme == DARK
                );
	
            granite_settings.notify["prefers-color-scheme"].connect (() => {
                gtk_settings.gtk_application_prefer_dark_theme = (
                        granite_settings.prefers_color_scheme == DARK
                    );
            }); 

            //this.squiggly_mode_active = gsettings.get_boolean ("squiggly_mode_active");

            // build all the stylesheets
            jorts.Themer.init_all_themes();
        }

        static construct {
            gsettings = new GLib.Settings (jorts.Constants.app_rdnn);
        }

        construct {

            var quit_action = new SimpleAction ("quit", null);
            set_accels_for_action ("app.quit", {"<Control>q"});
            add_action (quit_action);
            quit_action.activate.connect (() => {
    	        foreach (MainWindow windows in open_notes) {
                    debug ("Quitting all notes…\n");
    	            windows.close();
    	        }
            });
            var new_action = new SimpleAction ("new", null);
            set_accels_for_action ("app.action_new", {"<Control>n"});
            add_action (new_action);
            new_action.activate.connect (() => {
                create_note(null);
            });
            var delete_action = new SimpleAction ("delete", null);
            set_accels_for_action ("app.action_delete", {"<Control>w"});
            add_action (delete_action);
            delete_action.activate.connect (() => {
                MainWindow note = (MainWindow)get_active_window ();
                remove_note(note);
            });
            var save_action = new SimpleAction ("save", null);
            set_accels_for_action ("app.save", {"<Control>s"});
            add_action (save_action);
            save_action.activate.connect (() => {
                this.save_to_stash ();
            });
            var zoom_out = new SimpleAction ("zoom_out", null);
            set_accels_for_action ("app.zoom_out", { "<Control>minus", "<Control>KP_Subtract", null });
            add_action (zoom_out);
            zoom_out.activate.connect (() => {
                MainWindow note = (MainWindow)get_active_window ();
                note.zoom_out ();
            });
            var zoom_default = new SimpleAction ("zoom_default", null);
            set_accels_for_action ("app.zoom_default", { "<control>0", "<Control>KP_0", null });
            add_action (zoom_default);
            zoom_default.activate.connect (() => {
                MainWindow note = (MainWindow)get_active_window ();
                note.set_zoom (100);
            });
            var zoom_in = new SimpleAction ("zoom_in", null);
            set_accels_for_action ("app.zoom_in", { "<Control>plus", "<Control>equal", "<Control>KP_Add", null });
            add_action (zoom_in);
            zoom_in.activate.connect (() => {
                MainWindow note = (MainWindow)get_active_window ();
                note.zoom_in ();
            });
            var toggle_squiggly = new SimpleAction ("toggle_squiggly", null);
            set_accels_for_action ("app.toggle_squiggly", { "<Control>H", null });
            add_action (toggle_squiggly);
            toggle_squiggly.activate.connect (() => {
                if (this.squiggly_mode_active) {
                    foreach (var window in open_notes) {
                        window.remove_css_class ("squiggly");
                    }
                    this.squiggly_mode_active = false;
                }
                else {
                    foreach (var window in open_notes) {
                        window.add_css_class ("squiggly");
                    }
                    this.squiggly_mode_active = true;
                }
                //this.squiggly_mode_active = gsettings.set_boolean ("squiggly_mode_active", this.squiggly_mode_active);
            });


        }

        // Clicked: Either show all windows, or rebuild from storage
        protected override void activate () {
            
            // Test Lang
            //GLib.Environment.set_variable ("LANGUAGE", "pt_br", true);

            if (get_windows ().length () > 0) {
                foreach (var window in open_notes) {
                    if (window.visible) {
                        window.present ();
                    }
                }
            } else {
                this.init_all_notes ();
            }     
	    }


    // Create new instances of MainWindow
	public void create_note(noteData? data) {
        MainWindow note;
        if (data != null) {
            note = new MainWindow(this, data);
        }
        else {

            // Skip theme from previous window, but use same text zoom
            MainWindow last_note = this.open_notes.last ();
            string skip_theme = last_note.theme;
            var random_data = jorts.Utils.random_note(skip_theme);
            random_data.zoom = this.latest_zoom;
            note = new MainWindow(this, random_data);
        }
        this.open_notes.add(note);
        this.save_to_stash ();
	}

    // Simply remove from the list of things to save, and close
    public void remove_note(MainWindow note) {
            debug ("Removing a note…\n");
            this.open_notes.remove (note);
            this.save_to_stash ();
	}

    public void save_to_stash() {
        jorts.Stash.check_if_stash ();
        string json_data = jorts.Stash.jsonify (open_notes);
        jorts.Stash.overwrite_stash (json_data);
    }





    // the thing that 
    public void init_all_notes() {
        Gee.ArrayList<noteData> loaded_data = jorts.Stash.load_from_stash();

        // If we load nothing: Fallback to a random with blue theme as first
        if (loaded_data.size == 0 ) {
            noteData stored_note    = jorts.Utils.random_note(null);
            stored_note.theme       = jorts.Constants.default_theme ;
            loaded_data.add(stored_note);
        }

        // Load everything we have
        foreach (noteData data in loaded_data) {
            print("Loaded: " + data.title + "\n");
            this.create_note(data);
        }
    }


        protected override int command_line (ApplicationCommandLine command_line) {
            string[] args = command_line.get_arguments ();
            activate ();

            // Create a next window if requested and it's not the app launch
            if (args[1] == "--new-note") {                
                create_note(null);
            } 
            return 0;
        }

        const OptionEntry[] entries = {
            { "--new-note", 'n', 0, OptionArg.NONE, out create_new_window, "New Note", null },
            //  { "--show-all", 'n', 0, OptionArg.NONE, out show_all, "Show All", null },
            { null }
        };

        public static int main (string[] args) {
            var app = new Application();
            return app.run(args);
        }
    }
}

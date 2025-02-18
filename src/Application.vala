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

        public Application () {
            Object (flags: ApplicationFlags.HANDLES_COMMAND_LINE,
                    application_id: "io.github.ellie_commons.jorts");
        }

        public override void startup () {
            base.startup ();

            Intl.setlocale (LocaleCategory.ALL, "");
            Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
            Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
            Intl.textdomain (GETTEXT_PACKAGE);

            // This is automatic in GTK4, so can be removed after porting
            var app_provider = new Gtk.CssProvider ();
            app_provider.load_from_resource ("/io/github/ellie_commons/jorts/Application.css");
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                app_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            jorts.Themer.init_all_themes();
        }

        static construct {
            gsettings = new GLib.Settings ("io.github.ellie_commons.jorts");
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
            set_accels_for_action ("app.new", {"<Control>n"});
            add_action (new_action);
            new_action.activate.connect (() => {
                create_note(null);
            });
            var delete_action = new SimpleAction ("delete", null);
            set_accels_for_action ("app.delete", {"<Control>w"});
            add_action (delete_action);
            delete_action.activate.connect (() => {
                MainWindow note = (MainWindow)get_active_window ();
                remove_note(note);

                note.destroy();
            });
        }

        // Either show all windows, or rebuild from storage
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

                Gee.ArrayList<noteData> loaded_data = jorts.Stash.load_from_stash();

                if (loaded_data.size == 0 ) {
                    noteData stored_note    = jorts.Utils.random_note();
                    stored_note.theme       = "BLUEBERRY" ;
                    loaded_data.add(stored_note);
                }

                foreach (noteData data in loaded_data) {
                    print("Loaded: " + data.title + "\n");
                    this.create_note(data);
                }
            }
                    
	}


    // create new instances of MainWindow
	public void create_note(noteData? data) {
        MainWindow note;
        if (data != null) {
            note = new MainWindow(this, data);
        }
        else {
            var random_data = jorts.Utils.random_note();
            note = new MainWindow(this, random_data);
        }
        this.open_notes.add(note);
	}

    // Simply remove from the list of things to save, and close
    public void remove_note(MainWindow note) {
            debug ("Removing a note…\n");
            this.open_notes.remove (note);
	}

    public void save_to_stash() {
        jorts.Stash.check_if_stash ();
        string json_data = jorts.Stash.jsonify (open_notes);
        jorts.Stash.overwrite_stash (json_data);
    }

        protected override int command_line (ApplicationCommandLine command_line) {
            var context = new OptionContext ("File");
            //context.add_main_entries (entries, Build.GETTEXT_PACKAGE);
            context.add_group (Gtk.get_option_group (true));

            string[] args = command_line.get_arguments ();
            int unclaimed_args;

            activate ();

            try {
                context.parse_strv (ref args);
                unclaimed_args = args.length - 1;
            } catch(Error e) {
                print (e.message + "\n");

                return 1;
            }

            // Create a next window if requested and it's not the app launch
            if (create_new_window) {
                create_new_window = false;
                create_note(null);
            }
            return 0;
        }

        const OptionEntry[] entries = {
            { "new-note", 'n', 0, OptionArg.NONE, out create_new_window, "New Note", null },
            { null }
        };

        public static int main (string[] args) {
            var app = new Application();
            return app.run(args);
        }
    }
}

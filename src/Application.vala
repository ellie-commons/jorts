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
Application creates a NoteManager, which is the OG thing that does the heavy lifting.
NoteManager retrieves a list of NoteData from the Stash
Then it untangles it and creates a list of windows it can keep track of.

When a note get deleted, the window signals to the manager to remove it from the list
When a new note is requested, the manager creates a new window and adds it
When saving is requested, the manager goes though the whole list requesting every window to package itself, then slams all onto disk.

The Preferences window is supposed to be a static window.

NoteData is a convenience object to pass around sticky notes
Stash deals with writing/loading from the disk
Themer spits the different themes upon startup
Utils spits all the random
Jason deals with all the hassle in between all saving/loading steps
Constants is because i am lazy
*/

public class Jorts.Application : Gtk.Application {

    // Needed by all windows
    public static GLib.Settings gsettings;
    public Jorts.NoteManager manager;

    // There can be only one
    private static Jorts.PreferenceWindow preferences;

    // Used for commandline option handling
    private bool new_note = false;
    private bool show_pref = false;

    public const string ACTION_PREFIX = "app.";
    public const string ACTION_QUIT = "action_quit";
    public const string ACTION_NEW = "action_new";
    public const string ACTION_DELETE = "action_delete";
    public const string ACTION_ZOOM_OUT = "action_zoom_out";
    public const string ACTION_ZOOM_DEFAULT = "action_zoom_default";
    public const string ACTION_ZOOM_IN = "action_zoom_in";
    public const string ACTION_TOGGLE_SCRIBBLY = "action_toggle_scribbly";
    public const string ACTION_TOGGLE_ACTIONBAR = "action_toggle_actionbar";
    public const string ACTION_SHOW_PREFERENCES = "action_show_preferences";
    public const string ACTION_SHOW_MENU = "action_menu";
    public const string ACTION_SHOW_EMOTE = "action_emote";
    public const string ACTION_SAVE = "action_save";
    public const string ACTION_FOCUS_TITLE = "action_focus_title";

    public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_QUIT, quit},
        { ACTION_NEW, action_new },
        { ACTION_DELETE, action_delete},
        { ACTION_ZOOM_OUT, action_zoom_out},
        { ACTION_ZOOM_DEFAULT, action_zoom_default},
        { ACTION_ZOOM_IN, action_zoom_in},
        { ACTION_TOGGLE_SCRIBBLY, action_toggle_scribbly},
        { ACTION_TOGGLE_ACTIONBAR, action_toggle_actionbar},
        { ACTION_SHOW_PREFERENCES, action_show_preferences},
        { ACTION_SHOW_MENU, quit},
        { ACTION_SHOW_EMOTE, quit},
        { ACTION_SAVE, action_save},
        { ACTION_FOCUS_TITLE, action_focus_title}
    };

    public Application () {
        Object (flags: ApplicationFlags.HANDLES_COMMAND_LINE,
                application_id: Jorts.Constants.RDNN);
    }

    /*************************************************/
    public override void startup () {
        debug ("Jorts startup sequence…");
        base.startup ();
        Granite.init ();

        add_action_entries (ACTION_ENTRIES, this);
        set_accels_for_action ("app.action_quit", {"<Control>Q"});
        set_accels_for_action ("app.action_new", {"<Control>N"});
        set_accels_for_action ("app.action_delete", {"<Control>W"});
        set_accels_for_action ("app.action_save", {"<Control>S"});
        set_accels_for_action ("app.action_zoom_out", {"<Control>minus", "<Control>KP_Subtract"});
        set_accels_for_action ("app.action_zoom_default", {"<Control>equal", "<control>0", "<Control>KP_0"});
        set_accels_for_action ("app.action_zoom_in", {"<Control>plus", "<Control>KP_Add"});
        set_accels_for_action ("app.action_toggle_scribbly", {"<Control>H"});
        set_accels_for_action ("app.action_toggle_actionbar", {"<Control>T"});
        set_accels_for_action ("app.action_show_preferences", {"<Control>P"});
        set_accels_for_action ("app.action_focus_title", {"<Control>L"});

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
        // The localization thingamabob
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (GETTEXT_PACKAGE);
        
        manager = new Jorts.NoteManager (this);
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

        if (new_note) {
            manager.create_note ();
            new_note = false;
        }

        if (show_pref) {
            action_show_preferences ();
            show_pref = false;
        }
	}

    public void show_all () {
        foreach (var window in manager.open_notes) {
            if (window.visible) {
                window.present ();
            }
        }
    }


    public override int command_line (ApplicationCommandLine command_line) {
        debug ("Parsing commandline arguments...");

        OptionEntry[] options = new OptionEntry[2];
        options[0] = {
            "new-note", 0, 0, OptionArg.NONE,
            ref new_note, _("Create a new note"), null
        };
        options[1] = {
            "preferences", 0, 0, OptionArg.NONE,
            ref show_pref, _("Show preferences"), null
        };

        // We have to make an extra copy of the array, since .parse assumes
        // that it can remove strings from the array without freeing them.
        string[] args = command_line.get_arguments ();
        string[] _args = new string[args.length];
        for (int i = 0; i < args.length; i++) {
            _args[i] = args[i];
        }

        try {
            var ctx = new OptionContext ();
            ctx.set_help_enabled (true);
            ctx.add_main_entries (options, null);
            unowned string[] tmp = _args;
            ctx.parse (ref tmp);
        } catch (OptionError e) {
            command_line.print ("error: %s\n", e.message);
            return 0;
        }

        hold ();
        activate ();
        return 0;
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }

    private void action_new () {
        manager.create_note ();
    }

    private void action_delete () {
        manager.delete_note ((StickyNoteWindow)active_window);

    }

    private void action_zoom_out () {
        ((StickyNoteWindow)active_window).zoom_out ();
    }

    private void action_zoom_default () {
        ((StickyNoteWindow)active_window).zoom_default ();
    }

    private void action_zoom_in () {
        ((StickyNoteWindow)active_window).zoom_in ();
    }

    private void action_show_preferences () {
        debug ("\nShowing preferences!");
        preferences = new Jorts.PreferenceWindow (this);
        preferences.show ();
        preferences.present ();
    }

    private void action_toggle_scribbly () {
        if (Application.gsettings.get_boolean ("scribbly-mode-active")) {
            gsettings.set_boolean ("scribbly-mode-active",false);
        } else {
            gsettings.set_boolean ("scribbly-mode-active",true);
        }
    }

    private void action_toggle_actionbar () {
        if (Application.gsettings.get_boolean ("hide-bar")) {
            gsettings.set_boolean ("hide-bar",false);
        } else {
            gsettings.set_boolean ("hide-bar",true);
        }
    }

    private void action_save () {
        manager.save_to_stash ();
    }

    private void action_focus_title () {
        ((StickyNoteWindow)active_window).action_focus_title ();
    }
}

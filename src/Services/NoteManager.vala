/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

// The NoteData object is just packaging to pass off data from and to storage
public class Jorts.NoteManager : Object {

    public Gee.ArrayList<StickyNoteWindow> open_notes = new Gee.ArrayList<StickyNoteWindow> ();
	public int latest_zoom;
    public Gtk.Application application;

    public NoteManager (Jorts.Application app) {
        this.application = app;
    }

    public void init_all_notes () {
        debug ("Opening all sticky notes now!");
        Gee.ArrayList<NoteData> loaded_data = Jorts.Stash.load_from_stash();

        // Load everything we have
        foreach (NoteData data in loaded_data) {
            debug ("Loaded: " + data.title + "\n");
            this.create_note (data);
        }

        if (Jorts.Stash.need_backup (Application.gsettings.get_string ("last-backup"))) {
            print ("Doing a backup! :)");

            Jorts.Stash.check_if_stash ();
            string json_data = Jorts.Jason.jsonify (open_notes);
            Jorts.Stash.overwrite_stash (json_data, Jorts.Constants.FILENAME_BACKUP);

            var now = new DateTime.now_utc ().to_string () ;
            Application.gsettings.set_string ("last-backup", now);
        }

        on_reduceanimation_changed ();
        Gtk.Settings.get_default ().notify["enable-animations"].connect (on_reduceanimation_changed);
    }

    // Create new instances of StickyNoteWindow
    // If we have data, nice, just load it into a new instance
    // Else we do a lil new note
	public void create_note (NoteData? data = null) {
        debug ("Lets do a note");

        StickyNoteWindow note;
        if (data != null) {
            note = new StickyNoteWindow (application, data);
        }
        else {

            // Skip theme from previous window, but use same text zoom
            StickyNoteWindow last_note = open_notes.last ();
            string skip_theme = last_note.theme;
            var random_data = Jorts.Utils.random_note (skip_theme);

            // If the user requested from clipboard, then we gotta grab content from there
            if (application.new_from_clipboard)
            {
                // Overwrite random title to say "Clipboard content?..."
                random_data.content = application.clipboard_content;
                application.clipboard_content = "";

            } else {

                // A chance at pulling the Golden Sticky
                // No chocolate factory involved
                random_data = Jorts.Utils.golden_sticky (random_data);
            }

            random_data.zoom = this.latest_zoom;
            note = new StickyNoteWindow (application, random_data);
        }

        /* LETSGO */
        open_notes.add (note);
        note.present ();
        save_to_stash ();
	}

    // When user asked for a new note and for it to be pasted in
    public void from_clipboard () {
        debug ("Creating and loading from clipboard…");

        // If the app has only one empty note (or no note but just created one),
        // Then paste in it.
        if ((open_notes.length > 1) && open_notes[0].textview.text == "") {
            var note = open_notes[0];

        } else {
            // Skip theme from previous window, but use same text zoom
            StickyNoteWindow last_note = open_notes.last ();
            string skip_theme = last_note.theme;
            var random_data = Jorts.Utils.random_note (skip_theme);
            random_data.zoom = this.latest_zoom;
            note = new StickyNoteWindow (application, random_data);
            open_notes.add (note);
        }

        note.textview.paste ();
        note.present ();
        save_to_stash ();
	}


    // Simply remove from the list of things to save, and close
    public void delete_note (StickyNoteWindow note) {
            debug ("Removing a note…");
            open_notes.remove (note);
            note.close ();
            this.save_to_stash ();
	}

    public void save_to_stash () {
        debug ("Save the stickies!");

        Jorts.Stash.check_if_stash ();
        string json_data = Jorts.Jason.jsonify (open_notes);
        Jorts.Stash.overwrite_stash (json_data, Jorts.Constants.FILENAME_STASH);
        //print ("\nSaved " + open_notes.size.to_string () + "!");
    }

      // Called when the window is-active property changes
    public void on_reduceanimation_changed () {
        debug ("Reduce animation changed!");

        if (Gtk.Settings.get_default ().gtk_enable_animations) {
            foreach (var window in open_notes) {
                window.add_css_class ("animated");
            }

        } else {
            foreach (var window in open_notes) {
                // If we remove without checking we get a critical
                if ("animated" in window.css_classes) {
                    window.remove_css_class ("animated");
                }
            }
        }
    }
}

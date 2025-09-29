/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* Responsible for keeping track of various Sticky Notes windows
* It does its thing on its own. Make sure to call init() to summon all notes from storage
*/
public class Jorts.NoteManager : Object {

    private Jorts.Application application;
    public Gee.ArrayList<StickyNoteWindow> open_notes;
    public Jorts.Storage storage;

    public NoteManager (Jorts.Application app) {
        this.application = app;
    }

    construct {
        open_notes = new Gee.ArrayList<StickyNoteWindow> ();
        storage = new Jorts.Storage ();
    }

    /*************************************************/
    /**
    * Retrieve data from storage, and loop through it to create notes
    * Keep an active list of Windows.
    * We do not do this at construct time so we stay flexible whenever we want to init
    * NoteManager is also created too early by the app for new windows
    */    
    public void init () {
        debug ("[MANAGER] Opening all sticky notes now!");
        Json.Array loaded_data = storage.load ();

        if (loaded_data.get_length () == 0) {
            var note_data = new NoteData.from_random ();
            note_data.theme = Constants.DEFAULT_THEME;
            create_note (note_data);

        } else {
            foreach (var json_data in loaded_data.get_elements()) {
                var json_obj = json_data.dup_object ();
                var note_data = new NoteData.from_json (json_obj);

                print ("\nLoaded: " + note_data.title);
                create_note (note_data);
            }
        }

        on_reduceanimation_changed ();
        Gtk.Settings.get_default ().notify["enable-animations"].connect (on_reduceanimation_changed);
    }

    /*************************************************/
    /**
    * Create new instances of StickyNoteWindow
    * Should we have data, we can pass it off, else create from random data
    * If we have data, nice, just load it into a new instance. Else we do a lil new note
    */
    public void create_note (NoteData? data = null) {
        debug ("[MANAGER] Lets do a note");
        Jorts.StickyNoteWindow note;

        if (data != null) {
            note = new StickyNoteWindow (application, data);
        }
        else {
            var random_data = new NoteData.from_random ();
            
            // One chance at the golden sticky
            random_data = Jorts.Utils.golden_sticky (random_data);
            note = new StickyNoteWindow (application, random_data);
        }
        
        /* LETSGO */
        open_notes.add (note);
        note.show ();
        note.present ();
        save_all ();

	}

    /*************************************************/
    /**
    * When user asked for a new note and for it to be pasted in
    */
    public void from_clipboard () {
        debug ("[MANAGER] Creating and loading from clipboard…");
        print ("clipboard!");
        Jorts.StickyNoteWindow note;

        // If the app has only one empty note (or no note but just created one),
        // Then paste in it.
        if ((open_notes.size == 1) && open_notes[0].textview.buffer.text == "") {
            note = open_notes[0];
            print ("first one");

        } else {
            // Skip theme from previous window, but use same text zoom
            var random_data = new NoteData.from_random ();
            note = new StickyNoteWindow (application, random_data);
            open_notes.add (note);
            print ("new");
        }

        note.show ();
        note.present ();
        note.textview.paste ();          
	}

    /*************************************************/
    /**
    * Delete a note by remove it from the active list and closing its window
    */
    public void delete_note (StickyNoteWindow note) {
        debug ("[MANAGER] Removing a note…");

        open_notes.remove (note);
        note.close ();
        save_all ();
	}

    /*************************************************/
    /**
    * Cue to immediately write from the active list to the storage
    */
    public void save_all () {
        debug ("[MANAGER] Save the stickies!");
        var array = new Json.Array ();

        foreach (Jorts.StickyNoteWindow note in open_notes) {
            var data = note.packaged ();
            var object = data.to_json ();
            array.add_object_element (object);
        };

        storage.save (array);        
    }

    /*************************************************/
    /**
    * Handler to add or remove CSS animations from all active notes
    */
    public void on_reduceanimation_changed () {
        debug ("[MANAGER] Reduce animation changed!");

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


    /*************************************************/
    public void dump () {storage.dump ();}
}

/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2025 Stella & Charlie (teamcons.carrd.co) and the Ellie_Commons community (github.com/ellie-commons/)
 */

/*

load_node
--> Json.Object representing a NoteData, that we convert into one
TODO: move this shit into Objects

jsonify
--> Convert an array of windows into a long json string
Used by the main application to get everything in a convenient form for storage

load_parser
--> takes the loaded content from storage, spits an array with sticky notes data
used by the stash upon loading a storage file, passed on to Application to start new windows





*/

namespace Jorts.Jason {

    /*************************************************/
    // Takes a single node, tries its best to get its content.
    // Does not fail if something is missing or unreadable, go to fallback for the element instead
    public Jorts.NoteData load_node (Json.Object node) {

        string title    = node.get_string_member_with_default ("title",(_("Forgot title!")));
        string theme    = node.get_string_member_with_default ("theme",Jorts.Utils.random_theme (null));
        string content  = node.get_string_member_with_default ("content","");

        // TODO: If this one fails, whole note fails...
        int64 zoom      = node.get_int_member_with_default ("zoom",Jorts.Constants.DEFAULT_ZOOM);

        if (zoom < Jorts.Constants.ZOOM_MIN) {
            zoom = Jorts.Constants.ZOOM_MIN;
        } else if (zoom > Jorts.Constants.ZOOM_MAX) {
            zoom = Jorts.Constants.ZOOM_MAX;
        }

        int64 width      = node.get_int_member_with_default ("width",Jorts.Constants.DEFAULT_WIDTH);
        int64 height      = node.get_int_member_with_default ("height",Jorts.Constants.DEFAULT_HEIGHT);

        Jorts.NoteData loaded_note = new Jorts.NoteData (
            title,
            theme,
            content,
            (int)zoom,
            (int)width,
            (int)height);

        return loaded_note;
    }

    /*************************************************/
    // Loop through the list of windows and convert it into a giant json string
    public string jsonify (Gee.ArrayList<Jorts.StickyNoteWindow> notes) {
        Json.Builder builder = new Json.Builder ();
        builder.begin_array ();
        foreach (Jorts.StickyNoteWindow note in notes) {
            Jorts.NoteData data = note.packaged ();
            //print("saving " + note.title_name + "\n");

			// Lets fkin gooo
            builder.begin_object ();
            builder.set_member_name ("title");
            builder.add_string_value (data.title);
            builder.set_member_name ("theme");
            builder.add_string_value (data.theme);
            builder.set_member_name ("content");
            builder.add_string_value (data.content);
			builder.set_member_name ("zoom");
            builder.add_int_value (data.zoom);
            builder.set_member_name ("height");
            builder.add_int_value (data.height);
            builder.set_member_name ("width");
            builder.add_int_value (data.width);
            builder.end_object ();
        };
        builder.end_array ();

        Json.Generator generator = new Json.Generator ();
        Json.Node root = builder.get_root ();
        generator.set_root (root);
        string str = generator.to_data (null);
        return str;
    }

    /*************************************************/    
    public Gee.ArrayList<Jorts.NoteData> load_parser (Json.Parser parser) {
        Gee.ArrayList<Jorts.NoteData> loaded_data = new Gee.ArrayList<Jorts.NoteData>();

        var root = parser.get_root ();
        var array = root.get_array ();

        foreach (var item in array.get_elements()) {
            var stored_note = Jorts.Jason.load_node(item.get_object());
            loaded_data.add (stored_note);
        }

        return loaded_data;
    }
}

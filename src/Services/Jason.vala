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

load_node
--> Json.Object representing a noteData, that we convert into one
TODO: move this shit into Objects

jsonify
--> Convert an array of windows into a long json string
Used by the main application to get everything in a convenient form for storage

load_parser
--> takes the loaded content from storage, spits an array with sticky notes data
used by the stash upon loading a storage file, passed on to Application to start new windows





*/

namespace jorts.Jason {

    /*************************************************/
    // Takes a single node, tries its best to get its content.
    // Does not fail if something is missing or unreadable, go to fallback for the element instead
    public jorts.noteData load_node(Json.Object node) {

        string title    = node.get_string_member_with_default("title",(_("Forgot title!")));
        string theme    = node.get_string_member_with_default("theme",jorts.Utils.random_theme(null));
        string content  = node.get_string_member_with_default("content","");

        // TODO: If this one fails, whole note fails...
        int64 zoom      = node.get_int_member_with_default("zoom",jorts.Constants.DEFAULT_ZOOM);

        if (zoom < jorts.Constants.ZOOM_MIN) {
            zoom = jorts.Constants.ZOOM_MIN;
        } else if (zoom > jorts.Constants.ZOOM_MAX) {
            zoom = jorts.Constants.ZOOM_MAX;
        }

        int64 width      = node.get_int_member_with_default("width",jorts.Constants.DEFAULT_WIDTH);
        int64 height      = node.get_int_member_with_default("height",jorts.Constants.DEFAULT_HEIGHT);

        jorts.noteData loaded_note = new jorts.noteData(title, theme, content, (int)zoom, (int)width, (int)height);
        return loaded_note;
    }

    /*************************************************/
    // Loop through the list of windows and convert it into a giant json string
    public string jsonify (Gee.ArrayList<jorts.MainWindow> notes) {
        Json.Builder builder = new Json.Builder ();
        builder.begin_array ();
        foreach (jorts.MainWindow note in notes) {
            jorts.noteData data = note.packaged ();
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
    public Gee.ArrayList<jorts.noteData> load_parser(Json.Parser parser) {
        Gee.ArrayList<jorts.noteData> loaded_data = new Gee.ArrayList<jorts.noteData>();

        var root = parser.get_root();
        var array = root.get_array();
        
        foreach (var item in array.get_elements()) {
            var stored_note = jorts.Jason.load_node(item.get_object());
            loaded_data.add(stored_note);
        }

        return loaded_data;
    }

}
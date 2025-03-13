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
check_if_stash()
--> Check if we have a data directory. If not create one.

jsonify(Gee.ArrayList<MainWindow>)
--> take all note instances, and gulps back a giant json string

overwrite_stash(json_string)
--> Dump all it has in a saved_state.json

save_to_stash(Note)
--> Dump all it has in a saved_state.json

load_from_stash()
--> loads the json file and parse it into a list of noteData

*/

namespace jorts.Stash {

	// Ok first check if we have a directory to store data
	public void check_if_stash() {

		var data_directory  = File.new_for_path(Environment.get_user_data_dir ());	
		try {
			if (!data_directory.query_exists()) {
				data_directory.make_directory();
				print("Prepared target data directory");
			}
		} catch (Error e) {
			warning ("Failed to prepare target data directory %s\n", e.message);
		}

	}

    // Loop through the list of windows and convert it into a giant json string
    public string jsonify (Gee.ArrayList<MainWindow> notes) {
        Json.Builder builder = new Json.Builder ();
        builder.begin_array ();
        foreach (MainWindow note in notes) {
            noteData data = note.packaged ();
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
            builder.set_member_name ("width");
            builder.add_int_value (data.width);
            builder.set_member_name ("height");
            builder.add_int_value (data.height);
            builder.end_object ();
        };
        builder.end_array ();

        Json.Generator generator = new Json.Generator ();
        Json.Node root = builder.get_root ();
        generator.set_root (root);
        string str = generator.to_data (null);
        return str;
    }


    // Just slams a json in the storage file
    // TODO: Simplify this
    public void overwrite_stash(string json_data) {

        string data_directory = Environment.get_user_data_dir ();
        string storage_path = data_directory + "/saved_state.json";
    
        var dir = File.new_for_path(data_directory);
        var file = File.new_for_path (storage_path);

        try {
            if (!dir.query_exists()) {
                dir.make_directory();
            }

            if (file.query_exists ()) {
                file.delete ();
            }

            var file_stream = file.create (FileCreateFlags.REPLACE_DESTINATION);
            var data_stream = new DataOutputStream (file_stream);
            data_stream.put_string(json_data);
        } catch (Error e) {
            warning ("Failed to save notes %s\n", e.message);
        }

    }

    // Takes a single node, tries its best to get its content.
    // Does not fail if something is missing or unreadable, go to fallback for the element instead
    public jorts.noteData load_node(Json.Object node) {

        string title    = node.get_string_member_with_default("title",(_("Forgot title!")));
        string theme    = node.get_string_member_with_default("theme",jorts.Utils.random_theme(null));
        string content  = node.get_string_member_with_default("content","");
        int64 zoom      = node.get_int_member_with_default("zoom",jorts.Constants.default_zoom);
        int64 width     = node.get_int_member_with_default("width",jorts.Constants.default_width);
        int64 height    = node.get_int_member_with_default("height",jorts.Constants.default_height);

        noteData loaded_note = new noteData(title, theme, content, zoom, width, height);
        return loaded_note;
    }



    // Handles the whole loading. If there is nothing, just start with a blue one
    public Gee.ArrayList<noteData> load_from_stash() {
        Gee.ArrayList<noteData> loaded_data = new Gee.ArrayList<noteData>();
        string data_directory = Environment.get_user_data_dir ();
        string storage_path = data_directory + "/saved_state.json";
    
        var file = File.new_for_path (storage_path);
        if (file.query_exists()) {

                // TODO: If the Json is mangled, there is a risk Jorts starts from a blank slate and overwrites it
                // We should do a backup of the mangled json before overwriting
                var parser = new Json.Parser();

                try {
                    parser.load_from_mapped_file (storage_path);
                    var root = parser.get_root();
                    var array = root.get_array();

                    foreach (var item in array.get_elements()) {
                        var stored_note = jorts.Stash.load_node(item.get_object());
                        loaded_data.add(stored_note);
                    }

                } catch (Error e) {
                    warning ("Failed to load file: %s\n", e.message);
                }

        } else {
                noteData stored_note    = jorts.Utils.random_note(null);
                stored_note.theme       = jorts.Constants.default_theme ;
                loaded_data.add(stored_note);
        }

        return loaded_data;
    }
}

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
    public void overwrite_stash(string json_data, string file_overwrite) {

        string data_directory = Environment.get_user_data_dir ();
        string storage_path = data_directory + "/" + file_overwrite;
    
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
        int64 zoom      = node.get_int_member_with_default("zoom",jorts.Constants.DEFAULT_ZOOM);
        int64 width     = node.get_int_member_with_default("width",jorts.Constants.DEFAULT_WIDTH);
        int64 height    = node.get_int_member_with_default("height",jorts.Constants.DEFAULT_HEIGHT);

        noteData loaded_note = new noteData(title, theme, content, zoom, width, height);
        return loaded_note;
    }

    public Gee.ArrayList<noteData> load_parser(Json.Parser parser) {
        Gee.ArrayList<noteData> loaded_data = new Gee.ArrayList<noteData>();

        var root = parser.get_root();
        var array = root.get_array();
        
        foreach (var item in array.get_elements()) {
            var stored_note = jorts.Stash.load_node(item.get_object());
            loaded_data.add(stored_note);
        }

        return loaded_data;
    }



    // Handles the whole loading. If there is nothing, just start with a blue one
    // We first try from main storage
    // If that fails, we go for backup
    // Still failing ? Start anew
    public Gee.ArrayList<noteData> load_from_stash() {
        Gee.ArrayList<noteData> loaded_data = new Gee.ArrayList<noteData>();
        string data_directory = Environment.get_user_data_dir ();
        string storage_path = data_directory + "/" + jorts.Constants.FILENAME_STASH;
        string backup_path = data_directory + "/" + jorts.Constants.FILENAME_BACKUP;

        var parser = new Json.Parser();

        // Try standard storage
        try {
            parser.load_from_mapped_file (storage_path);
            loaded_data = load_parser(parser);

        } catch (Error e) {
            print("[WARNING] Failed to load from main storage! " + e.message.to_string() + "\n");
            
            // Try backup file
            try {
                parser.load_from_mapped_file (backup_path);
                loaded_data = load_parser(parser);

            } catch (Error e) {

                // Nothing works
                print("[WARNING] Failed to load from BACKUP!!! " + e.message.to_string() + "\n");

            }


        }

        // If we load nothing: Fallback to a random with blue theme as first
        if (loaded_data.size == 0 ) {
            noteData blank_slate    = jorts.Utils.random_note(null);
            blank_slate.theme       = jorts.Constants.DEFAULT_THEME ;
            loaded_data.add(blank_slate);
        }

        return loaded_data;

    }




	// We first check if we have a backup or a last saved date
    // if none of those two, tell we need immediate backup
    // else, then depending how old we know the backup to be
	public bool need_backup(string last_backup) {
        debug("lets check if we need to backup");

        string data_directory = Environment.get_user_data_dir ();
        string backup_path = data_directory + "/" + jorts.Constants.FILENAME_BACKUP;
        var file = File.new_for_path (backup_path);

        if ((last_backup == "") || (file.query_exists() == false)) {

            return true;

        } else {
            var now = new DateTime.now_utc () ;
            var date_last_backup = new DateTime.from_iso8601 (last_backup, null);
            TimeSpan date_diff = now.difference(date_last_backup);
            var days_in_micro = jorts.Constants.DAYS_BETWEEN_BACKUPS * TimeSpan.DAY;
            return (date_diff > days_in_micro);
        }
    }



}

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

count_saved_notes(Note)
--> return a number
----> counts the number of files in the data dir (theyre all saved_state_id.json)

save_to_stash(Note)
--> Dump all it has in a saved_state_uid.json

load_from_stash(uid)
--> loads saved note "uid" as note

nuke_from_stash(uid)
--> Delete saved_state_uid.json
*/



namespace jorts.Stash {

	// Ok first check if we have a directory to store data
	public void check_if_stash() {
        print("Checking if data directory present\n");
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



	// lol just count how many files in the data dir
  	public int count_saved_notes() {
		string user_data_dir = Environment.get_user_data_dir ();
        int filecount = 0;

        check_if_stash();
        try {
            var dir = Dir.open (user_data_dir);
            unowned string? file_name;

            while ((file_name = dir.read_name ()) != null) {
                print (file_name);
                filecount = filecount + 1;
            }

        } catch (Error e) {
            warning ("Failed to read data dir %s\n", e.message);
        }

        print ("There are " + filecount.to_string() + " Rs in Strawberry") ;
		return filecount;
	}  




	// Takes a NoteData, slams it in a json file with its uid
    public void save_to_stash(noteData note) {
		print("Saving " + note.uid.to_string() + " to stash\n");
       	Json.Builder builder = new Json.Builder ();

			// Lets fkin gooo
            builder.begin_object ();
            builder.set_member_name ("title");
            builder.add_string_value (note.title);
            builder.set_member_name ("theme");
            builder.add_string_value (note.theme);
            builder.set_member_name ("content");
            builder.add_string_value (note.content);
			builder.set_member_name ("zoom");
            builder.add_int_value (note.zoom);
            builder.set_member_name ("width");
            builder.add_int_value (note.width);
            builder.set_member_name ("height");
            builder.add_int_value (note.height);
            builder.end_object ();

        Json.Generator generator = new Json.Generator ();
       	Json.Node root = builder.get_root ();
        generator.set_root (root);
        string json_string = generator.to_data (null);

		/* Then we handle slamming it all where it do be do */
		string file_path = Environment.get_user_data_dir () + "/saved_state_" + note.uid.to_string() + ".json";
        var fileObject = File.new_for_path (file_path);
		check_if_stash();

		/* remove previous saved state if there is one already */
        try {
            if (fileObject.query_exists ()) {
                fileObject.delete ();
            }
            var file_stream = fileObject.create (FileCreateFlags.REPLACE_DESTINATION);
            var data_stream = new DataOutputStream (file_stream);
            data_stream.put_string(json_string);
        } catch (Error e) {
            warning ("Failed to save notes %s\n", e.message);
        }

    }


    public bool is_in_stash(int uid) {
		var file_name = Environment.get_user_data_dir () + "/saved_state_" + uid.to_string() + ".json" ;
        var file = File.new_for_path(file_name);

        return file.query_exists();
    }

 
	// read and spit back
  	public noteData load_from_stash(int uid) {
        print("Loading UID" + uid.to_string());

        noteData data = new noteData(uid, "","BLUEBERRY","",100,330,270);
		var file_name = Environment.get_user_data_dir () + "/saved_state_" + uid.to_string() + ".json" ;
        var file = File.new_for_path(file_name);
        var json_string = "";

            try {
                if (file.query_exists()) {

                    print("Ok, " + file_name + " exists");
                    string line;
                    var dis = new DataInputStream (file.read ());

                    while ((line = dis.read_line (null)) != null) {
                        json_string += line;
                    }

                    var parser = new Json.Parser();
                    parser.load_from_data(json_string);
                    var node = parser.get_root().get_object();

                    string title = node.get_string_member("title");
                    string theme = node.get_string_member("theme");
                    string content = node.get_string_member("content");
				    int64 zoom = node.get_int_member("zoom");
                    int64 width = node.get_int_member("width");
                    int64 height = node.get_int_member("height");

                    // somehow cant do it directly
                    data.title = title;
                    data.theme = theme;
                    data.content = content;
                    data.zoom = zoom;
                    data.width = width;
                    data.height = height;
                } else {
                    print(file_name + " does not exist");
                }
            } catch (Error e) {
                warning ("Failed to load file: %s\n", e.message);
            }
        return data;
    }





  	
	// Takes an uid, just delete relevant json file
    public void nuke_from_stash(int uid) {

		string file_path = Environment.get_user_data_dir () + "/saved_state_" + uid.to_string() + ".json";
        var fileObject = File.new_for_path (file_path);

		try {
            fileObject.delete ();
        } catch (Error e) {
            warning ("Cannot delete note %s\n", e.message);
        }
    }






}

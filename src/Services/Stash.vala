/*
* Copyright (c) 2017-2024 Lains
* Copyright (c) 2025 Teamcons and Ellie_Commons
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
TODO

Current notemanaging is not super straightforward, so, battleplan:



We want:

1/ Application does the following:
Have an uid_counter, starting at 0


For all the "saved_sticky_" + uid_counter + ".json"

Create an instance of mainwindow and give it to it

count uid_counter +1

If not, stop. We have 



##################

-Each MainWindow (new note) gets assigned by the app an UID

The app will sort itself out with size, colour, label, whatever

It can count on support functions:


Object Note:
-int uid
-string Title
-string Theme
-string Content
-int Zoom
-double int (Width, height)


count_saved_stash(Note)
--> return a number
----> counts the number of files in the data dir (theyre all saved_state_id.json)



load_from_stash(Note
--> return a Note object
Check at init if uid is 0. If it is, try loading. If it doesnt, itll be blueberry and save to stast


save_to_stash(Note)
--> Dump all it has in a saved_state_uid.json


nuke_from_stash(uid)
--> Delete saved_sticky_uid.json


*/



namespace jorts {


public int count_notes() {
	string user_data_dir = Environment.get_user_data_dir ();
	var data_directory  = File.new_for_path(user_data_dir);	

	try {
		if (!data_directory.query_exists()) {
			data_directory.make_directory();
			print("Had to prepare target data directory");
		}
	} catch (Error e) {
		warning ("Failed to prepare target data directory %s\n", e.message);
	}

	return 4;


}



//  /*  	
//  		/* Takes an uid, delete its storage*/
//          public void nuke_from_stash(int uid) {
//          	string data_path =  "saved_sticky_" + uid + ".json";
//              	debug ("%s".printf(data_path));

//  			var file = File.new_for_path (data_path);
//              	try {
//                  	if (file.query_exists ()) {
//                      		file.delete 
//  			}
//              	} catch (Error e) {
//                  	warning ("Cannot delete UID " + uid + "!\n", e.message);
//              	}
//          }
//    */


		/* Takes a NoteData, slams it in a json file with its uid */
        public void save_to_stash(noteData note) {

			print("Saving " + note.uid.to_string() + " to stash\n");

			/* First all infos are grouped in a json */
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


}

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

load_from_stash(uid)
--> You get a title, theme, content, x, y, height, width
Check at init if uid is 0. If it is, try loading. If it doesnt, itll be blueberry and save to stast


save_to_stash(uid, title, theme, content, x, y, height, width)
--> Dump all it has in a saved_sticky_uid.json


nuke_from_stash(uid)
--> Delete saved_sticky_uid.json


*/



namespace jorts {


	*/ Takes an uid, delete its storage*/
        public void nuke_from_stash(uid) {
        	string data_path = Environment.get_user_data_dir () + "saved_sticky_" + uid + ".json";
            	debug ("%s".printf(data_path));

		var file = File.new_for_path (data_path);
            	try {
                	if (file.query_exists ()) {
                    		file.delete 
			}
            	} catch (Error e) {
                	warning ("Cannot delete UID " + uid + "!\n", e.message);
            	}
        }




        public void save_to_stash(uid, title, theme, content, x, y, height, width) {
		
		/* First all infos are grouped in a json */
        	Json.Builder builder = new Json.Builder ();
            	builder.begin_array ();
            	foreach (Storage note in notes) {
	                builder.begin_object ();
	                builder.set_member_name ("title");
	                builder.add_string_value (note.title);
	                builder.set_member_name ("theme");
	                builder.add_string_value (note.theme);
	                builder.set_member_name ("content");
	                builder.add_string_value (note.content);
	                builder.set_member_name ("x");
	                builder.add_int_value (note.x);
	                builder.set_member_name ("y");
	                builder.add_int_value (note.y);
	                builder.set_member_name ("w");
	                builder.add_int_value (note.w);
	                builder.set_member_name ("h");
	                builder.add_int_value (note.h);
	                builder.end_object ();
            	};
            	builder.end_array ();

            	Json.Generator generator = new Json.Generator ();
           	Json.Node root = builder.get_root ();
            	generator.set_root (root);
            	string json_string = generator.to_data (null);

		
		/* Then we handle slamming it all where it do be do */
        	
	        
		string data_path = Environment.get_user_data_dir () + "saved_sticky_" + uid + ".json";
            	debug ("%s".printf(data_path));

		var dir = File.new_for_path(Environment.get_user_data_dir ());
	        var file = File.new_for_path (data_path);



            try {
                if (!dir.query_exists()) {
                    dir.make_directory();
                }

                if (file.query_exists ()) {
                    file.delete ();
                }

                var file_stream = file.create (FileCreateFlags.REPLACE_DESTINATION);
                var data_stream = new DataOutputStream (file_stream);
                data_stream.put_string(json_string);
            } catch (Error e) {
                warning ("Failed to save notes %s\n", e.message);
            }

        }


}

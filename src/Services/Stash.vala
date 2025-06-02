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

jsonify(Gee.ArrayList<StickyNoteWindow>)
--> take all note instances, and gulps back a giant json string

overwrite_stash(json_string)
--> Dump all it has in a saved_state.json

save_to_stash(Note)
--> Dump all it has in a saved_state.json

load_from_stash()
--> loads the json file and parse it into a list of NoteData

*/

namespace Jorts.Stash {

    /*************************************************/
    // Ok first check if we have a directory to store data
    public void check_if_stash () {
        debug ("do we have a data directory?");
        var data_directory  = File.new_for_path (Environment.get_user_data_dir ());	
		try {
			if (!data_directory.query_exists ()) {
				data_directory.make_directory ();
				print("Prepared target data directory");
			}
		} catch (Error e) {
			warning ("Failed to prepare target data directory %s\n", e.message);
		}
	}


    /*************************************************/
    // Just slams a json in the storage file
    // TODO: Simplify this
    public void overwrite_stash(string json_data, string file_overwrite) {
        debug("writing to stash...");
        string data_directory = Environment.get_user_data_dir ();
        string storage_path = data_directory + "/" + file_overwrite;
    
        var dir = File.new_for_path(data_directory);
        var file = File.new_for_path (storage_path);

        try {
            if (!dir.query_exists ()) {
                dir.make_directory ();
            }
            if (file.query_exists ()) {
                file.delete ();
            }
            var file_stream = file.create (FileCreateFlags.REPLACE_DESTINATION);
            var data_stream = new DataOutputStream (file_stream);
            data_stream.put_string (json_data);
            
        } catch (Error e) {
            warning ("Failed to save notes %s\n", e.message);
        }
    }

    /*************************************************/
    // Handles the whole loading. If there is nothing, just start with a blue one
    // We first try from main storage
    // If that fails, we go for backup
    // Still failing ? Start anew
    public Gee.ArrayList<NoteData> load_from_stash () {
        debug("loading from stash...");

        Gee.ArrayList<NoteData> loaded_data = new Gee.ArrayList<NoteData>();
        string data_directory = Environment.get_user_data_dir ();
        string storage_path = data_directory + "/" + Jorts.Constants.FILENAME_STASH;
        string backup_path = data_directory + "/" + Jorts.Constants.FILENAME_BACKUP;

        var parser = new Json.Parser();

        // Try standard storage
        try {
            parser.load_from_mapped_file (storage_path);
            loaded_data = Jorts.Jason.load_parser (parser);

        } catch (Error e) {
            print("[WARNING] Failed to load from main storage! " + e.message.to_string() + "\n");
            debug("Trying backup");
            // Try backup file
            try {
                parser.load_from_mapped_file (backup_path);
                loaded_data = Jorts.Jason.load_parser(parser);

            } catch (Error e) {

                // Nothing works
                print("[WARNING] Failed to load from BACKUP!!! " + e.message.to_string() + "\n");

            }


        }
        print("Loaded" + loaded_data.size.to_string() + "!\n");

        // If we load nothing: Fallback to a random with blue theme as first
        if (loaded_data.size == 0 ) {
            debug ("nothing loaded");
            NoteData blank_slate    = Jorts.Utils.random_note (null);
            blank_slate.theme       = Jorts.Constants.DEFAULT_THEME ;

            loaded_data.add (blank_slate);
        }

        return loaded_data;

    }



    /*************************************************/
	// We first check if we have a backup or a last saved date
    // if none of those two, tell we need immediate backup
    // else, then depending how old we know the backup to be
	public bool need_backup (string last_backup) {
        debug ("lets check if we need to backup");

        string data_directory = Environment.get_user_data_dir ();
        string backup_path = data_directory + "/" + Jorts.Constants.FILENAME_BACKUP;
        var file = File.new_for_path (backup_path);

        if ((last_backup == "") || (file.query_exists() == false)) {

            return true;

        } else {
            var now = new DateTime.now_utc () ;
            var date_last_backup = new DateTime.from_iso8601 (last_backup, null);
            TimeSpan date_diff = now.difference (date_last_backup);
            var days_in_micro = Jorts.Constants.DAYS_BETWEEN_BACKUPS * TimeSpan.DAY;
            return (date_diff > days_in_micro);
        }
    }
}

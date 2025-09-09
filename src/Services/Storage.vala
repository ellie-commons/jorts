/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/*
void                        check_if_stash()        --> Make sure we can save
Gee.ArrayList<NoteData>     load ()                 --> get
void                        save (string json_data) --> slam in
*/

public class Jorts.Storage {

    private string data_directory;
    private string storage_path;
    private string save_file;

    construct {
        data_directory = Environment.get_user_data_dir ();
        storage_path = data_directory + "/" + Jorts.Constants.FILENAME_STASH;
        save_file = File.new_for_path (storage_path);

        check_if_stash ();
    }



    /*************************************************/
    // Ok first check if we have a directory to store data
    private void check_if_stash () {
        debug ("[STORAGE] do we have a data directory?");
        var dir = File.new_for_path(data_directory);

        try {
			if (!dir.query_exists ()) {
				dir.make_directory ();
				debug ("[STORAGE] yes we do now");
			}
		} catch (Error e) {
			warning ("[STORAGE] Failed to prepare target data directory %s\n", e.message);
		}
	}


    /*************************************************/
    // Just slams a json in the storage file
    // TODO: Simplify this
    public void save (string json_data) {
        debug("writing to stash...");
        check_if_stash ();

        try {
            if (save_file.query_exists ()) {
                save_file.delete ();
            }
            var file_stream = save_file.create (FileCreateFlags.REPLACE_DESTINATION);
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
    public Gee.ArrayList<NoteData> load () {
        debug("loading from stash…");

        Gee.ArrayList<NoteData> loaded_data = new Gee.ArrayList<NoteData>();
        var parser = new Json.Parser();

        // Try standard storage
        try {
            check_if_stash ();
            parser.load_from_mapped_file (storage_path);
            loaded_data = Jorts.Jason.load_parser (parser);

        } catch (Error e) {
            print("[WARNING] Failed to load from storage (Attempt 1)! " + e.message.to_string() + "\n");

            // Try backup file
            try {
                check_if_stash ();
                parser.load_from_mapped_file (storage_path);
                loaded_data = Jorts.Jason.load_parser(parser);

            } catch (Error e) {
                print("[WARNING] Failed to load from storage (Attempt 2)!!! " + e.message.to_string() + "\n");

                try {
                    check_if_stash ();
                    parser.load_from_mapped_file (storage_path);
                    loaded_data = Jorts.Jason.load_parser(parser);

                } catch (Error e) {
                    print("[WARNING] Failed to load from storage (Attempt 3)!!! " + e.message.to_string() + "\n");
                    quit ();
                }
            }


        }
        print("\nLoaded " + loaded_data.size.to_string() + "!");

        // If we load nothing: Fallback to a random with blue theme as first
        if (loaded_data.size == 0 ) {
            debug ("nothing loaded");
            NoteData blank_slate    = Jorts.Utils.random_note (null);
            blank_slate.theme       = Jorts.Constants.DEFAULT_THEME ;

            loaded_data.add (blank_slate);
        }

        debug ("I used the Json to destroy the Json");
        return loaded_data;
    }
}

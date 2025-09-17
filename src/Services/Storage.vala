/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* Represents the file on-disk, and takes care of the annoying  
* 
* void          save (Json.Array)  --> Save to the storage file data
* Json.Array   load ()           --> Load and return 
*
* save() takes a Json.Node instead of an NoteData[] so we avoid looping twice through all notes
* It is agressively persistent in 
*/
public class Jorts.Storage {

    private const string FILENAME_STASH     = "saved_state.json";
    private const string FILENAME_BACKUP    = "backup_state.json";
    private const uint8 TRIES                = 3;

    private string data_directory;
    private string storage_path;
    private File save_file;

    /**
    * Convenience property wrapping load() and save()
    */
    public Json.Array content {
        get { return load ();}
        set { save (value);}
    }

    /*************************************************/
    construct {
        data_directory = Environment.get_user_data_dir ();
        storage_path = data_directory + "/" + FILENAME_STASH;
        save_file = File.new_for_path (storage_path);

        check_if_stash ();
    }


    /*************************************************/
    /**
    * Persistently check for the data directory and create if there is none 
    */
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
    /**
    * Converts a Json.Node into a string and take care of saving it
    */
    public void save (Json.Array json_data) {
        debug("[STORAGE] Writing...");
        check_if_stash ();

        try {
            if (save_file.query_exists ()) {
                save_file.delete ();
            }
            var generator = new Json.Generator ();
            generator.set_root (json_data);
            string storage_content = generator.to_data (null);

            var file_stream = save_file.create (FileCreateFlags.REPLACE_DESTINATION);
            var data_stream = new DataOutputStream (file_stream);
            data_stream.put_string (storage_content);
            
        } catch (Error e) {
            warning ("[STORAGE] Failed to save notes %s\n", e.message);
        }
    }

    /*************************************************/
    /**
    * Grab from storage, into a Json.Node we can parse. Insist if necessary
    */
    public Json.Array load () {
        debug("[STORAGE] Loadingstash…");

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
                    critical ("[WARNING] Failed to load from storage (Attempt 3)!!! " + e.message.to_string() + "\n");
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

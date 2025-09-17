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

    private const string FILENAME           = "saved_state.json";
    private const string FILENAME_BACKUP    = "backup_state.json";
    private const uint8 TRIES               = 3;

    private string data_directory;
    private string storage_path;

    /**
    * Convenience property wrapping load() and save()
    */
    public Json.Array content {
        get {return load ();}
        set {save (value);}
    }

    /*************************************************/
    construct {
        data_directory      = Environment.get_user_data_dir ();
        storage_path        = data_directory + "/" + FILENAME;
        check_if_stash ();
    }

    /*************************************************/
    /**
    * Persistently check for the data directory and create if there is none 
    */
    private void check_if_stash () {
        debug ("[STORAGE] do we have a data directory?");
        var dir = File.new_for_path (data_directory);

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
            var generator = new Json.Generator ();
            generator.set_root (json_data);
            generator.to_file (storage_path);
            
        } catch (Error e) {
            warning ("[STORAGE] Failed to save notes %s", e.message);
        }
    }

    /*************************************************/
    /**
    * Grab from storage, into a Json.Node we can parse. Insist if necessary
    */
    public Json.Array load () {
        debug("[STORAGE] Loading from storage letsgo");

        Gee.ArrayList<NoteData> loaded_data = new Gee.ArrayList<NoteData>();
        var parser = new Json.Parser();

        // Try standard storage
        try {
            check_if_stash ();
            parser.load_from_mapped_file (storage_path);
            loaded_data = Jorts.Jason.load_parser (parser);

        } catch (Error e) {
            print ("[WARNING] Failed to load from storage (Attempt 1)! " + e.message.to_string() + "\n");
        }
        print ("\nLoaded " + loaded_data.size.to_string() + "!");

        debug ("I used the Json to destroy the Json");
        return loaded_data;
    }

    /*************************************************/
    /**
    * Like it says on the tin
    */
    public void dump () {
        debug("[STORAGE] DROP TABLE Students;--");

        var everything = load ();
        var generator = new Json.Generator () {
            pretty = true;
        };
        generator.set_root (everything);

        print (generator.to_string ());
    }
}

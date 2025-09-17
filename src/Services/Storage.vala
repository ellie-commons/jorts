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
public class Jorts.Storage : Object {

    private const string FILENAME           = "saved_state.json";
    private const string FILENAME_BACKUP    = "backup_state.json";
    private const uint8 TRIES               = 3;

    private string data_directory;
    private string storage_path;

    /**
    * Convenience property wrapping load() and save()
    */
    public Json.Array content {
        owned get {return load ();}
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
            var node = new Json.Node (Json.NodeType.ARRAY);
            node.set_array (json_data);
            generator.set_root (node);
            generator.to_file (storage_path);
            
        } catch (Error e) {
            warning ("[STORAGE] Failed to save notes %s", e.message);

            // TODO add portal call so we can save somewhere else
            var dialog = new Granite.MessageDialog (
                    _("Could not save to storage!"),
                    e.message,
                    new ThemedIcon ("drive-harddisk")
                ) {
                    badge_icon = new ThemedIcon ("dialog-error"),
                };
            dialog.present ();
            dialog.response.connect (dialog.destroy);
        }
    }

    /*************************************************/
    /**
    * Grab from storage, into a Json.Node we can parse. Insist if necessary
    */
    public Json.Array? load () {
        debug("[STORAGE] Loading from storage letsgo");
        check_if_stash ();
        var parser = new Json.Parser ();
        var array = new Json.Array ();

        try {
            parser.load_from_mapped_file (storage_path);
            var node = parser.get_root ();
            array = node.get_array ();

        } catch (Error e) {
            warning ("Failed to load from storage " + e.message.to_string());

            // TODO add portal call so we can save somewhere else
            var dialog = new Granite.MessageDialog (
                    _("Could not load from storage!"),
                    e.message,
                    new ThemedIcon ("drive-harddisk")
                ) {
                    badge_icon = new ThemedIcon ("dialog-error"),
                };
            dialog.present ();
            dialog.response.connect (dialog.destroy);
        }
        
        return array;
    }

    /*************************************************/
    /**
    * Like it says on the tin
    */
    public void dump () {
        debug("[STORAGE] DROP TABLE Students;--");

        var everything = load ();
        var generator = new Json.Generator () {
            pretty = true
        };

        var node = new Json.Node (Json.NodeType.ARRAY);
        node.set_array (everything);
        generator.set_root (node);
        print (generator.to_data (null));
    }
}

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


check if we have a "saved_sticky_" + uid_counter + ".json"
If yes load it load_from_stash(uid, title, theme, content, x, y, height, width)
count uid_counter +1

If not, stop. We have 



##################

-Each MainWindow (new note) gets assigned by the app an UID

The app will sort itself out with size, colour, label, whatever

It can count on support functions:



save_to_stash(uid, title, theme, content, x, y, height, width)
--> Dump all it has in a saved_sticky_uid.json



*/



namespace jorts {

  	public void create_note(Storage? storage) {
            debug ("Creating a note…\n");
	    var note = new MainWindow(this, storage);
            open_notes.add(note);
            update_storage();
	}

        public void remove_note(MainWindow note) {
            debug ("Removing a note…\n");
            open_notes.remove (note);
            update_storage();
	}

	public void update_storage() {
            debug ("Updating the storage…\n");
	    Gee.ArrayList<Storage> storage = new Gee.ArrayList<Storage>();

	    foreach (MainWindow w in open_notes) {
                storage.add(w.get_storage_note());
		note_manager.save_notes(storage);
            }
	}



}

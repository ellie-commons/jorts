/*
* Copyright (c) 2025 Stella
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
*
*/

/* CONTENT

random_theme()
TODO: take a theme as argument to skip

random_title()

random_note(uid)
TODO: will need to know the theme to skip

*/

namespace jorts.Utils {

    // Spits out a random theme for a new note
    public string random_theme () {        
        return jorts.Themer.themearray[Random.int_range (0,(jorts.Themer.themearray.length - 1))];

    }

    // Spits out a cute or funny random title for a new sticky note
    public string random_title () {
        string[] alltitles = {
            _("All my very best friends"),
            _("My super good secret recipe"),
            _("My todo list"),
            _("Super secret to not tell anyone"),
            _("My grocery list"),
            _("Random shower thoughts"),
            _("My fav fanfics"),
            _("My fav dinosaurs"),
            _("My evil mastermind plan"),
            _("What made me smile today"),
            _("Hello world!"),
            _("New sticky, new me"),
            _("Hidden pirate treasure"),
            _("To not forget, ever"),
            _("Dear Diary,"),
            _("Hi im a square"),
            _("Have a nice day! :)"),
            _("My meds schedule"),
            _("Household chores"),
            _("Ode to my cat"),
            _("My dogs favourite toys"),
            _("How cool my birds are"),
            _("Suspects in the Last Cookie affair"),
            _("Words my parrots know"),
            _("Cool and funny compliments to give out"),
            _("Ok, listen here,"),
            _("My dream Pokemon team"),
            _("My little notes"),
            _("Surprise gift list"),
            _("Brainstorming notes"),
            _("To bring to the party"),
            _("My amazing mixtape"),
            _("Napkin scribbles")
        };
        return alltitles[Random.int_range (0,(alltitles.length - 1))];
    }

    // Spits out a fresh new note
    public noteData random_note () {
        var randtitle = jorts.Utils.random_title();
        string randtheme = jorts.Utils.random_theme ();
        noteData randnote = new noteData( randtitle, randtheme, "", 100, 330, 270);
        return randnote; 
    }
}
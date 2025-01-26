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

namespace jorts.Utils {

    /* Get a name, spit an array with colours from standard granite stylesheet */
    /* EX: STRAWBERRY --> { "@STRAWBERRY_100" "@STRAWBERRY_900" }*/
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
            _("To not forget"),
            _("Deep deep thoughts")};

        return alltitles[Random.int_range (0,(alltitles.length - 1))];
    }


    public string random_theme () {
        string[] allthemes = {
            "STRAWBERRY",
            "ORANGE",
            "BANANA",
            "LIME",
            "BLUEBERRY",
            "BUBBLEGUM",
            "GRAPE",
            "COCOA",
            "SILVER",
            "SLATE"};
        return allthemes[Random.int_range (0,(allthemes.length - 1))];
    }

}
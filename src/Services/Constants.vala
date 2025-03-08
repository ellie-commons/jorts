

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
Just Dump constants here

*/

namespace jorts.Constants {

    // As seen on TV!
    // Later adds: LATTE, BLACK, SILVER, AUTO
    const string[] themearray = {
        "BLUEBERRY",
        "MINT",
        "LIME",
        "BANANA",
        "ORANGE",
        "STRAWBERRY",
        "BUBBLEGUM",
        "GRAPE",
        "COCOA",
        "SLATE"
    };

    const string app_rdnn               = "io.github.ellie_commons.jorts";

    // We need to say stop at some point
    const int max_zoom                  = 200;
    const int min_zoom                  = 60;

    // For new stickies
    const int defaut_height             = 330;
    const int defaut_width              = 270;

    // signature theme
    const string default_theme          = "BLUEBERRY";
    const int defaut_zoom               = 100;

    // Shortcuts
    const string[] ACCELS_NEW           = {"<Control>n"};
    const string[] ACCELS_DELETE        = {"<Control>w"};
    const string[] ACCELS_ZOOM_DEFAULT  = { "<control>0", "<Control>KP_0" };
    const string[] ACCELS_ZOOM_IN       = { "<Control>plus", "<Control>equal", "<Control>KP_Add" };
    const string[] ACCELS_ZOOM_OUT      = { "<Control>minus", "<Control>KP_Subtract" };

    const string[] FORMAT_ACTION_BOLD   = {"<Control>B"};
    const string[] FORMAT_ACTION_ITALIC = {"<Control>I"};
    const string[] FORMAT_ACTION_UNDERLINE = {"<Control>U"};

}


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

    const string app_rdnn               = "io.github.ellie_commons.jorts";

    const string DONATE_LINK = "https://ko-fi.com/teamcons";


    /*************************************************/
    // We need to say stop at some point
    const int ZOOM_MAX                  = 240;
    const int ZOOM_MIN                  = 40;

    // For new stickies
    const int DEFAULT_HEIGHT             = 330;
    const int DEFAULT_WIDTH              = 270;

    // signature theme
    const string DEFAULT_THEME          = "BLUEBERRY";
    const int DEFAULT_ZOOM               = 100;

    const int DAYS_BETWEEN_BACKUPS              = 30;
    const string FILENAME_STASH              = "saved_state.json";
    const string FILENAME_BACKUP              = "backup_state.json";



    /*************************************************/
    // Shortcuts
    const string[] ACCELS_ZOOM_DEFAULT  = { "<control>0", "<Control>KP_0" };
    const string[] ACCELS_ZOOM_IN       = { "<Control>plus", "<Control>equal", "<Control>KP_Add" };
    const string[] ACCELS_ZOOM_OUT      = { "<Control>minus", "<Control>KP_Subtract" };

    const string ACTION_PREFIX   = "app.";
    const string ACTION_NEW      = "action_new";
    const string ACTION_DELETE   = "action_delete";
    const string ACTION_SAVE   = "action_delete";
    const string ACTION_QUIT   = "action_quit";

    const string ACTION_ZOOM_OUT = "zoom_out";
    const string ACTION_ZOOM_DEFAULT = "zoom_default";
    const string ACTION_ZOOM_IN = "zoom_in";
    const string ACTION_TOGGLE_scribbly = "toggle_scribbly";

    const string[] ACCELS_NEW =     {"<Control>n"};
    const string[] ACCELS_DELETE =     {"<Control>w"};
    const string[] ACCELS_SAVE =     {"<Control>s"};
    const string[] ACCELS_QUIT =     {"<Control>q"};
    const string[] ACCELS_scribbly =     {"<Control>h"};
    const string[] ACCELS_EMOTE =     {"<Control>."};

    /*************************************************/
    // As seen on TV!
    // Later adds: LATTE, BLACK, SILVER, AUTO
    const string[] THEMES = {
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

    const string[] EMOTES = {
        "face-angel-symbolic",
        "face-angry-symbolic",
        "face-cool-symbolic",
        "face-crying-symbolic",
        "face-devilish-symbolic",
        "face-embarrassed-symbolic",
        "face-kiss-symbolic",
        "face-laugh-symbolic",
        "face-monkey-symbolic",
        "face-plain-symbolic",
        "face-raspberry-symbolic",
        "face-sad-symbolic",
        "face-sick-symbolic",                
        "face-smile-symbolic",
        "face-smile-big-symbolic",
        "face-smirk-symbolic",
        "face-surprise-symbolic",
        "face-tired-symbolic",
        "face-uncertain-symbolic",
        "face-wink-symbolic",
        "face-worried-symbolic"
    };




}
/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/* CONTENT
Just Dump constants here
*/

namespace Jorts.Constants {



    /*************************************************/
    const string RDNN                    = "io.github.ellie_commons.jorts";
    const string DONATE_LINK             = "https://ko-fi.com/teamcons";

    // signature theme
    const string DEFAULT_THEME           = "BLUEBERRY";
    const int DAYS_BETWEEN_BACKUPS       = 30;
    const string FILENAME_STASH          = "saved_state.json";
    const string FILENAME_BACKUP         = "backup_state.json";

    // in ms
    const int DEBOUNCE                   = 1000;

    // We need to say stop at some point
    const int ZOOM_MAX                   = 240;
    const int DEFAULT_ZOOM               = 100;
    const int ZOOM_MIN                   = 40;
    const bool DEFAULT_MONO               = false;

    // For new stickies
    const int DEFAULT_WIDTH              = 290;
    const int DEFAULT_HEIGHT             = 320;

    // New preference window
    const int DEFAULT_PREF_WIDTH         = 550;
    const int DEFAULT_PREF_HEIGHT        = 290;

    /*************************************************/
    // Shortcuts
    const string[] ACCELS_ZOOM_DEFAULT  = { "<Control>equal", "<control>0", "<Control>KP_0" };
    const string[] ACCELS_ZOOM_IN       = { "<Control>plus", "<Control>KP_Add" };
    const string[] ACCELS_ZOOM_OUT      = { "<Control>minus", "<Control>KP_Subtract" };

    const string ACTION_PREFIX   = "app.";
    const string ACTION_NEW      = "action_new";
    const string ACTION_DELETE   = "action_delete";
    const string ACTION_SAVE   = "action_delete";
    const string ACTION_QUIT   = "action_quit";

    const string ACTION_ZOOM_OUT = "zoom_out";
    const string ACTION_ZOOM_DEFAULT = "zoom_default";
    const string ACTION_ZOOM_IN = "zoom_in";
    const string ACTION_TOGGLE_SCRIBBLY = "toggle_scribbly";

    const string[] ACCELS_NEW =     {"<Control>n"};
    const string[] ACCELS_DELETE =     {"<Control>w"};
    const string[] ACCELS_SAVE =     {"<Control>s"};
    const string[] ACCELS_QUIT =     {"<Control>q"};
    const string[] ACCELS_SCRIBBLY =     {"<Control>h"};
    const string[] ACCELS_EMOTE =     {"<Control>period"};


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
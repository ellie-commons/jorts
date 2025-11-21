/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* I just dump all my constants here
*/
namespace Jorts.Constants {

    /*************************************************/
    const string RDNN                    = "io.github.ellie_commons.jorts";
    const string DONATE_LINK             = "https://ko-fi.com/teamcons";

    // signature theme
#if HALLOWEEN
    const Jorts.Themes DEFAULT_THEME    = Jorts.Themes.ORANGE;
#elif CLASSIC
    const Jorts.Themes DEFAULT_THEME    = Jorts.Themes.BANANA;
#else
    const Jorts.Themes DEFAULT_THEME    = Jorts.Themes.BLUEBERRY;
#endif

    // in ms
    const int DEBOUNCE                   = 750;

    // We need to say stop at some point
    const int ZOOM_MAX                   = 300;
    const int DEFAULT_ZOOM               = 100;
    const int ZOOM_MIN                   = 20;
    const bool DEFAULT_MONO                 = false;

    // For new stickies
    const int DEFAULT_WIDTH              = 290;
    const int DEFAULT_HEIGHT             = 320;

    // New preference window
    const int DEFAULT_PREF_WIDTH         = 510;
    const int DEFAULT_PREF_HEIGHT        = 290;

    // Used by random_emote () for the emote selection menu
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
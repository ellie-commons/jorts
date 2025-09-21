/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/* CONTENT
randrange does not include upper bound.

random_theme(skip_theme)
random_title()
random_emote(skip_emote)
random_note(skip_theme)

*/

namespace Jorts.Utils {

    /*************************************************/
    // We cannot use numbers in CSS, so we have to translate a number into a string
    public string zoom_to_class (int zoom) {
        switch (zoom) {
            case 20: return "antsized";
            case 40: return "muchsmaller";
            case 60: return "smaller";
            case 80: return "small";
            case 100: return "normal_zoom";
            case 120: return "big";
            case 140: return "bigger";
            case 160: return "muchbigger";
            case 180: return "muchmuchbigger";
            case 200: return "huge";
            case 220: return "superhuge";
            case 240: return "megahuge";
            case 260: return "ultrahuge";
            case 280: return "massive";
            case 300: return "urmom";
            default: return "normal_zoom";
        }
    }

    /*************************************************/
    // We cannot use numbers in CSS, so we have to translate a number into a string
    public int zoom_to_UIsize (int zoom) {
        switch (zoom) {
            case 20: return 24;
            case 40: return 26;
            case 60: return 28;
            case 80: return 30;
            case 100: return 32;
            case 120: return 34;
            case 140: return 38;
            case 160: return 40;
            case 180: return 44;
            case 200: return 48;
            case 220: return 52;
            case 240: return 54;
            case 260: return 56;
            case 280: return 60;
            case 300: return 64;
            default: return 32;
        }
    }
}

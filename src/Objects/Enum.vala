/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

public enum Jorts.Zoomkind {
    ZOOM_OUT, DEFAULT_ZOOM, ZOOM_IN
}

public enum Jorts.Themes {
    BLUEBERRY, MINT, LIME, BANANA, ORANGE, STRAWBERRY, BUBBLEGUM, GRAPE, COCOA, SLATE;

    public string to_string () {
        switch (this) {
            case BLUEBERRY:     return "blueberry";
            case MINT:          return "mint";
            case LIME:          return "lime";
            case BANANA:        return "banana";
            case ORANGE:        return "orange";
            case STRAWBERRY:    return "strawberry";
            case BUBBLEGUM:     return "bubblegum";
            case GRAPE:         return "grape";
            case COCOA:         return "cocoa";
            case SLATE:         return "slate";
            default: assert_not_reached ();
        }
    }

    public static Themes[] all () {
        return {BLUEBERRY, MINT, LIME, BANANA, ORANGE, STRAWBERRY, BUBBLEGUM, GRAPE, COCOA, SLATE};
    }

    public static string[] all_string () {
        return {"blueberry", "mint", "lime", "banana", "orange", "strawberry", "bubblegum", "grape", "cocoa", "slate"};
    }
}
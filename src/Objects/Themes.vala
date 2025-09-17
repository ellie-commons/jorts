/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/*************************************************/
/**
* A register of all themes we have
*/
public enum Jorts.Themes {
    BLUEBERRY,
    MINT,
    LIME,
    BANANA,
    ORANGE,
    STRAWBERRY,
    BUBBLEGUM,
    GRAPE,
    COCOA,
    SLATE;

    public string to_string () {
        switch (this) {
            case BLUEBERRY:     return "BLUEBERRY";
            case MINT:          return "MINT";
            case LIME:          return "LIME";
            case BANANA:        return "BANANA";
            case ORANGE:        return "ORANGE";
            case STRAWBERRY:    return "STRAWBERRY";
            case BUBBLEGUM:     return "BUBBLEGUM";
            case GRAPE:         return "GRAPE";
            case COCOA:         return "COCOA";
            case SLATE:         return "SLATE";
            default: assert_not_reached ();
        }
    }

    public Themes.from_string (string wtf_is_this) {
        switch (wtf_is_this.upper ()) {
            case "BLUEBERRY":     return BLUEBERRY;
            case "MINT":          return MINT;
            case "LIME":          return LIME;
            case "BANANA":        return BANANA;
            case "ORANGE":        return ORANGE;
            case "STRAWBERRY":    return STRAWBERRY;
            case "BUBBLEGUM":     return BUBBLEGUM;
            case "GRAPE":         return GRAPE;
            case "COCOA":         return COCOA;
            case "SLATE":         return SLATE;
            default: assert_not_reached ();
        }
    }

    public static Themes[] all () {
        return {BLUEBERRY, MINT, LIME, BANANA, ORANGE, STRAWBERRY, BUBBLEGUM, GRAPE, COCOA, SLATE};
    }

    public static string[] all_string () {
        return {"BLUEBERRY", "MINT", "LIME", "BANANA", "ORANGE", "STRAWBERRY", "BUBBLEGUM", "GRAPE", "COCOA", "SLATE"};
    }
}
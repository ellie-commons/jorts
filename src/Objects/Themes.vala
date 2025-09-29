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

    /*************************************************/
    /**
    * for use in CSS. Ex: @BLUEBERRY_500
    */
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
            default: return "BLUEBERRY";
        }
    }

    /*************************************************/
    /**
    * for use to pinpoint to the correct elementary stylesheet
    */
    public string to_css_class () {
        return this.to_string ().ascii_down ();
    }

    /*************************************************/
    /**
    * for the UI, as translated, proper name
    */
    public string to_nicename () {
        switch (this) {
            ///TRANSLATORS: These are the names of the elementary OS colours
            case BLUEBERRY:     return _("Blueberry");
            case MINT:          return _("Mint");
            case LIME:          return _("Lime");
            case BANANA:        return _("Banana");
            case ORANGE:        return _("Orange");
            case STRAWBERRY:    return _("Strawberry");
            case BUBBLEGUM:     return _("Slate");
            case GRAPE:         return _("Grape");
            case COCOA:         return _("Cocoa");
            case SLATE:         return _("Slate");
            default:            return _("Blueberry");
        }
    }

    /*************************************************/
    /**
    * recover Enum from a stored string, using when loading from storage
    */
    public static Themes from_string (string wtf_is_this) {
        switch (wtf_is_this.ascii_up ()) {
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

    /*************************************************/
    /**
    * convenient list of all supported themes
    */
    public static Themes[] all () {
        return {BLUEBERRY, MINT, LIME, BANANA, ORANGE, STRAWBERRY, BUBBLEGUM, GRAPE, COCOA, SLATE};
    }

    /*************************************************/
    /**
    * convenient list of all supported themes
    */
    public static string[] all_string () {
        return {"BLUEBERRY", "MINT", "LIME", "BANANA", "ORANGE", "STRAWBERRY", "BUBBLEGUM", "GRAPE", "COCOA", "SLATE"};
    }
}
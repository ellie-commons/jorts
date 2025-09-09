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

    /*************************************************/
    // Spits out a random theme for a new note
    // If there is the name of a string to skip, just skip it.
    // Having an gee.arraylist defined from the start only causes issues
    public string random_theme (string? skip_theme = null) {
        Gee.ArrayList<string> themes = new Gee.ArrayList<string> ();
        themes.add_all_array (Jorts.Themes.all_string ());

        if (skip_theme != null) {
            themes.remove(skip_theme);
        }

        var random_in_range = Random.int_range (0, themes.size);
        return themes[random_in_range];
    }


    /*************************************************/
    // Spits out a cute or funny random title for a new sticky note
    ///TRANSLATORS: It does not need to match source 1:1 - avoid anything that could be rude or cold sounding 
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
            _("Napkin scribblys"),
            _("My fav songs to sing along"),
            _("When to water which plant"),
            _("Top 10 anime betrayals"),
            _("Amazing ascii art!"),
            _("For the barbecue"),
            _("My favourite bands"),
            _("Best ingredients for salad"),
            _("Books to read"),
            _("Places to visit"),
            _("Hobbies to try out"),
            _("Who would win against Goku"),
            _("To plant in the garden"),
            _("Meals this week"),
            _("Everyone's pizza order"),
            _("Today selfcare to do"),
            _("Important affirmations to remember"),
            _("The coolest linux apps"),
            _("My favourite dishes"),
            _("My funniest jokes"),
            _("The perfect breakfast has...")
        };
        return alltitles[Random.int_range (0, alltitles.length)];
    }

    /*************************************************/
    // Spits out a cute or funny random title for a new sticky note
    public string random_emote (string? skip_emote = null) {

        Gee.ArrayList<string> allemotes = new Gee.ArrayList<string> ();
        allemotes.add_all_array (Jorts.Constants.EMOTES);

        if (skip_emote != null) {
            allemotes.remove (skip_emote);
        }

        var random_in_range = Random.int_range (0, allemotes.size);
        return allemotes[random_in_range];
    }

    /*************************************************/
    // Hey! Looking in the source code is cheating!

    public NoteData golden_sticky (NoteData blank_slate) {

        var random_in_range = Random.int_range (0, 1000);

        // ONE IN THOUSAND
        if (random_in_range == 1) {

            print ("GOLDEN STICKY");
            blank_slate.title = _("🔥WOW Congratulations!🔥");
            blank_slate.content = _(
"""You have found the Golden Sticky Note!

CRAZY BUT TRU: This message appears once in a thousand times!
Nobody will believe you hehehe ;)

I hope my little app brings you a lot of joy
Have a great day!🎇
""");
            blank_slate.theme = "BANANA";
        }

        return blank_slate;
    }


    /*************************************************/
    // Spits out a fresh new note
    public NoteData random_note (string? skip_theme = null) {
        debug ("Generating random note... Skip:" + skip_theme);
        var randtitle = Jorts.Utils.random_title ();
        string randtheme = Jorts.Utils.random_theme (skip_theme);

        NoteData randnote = new NoteData (
            randtitle,
            randtheme,
            "",
            false,
            Jorts.Constants.DEFAULT_ZOOM,
            Jorts.Constants.DEFAULT_WIDTH,
            Jorts.Constants.DEFAULT_HEIGHT
        );

        return randnote;
    }
}

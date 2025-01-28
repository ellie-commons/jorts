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

namespace jorts.Themer {

    /* Get a name, spit a whole CSS */
    /* We kinda need better tbh but it is better than before */
    public static string generate_css (int uid, string theme) {
        /*  var palette = generate_palette(theme);  */

        string style = "";

        style = (N_("""
            @define-color textColorPrimary #323232;

            .mainwindow-%d {
                background-color: @%s_100;
                transition: background-color 800ms cubic-bezier(0.4, 0, 0.2, 1);
            }

            .mainwindow-%d undershoot.top {
                background:
                    linear-gradient(
                        @%s_100 0%,
                        alpha(@%s_100, 0) 50%
                    );
                transition: background 800ms cubic-bezier(0.4, 0, 0.2, 1);
            }
            
            .mainwindow-%d undershoot.bottom {
                background:
                    linear-gradient(
                        alpha(@%s_100, 0) 50%,
                        @%s_100 100%
                    );
                transition: background 800ms cubic-bezier(0.4, 0, 0.2, 1);
            }



            .mainwindow-%d .jorts-view text selection {
                color: shade(@%s_100, 1.88);
                transition: color 800ms cubic-bezier(0.4, 0, 0.2, 1);
                background-color: @%s_900;
                transition: background-color 800ms cubic-bezier(0.4, 0, 0.2, 1);
            }

            entry.flat {
                background: transparent;
            }

            .window-%d .jorts-title image,
            .window-%d .jorts-label {
                color: @%s_900;
                box-shadow: none;
                transition: color 800ms cubic-bezier(0.4, 0, 0.2, 1);
            }

            .window-%d .jorts-bar {
                color: @%s_900;
                background-color: @%s_100;
                border-top-color: @%s_100;
                box-shadow: none;
                background-image: none;
                padding: 3px;
                transition: background-color 800ms cubic-bezier(0.4, 0, 0.2, 1);
                /*transition: color 800ms cubic-bezier(0.4, 0, 0.2, 1);*/
            }

            .window-%d .jorts-bar image {
                color: @%s_900;
                padding: 3px;
                box-shadow: none;
                background-image: none;
            }

            .window-%d .jorts-view,
            .window-%d .jorts-view text,
            .window-%d .jorts-title {
                background-color: @%s_100;
                background-image: none;
                border-bottom-color: @%s_100;
                font-weight: 500;
                font-size: 1.2em;
                color: shade(@%s_900, 0.77);
                box-shadow: none;
                transition: background-color 800ms cubic-bezier(0.4, 0, 0.2, 1);
                /*transition: color 800ms cubic-bezier(0.4, 0, 0.2, 1);*/
            }


            .color-button {
                border-radius: 50%;
                background-image: none;
                border: 1px solid alpha(#333, 0.25);
                box-shadow:
                    inset 0 1px 0 0 alpha (@inset_dark_color, 0.7),
                    inset 0 0 0 1px alpha (@inset_dark_color, 0.3),
                    0 1px 0 0 alpha (@bg_highlight_color, 0.3);
            }

            .color-button:hover,
            .color_button:focus {
                border: 1px solid @inset_dark_color;
            }

            .color-slate {
                background-color: @SLATE_100;
            }

            .color-silver {
                background-color: @SILVER_100;
            }

            .color-strawberry {
                background-color: @STRAWBERRY_100;
            }

            .color-orange {
                background-color: @ORANGE_100;
            }

            .color-banana {
                background-color: @BANANA_100;
            }

            .color-lime {
                background-color: @LIME_100;
            }

            .color-blueberry {
                background-color: @BLUEBERRY_100;
            }

            .color-grape {
                background-color: @GRAPE_100;
            }

            .color-cocoa {
                background-color: @COCOA_100;
            }

            .jorts-bar box {
                border: none;
            }

            .image-button,
            .titlebutton {
                background-color: transparent;
                background-image: none;
                border: 1px solid transparent;
                padding: 3px;
                box-shadow: none;
            }

            .image-button:hover,
            .image-button:focus,
            .titlebutton:hover,
            .titlebutton:focus {
                background-color: alpha(@fg_color, 0.3);
                background-image: none;
                border: 1px solid transparent;
                box-shadow: none;
            }


        .jorts-label {
            font-weight: 700;
            font-size: 0.88em;
        }

        
        .trashcan:hover {
            transition: background-color 800ms cubic-bezier(0.4, 0, 0.2, 1);
            color: @warning;
        }




            """));

        style = style.replace("%d",uid.to_string());

        style = style.replace("%s",theme);



    return style;
}




}

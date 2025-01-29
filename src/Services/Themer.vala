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
    public static string generate_css (string theme) {
        string style = "";

        style = (N_("""
            window.%s {
                background-color: @%s_100;
            }

            window.%s undershoot.top {
                background:
                    linear-gradient(
                        @%s_100 0%,
                        alpha(@%s_100, 0) 50%
                    );
            }

            window.%s undershoot.bottom {
                background:
                    linear-gradient(
                        alpha(@%s_100, 0) 50%,
                        @%s_100 100%
                    );
            }

            window.%s .jorts-view text selection {
                color: shade(@%s_100, 1.88);
                background-color: @%s_900;
            }

            window.%s .jorts-title image,
            window.%s .jorts-label {
                color: @%s_900;
            }

            window.%s .jorts-bar {
                color: @%s_900;
            }

            window.%s .jorts-bar image {
                color: @%s_900;
            }

            window.%s .jorts-view,
            window.%s .jorts-view text,
            window.%s .jorts-title {
                background-color: @%s_100;
                border-bottom-color: @%s_100;
                color: shade(@%s_900, 0.77);
            }
        """));

        style = style.replace ("%s",theme);

        return style;
    }
}

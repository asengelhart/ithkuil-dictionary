# Ithkuil-Dictionary

This CLI application parses the Ithkuil lexicon page at www.ithkuil.net/lexicon.htm,
and allows the user to look up roots either by their phonetic value or by their
English translation.

# Installation

Clone this repository, then run `bundle install`.

To run the application, run `bin/console`.

# Usage

The main menu allows you to select between entering a phonetic value and an English translation.

Phonetic values must be entered exactly as in the lexicon (case insensitive).  Special characters
can be found here:

Ç Č Ļ Ň Ř Š Ţ Ż Ž

Translation may be provided in part or whole.  Translations are sorted with exact matches at top,
followed by exact matches among the root's stems, then partial matches for roots and stems below that.
Inspect a root by inputting the number next to it.

# Contributing

Any suggestions or bugfixes may be made by way of pull requests or messaging me.

# License
Copyright © 2020, Alex S. Engelhart

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://mit_license.org

The Ithkuil language, and all associated materials, is copyright © 2004-2019 John Quijada.
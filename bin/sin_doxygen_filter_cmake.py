#!/usr/bin/env python3

# Copyright © 2023 Lénaïc Bagnères

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# This is a filter to convert CMake code into something doxygen can understand.
# It is inspired by https://web.archive.org/web/20150627011139/http://home.in.tum.de/%7Egrembowi/vbfilter/vbfilter.py

# This is a very first version.

import sys


def parse_function(line):
    if line.startswith("function("):
        function_name_and_args = line[9:-2].split()
        print(
            "void "
            + function_name_and_args[0]
            + "("
            + ", ".join(function_name_and_args[1:])
            + ") {"
        )
        return True
    return False


def filter(cmake_filename):
    with open(cmake_filename) as f:
        for line in f:
            if line.startswith("###"):
                print("///" + line[3:], end="")
            elif parse_function(line):
                continue
            elif line.startswith("endfunction()"):
                print("}")
            else:
                print("//", line, end="")


if __name__ == "__main__":

    if len(sys.argv) != 2:
        print("Usage:", sys.argv[0], "<input>")
        sys.exit(1)

    filter(sys.argv[1])

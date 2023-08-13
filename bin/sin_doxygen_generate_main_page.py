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


import sys

if __name__ == "__main__":

    if len(sys.argv) != 5:
        print(
            'Usage:', sys.argv[0], '<Readme.md> <output> <project_name> <project_version>')
        sys.exit(1)

    readme_path = sys.argv[1]
    output_path = sys.argv[2]
    project_name = sys.argv[3]
    project_version = sys.argv[4]

    with open(readme_path, 'r') as f:
        readme_lines = f.readlines()

    with open(output_path, 'w') as f:
        f.write('/** \mainpage ' + project_name + ' ' + project_version + '\n')
        f.write(' *\n')
        f.write(''.join([' * ' + line for line in readme_lines]))
        f.write(' *\n')
        f.write(' */\n')

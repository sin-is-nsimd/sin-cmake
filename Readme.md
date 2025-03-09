# sin-cmake

`sin-cmake` contains CMake helpers for C++ projects.

CMake has bad reputation but it is widely use for C and C++ projects. We want to believe it is
possible to have simple CMake for our projects or projects with the same folders structures.

# Development

Project uses [black](https://pypi.org/project/black/) as Python 3 code
formatter.

Project uses [conventional-pre-commit](https://github.com/compilerla/conventional-pre-commit)
to try to force good commit messages.
The `.pre-commit-config.yaml` is already in the root folder of `sin-cmake`.
Run this command in the `sin-cmake` directory:
```sh
pre-commit install --hook-type commit-msg
```

# License

Copyright © 2023-2025 <https://github.com/sin-is-nsimd>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

# Overview

This is a collection of helpful rake tasks. You can take many of them individually if you like, but some may be dependent upon others (e.g.: the rabbitmq tasks depend on the erlang tasks).

Tasks that install software typically install to `~/bin`, often in a subdirectory. Some tasks may assume that `~/bin` is in the path. _This is subject to change - I may make installation happen in in subdirs all within the enclosing project directory and always use full paths._

# Platforms

These tasks are only tested on Mac OSX unless otherwise specified. However, in many cases they are just generic Ruby or at least suitable for generic unix. I have no intention of supporting Windows at this time, but feel free to form and submit a pull request.

# Author

Scott W. Bradley -- http://scottwb.com

# License

This code is licensed under [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)



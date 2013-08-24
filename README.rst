===============================================================================
Program allowing to run other programs only after some "homework" has been done
===============================================================================
A way to consolidate calculus and grammar skills
-------------------------------------------------------------------------------

flo-check-homework presents one or more questionnaires to the user. Once all
questions have been answered, and if the score exceeds a predefined threshold,
a special button is enabled. When pressed, this button launches the program
(with optional arguments) that was specified on flo-check-homework's command
line.

A "magic formula" button allows to bypass the test in case the pupil has
already done his homework in another way. It also makes it possible to exit
the program immediately.

Indeed, flo-check-homework refuses to quit immediately unless option -e was
given or a sufficient score was obtained; this is done so as to avoid the
children validating the whole questionnaire with incorrect answers only to get
corrections that they can blindly copy after rerunning the program. For the
same reason, some of the question generators purposely don't remember
incorrect answers, in contrast with the initial design.

Currently, the questions are designed to help consolidate simple additions,
substractions, multiplications, euclidian divisions and conjugations of French
verbs. The questionnaires are built at run-time and can be customized to some
extent via a configuration file
(~/.config/Florent Rougon/flo-check-homework.ini on Unix-like systems). It is
easy for a Python programmer to add new question generators, questionnaires or
subquestionnaires.

The ItemGenerator class, which is the basis for many question generators, has
the following properties:

  - starts with items that have been incorrectly answered in previous sessions
  - cycles through all items but does not yield an item that has already been
    seen in the current session (unless all items have been seen)
  - Seen objects (used to remember which items of a given type have been seen
    in the current session) can be shared between several question generators.
    This avoids asking the same question twice in case several question
    generators are likely to generate the same question.

It is possible to setup launcher scripts that call flo-check-homework with the
appropriate parameters depending on the script (and parameters passed to the
script). The flo-check-homework-decorate-games program is provided to help
automate such a setup. Basically, you write a list of programs/games in a file
which we'll call DATAFILE for the sake of the example (see
flo-check-homework-decorate-games-data for an example of such a file). Then,
you run flo-check-homework-decorate-games's as a user that has permission to
write to /usr/local/games, providing the relevant data on its standard input:

  # flo-check-homework-decorate-games </path/to/DATAFILE

This will create an appropriate launcher script in /usr/local/games for every
program listed in DATAFILE. If /usr/local/games is prepended to the system
PATH, then the launcher scripts will take precedence over the corresponding
game executables when a user tries to run a game, unless a full path to the
game executable is specified.

This also works if the game is started from the freedesktop_ menu, because
freedesktop .desktop files usually don't specify a full path to the executable
(when they do, the only recourse is to fix the .desktop file manually and
report a bug to the game in question). The format of .desktop files is
described in the `Desktop Entry specification`_.

This version of flo-check-homework has been tested with Python 3.3.0, Qt 4.6.3
and PyQt 4.9.6. Any version of Python 3 should work, any not-too-old version
of Qt 4 should work too, but the dependency on not-too-old PyQt is stricter.
At least PyQt 4.7.3 has significant incompatibilities with version 4.9.6 and
will not work with this version of flo-check-homework.

flo-check-homework has been tested on Linux. It should work on any platform
with the aforementioned dependencies installed, but trivial bugs are expected
on non-Unix platforms as no test whatsoever has been done on such platforms.
Please report.

Since flo-check-homework-decorate-games is currently only able to generate
shell scripts, it is not expected to be of any use on platforms that cannot
run them. This means that you can fill in questionnaires on these platforms
but can't expect to be able to run the desired program/games from
flo-check-homework after a good enough work without some adaptation for such
platforms. (For Windows platforms, one might use Cygwin or adapt
flo-check-homework-decorate-games to generate batch files, or something else,
let Windows experts decide in this matter...)

All images, as the rest of the package, are free according to the `Debian Free
Software Guidelines`_ (DFSG-free for short). I wanted to use photos of
angry-looking dogs easily found with Google Images, but unfortunately, they
all appear to be non-free. If you have good suggestions of free
software-licensed images to improve this program, please advise.

Currently, the relevant strings in flo-check-homework are marked as
translatable for Qt but are written in French. This is a bug that should be
fixed (I did not intend to distribute the program to an audience that doesn't
speak French at first). However, running it under a French locale is still
useful for French-speaking users, as the parts actually depending on French
grammar rules (and not used to learn French!) are only activated under French
locales (humoristic tooltips for now).

.. _freedesktop: http://www.freedesktop.org/
.. _Desktop Entry specification: http://www.freedesktop.org/wiki/Specifications/desktop-entry-spec
.. _Debian Free Software Guidelines: http://www.debian.org/social_contract#guidelines

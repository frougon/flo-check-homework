===============================================================================
Program allowing to run other programs only after some "homework" has been done
===============================================================================
A way to consolidate calculus and grammar skills
-------------------------------------------------------------------------------

General idea
------------

flo-check-homework presents one or more questionnaires to the user. Once all
questions have been answered, and if the score exceeds a predefined threshold,
a special button is enabled. When pressed, this button launches the program
(with optional arguments) that was specified on flo-check-homework's command
line. For instance, the following command::

  flo-check-homework -- prog arg1 arg2 arg3

will start flo-check-homework without any option and allow the pupil to run,
if the questionnaires receive good enough answers, the program 'prog' with 3
arguments: 'arg1', 'arg2' and 'arg3'. To see all available command line
options, you may run::

  flo-check-homework --help

In flo-check-homework's graphical user interface, a "magic word" button allows
one to bypass the test in case the pupil has already done his homework in
another way. It also makes it possible to exit the program immediately.

Indeed, flo-check-homework refuses to quit immediately unless option -e was
given or a sufficient score was obtained; this is done so as to avoid the
children validating the whole questionnaire with incorrect answers only to get
corrections that they can blindly copy after rerunning the program. For the
same reason, some of the question generators purposedly don't remember
incorrect answers, in contrast with the initial design.

Since version 0.10.0, there is a new feature called *super magic word* that
gives, if properly entered, a *super magic token* which is valid for a limited
amount of time (see `The super magic word`_ below). This allows more freedom
to run the available games once the token has been granted. Since my goal is
definitely not to use technical means in order to limit the pleasure children
can have with games, a successful work does grant a super magic token, just as
if the super magic word had been entered.

Note:

  Version 0.10.0 also introduced the ``AllowExitBeforeChild`` configuration
  file parameter in the ``General`` section, defaulting to 1. If set to 0,
  quitting is also forbidden as long as the program specified on the command
  line ("desired program") is running---assuming it was started from
  flo-check-homework. This can be useful with kids misusing a super magic
  token to run dozens of games simultaneously.

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
script). The flo-check-homework-decorate-games program from the 'tools'
directory is provided to help automate such a setup. Basically, you write a
list of programs/games in an XML file which we'll call DATAFILE for the sake
of the example. You may look at flo-check-homework-decorate-games.xml from the
tools/flo-check-homework-decorate-games folder or run
'flo-check-homework-decorate-games --help' for an example of such a file. Once
you have a proper DATAFILE, run the following command as a user who has
permission to write to /usr/local/games::

  # flo-check-homework-decorate-games /path/to/DATAFILE

This will create an appropriate launcher script in /usr/local/games for every
program listed in DATAFILE. If /usr/local/games is prepended to the system
PATH, then the launcher scripts will take precedence over the corresponding
game executables when a user tries to run a game, unless a full path to the
game executable is specified. So, when using wrapper scripts, the call chain
looks like the following::

  --> wrapper script 'foo' called with arguments arg1 ... argn
      --> flo-check-homework [some options] -- foo arg1 ... argn
          --> foo arg1 ... argn
              (or '<launcher> foo arg1 ... argn' if using the ProgramLauncher
              feature)

where each arrow indicates a different process. "some options" typically
contains -p (--pretty-name) to tell flo-check-homework the "pretty name" of
program 'foo', for displaying in the graphical user interface.

The above trick, based on the PATH environment variable, also works if the
game is started from the freedesktop_ menu, because freedesktop .desktop files
usually don't specify a full path to the executable (when they do, the only
recourse is to fix the .desktop file manually and report a bug to the game in
question). The format of .desktop files is described in the `Desktop Entry
specification`_.

flo-check-homework-decorate-games has options to customize the paths such as
/usr/games and /usr/local/games, as well as options to choose which locale to
use when a launcher script starts flo-check-homework, and when
flo-check-homework runs a game. See the output of
'flo-check-homework-decorate-games --help' for more information.


The super magic word
~~~~~~~~~~~~~~~~~~~~

Since version 0.10.0, a new kind of magic word, creatively called the "super
magic word", allows one to run the decorated games more easily and
transparently. When one chooses this function from the Magic menu (added in
version 0.10.0) or from the toolbar, one is asked to enter the super magic
word, similarly to the simple "magic word". If the given answer is correct, a
"super magic token" is granted that allows one to run all decorated programs
(likely to be games) in a transparent manner. This special permission is valid
for some time that depends on the super magic word that was given (see the
source!). Once the token has been granted, it is possible to launch the
predefined game from flo-check-homework's GUI, as for a simple "magic word".
However, in order to run different games under the super magic token super
powers, one should rather quit flo-check-homework first, otherwise the locking
mechanism used to protect the QSettings against eventual corruption caused by
several concurrent uses would prevent other instances of flo-check-homework
from running normally, and therefore make it impossible to run other decorated
games until the instance that is holding the lock is ended.

In short, the suggested use of this feature is the following:

#. Ensure the child has done his work correctly, be it with flo-check-homework,
   yourself, or any way that seems reasonable to you.
#. Enter the super magic word in flo-check-homework. This grants you a virtual
   "super magic token" stored on the filesystem that persists even after
   flo-check-homework has been ended (the storage location being under
   '~/.config/Florent Rougon' on Unix-like systems).
#. Quit flo-check-homework (or accept to be limited to the game and parameters
   given on flo-check-homework's command line as specified in the previous
   step).
#. Let the child play with any of the decorated games without
   flo-check-homework interfering during the validity period of the super
   magic token.
#. Either let the super magic token expire by itself, or launch
   flo-check-homework and use the appropriate item from the Magic menu to
   remove it.

Note: there is still some locking performed when flo-check-homework runs the
decorated game "transparently" after finding out that the user has a valid
super magic token. However, it is very short, the lock being released before
the decorated game is started. Therefore, several decorated programs/games may
be run concurrently this way, even though the corresponding flo-check-homework
processes may block each other for a short time because of the locking
performed in order to protect the QSettings.

In this mode, flo-check-homework uses a call from the exec*(2) family
(execvp(2) in version 0.10.0) without forking beforehand. Consequently, it
doesn't consume any resource whatsoever once the decorated program is started,
and the exit code returned is exactly the same as if the decorated program had
been run without flo-check-homework intervening. This is why this mode is said
to allow transparent execution of the decorated programs.

When flo-check-homework is started, it can operate in two distinct modes:
either the graphical interface is displayed, or the program specified on the
command line is automatically run. The former is called *interactive mode* and
the latter *transparent mode*. Interactive mode is chosen if, and only if:

  - the ``--interactive`` option has been given or;
  - the ``ForceInteractive`` setting in the ``General`` section of the
    configuration file is equal to ``1`` or;
  - the user has no valid super magic token.


Requirements
------------

The following software is required to run flo-check-homework:

  - Python 3.1 or later in the 3 series;
  - Qt 4.8 or later;
  - PyQt 4.10.3 is known to work, version 4.9 should be enough and older
    versions will most probably not work with this version of
    flo-check-homework.

Version 0.11.1 of flo-check-homework has been tested on Linux with
Python 3.5.1, Qt 4.8.7 and PyQt 4.11.4. It should work on any platform with
the aforementioned dependencies installed, but trivial bugs are likely to pop
up on non-Unix platforms as no test whatsoever has been done on them. Please
report.

For installation instructions, please refer to INSTALL.txt.


Running flo-check-homework from the Git repository
--------------------------------------------------

flo-check-homework is maintained in a `Git repository
<https://github.com/frougon/flo-check-homework>`_ that can be cloned with::

  git clone https://github.com/frougon/flo-check-homework

It is possible to run flo-check-homework from a clone of that repository, but
two things that are not part of it have to be set up in order for everything
to work properly:

  - the flo_check_homework/images directory tree containing icons and “reward
    images” must be copied from a release tarball, otherwise there will be an
    error when all questions have been answered and the program tries to show
    an image;
  - the .qm files (used for translations) that are relevant to your locale
    settings must be generated from the corresponding .ts source files; this
    can be done automatically with the Makefile shipped in the top-level
    directory of the Git repository, provided you have GNU Make (run 'make').


Advanced tips (or hacks)
------------------------

Since version 0.10.0, it is possible to tell flo-check-homework to use an
intermediate launcher to start the desired program (game or whatever you
want). This is done by setting ProgramLauncher in the configuration file to
the name or path to the launcher executable. This results in a command where
the value of ProgramLauncher is prepended to the command line for the desired
program. Of course, if ProgramLauncher is empty or unset, no intermediate
launcher is used.

This new feature can be used in a setup where for instance /usr/games does not
have the executable bit set for the user running flo-check-homework, but does
have it for a particular group which we'll call gamers for the sake of this
discussion. If you create a custom launcher program in C that uses the
setgroups(2) system call to add the gamers group to the list of supplementary
groups for the calling process before using execve(2) to run the desired
program, then it becomes possible for the user to run the desired program
through flo-check-homework even though it would appear to be impossible at
first (of course, the launcher program is the one providing the required
privileges here, and is also accessible to the user in such a setup).

The setup described in the previous paragraph requires a little modification
to wrapper scripts, which by default check the executable bit of the program
to run. In this case, the check would necessarily fail and should be skipped.
Invoking flo-check-homework-decorate-games with the --no-exec-check option
generates scripts that don't perform such a check.

Note:

  To be of any use, a launcher program as described above would need the
  CAP_SETGID capability on Linux. As a consequence, it would require great
  care in writing and installing. For a start, the GID of the group passed in
  the aforementioned setgroups(2) system call *must not* be something that
  unprivileged users can choose, and that group should have no more powers
  than being able to access /usr/games in a read-only manner. Additionally,
  the launcher program should be installed on a partition where unprivileged
  users have absolutely no write access, otherwise they could make a hard link
  to the executable that would defeat the purpose of a security update (this
  is a general issue to consider whenever using setuid or setgid executables
  or, as described here, programs with special capabilities---in the specific
  sense this word has for Linux, as documented in the capabilities(7) manual
  page). For all these reasons, and because of its obvious side effects (such
  as not being able to execute fortune(6) normally, if installed in
  /usr/games), this kind of setup should only be adopted if really necessary
  (not to mention the fact that it can be easily defeated; as announced in the
  title, it is a hack!).


Additional notes
----------------

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


.. _freedesktop: http://www.freedesktop.org/
.. _Desktop Entry specification: http://www.freedesktop.org/wiki/Specifications/desktop-entry-spec
.. _Debian Free Software Guidelines: http://www.debian.org/social_contract#guidelines

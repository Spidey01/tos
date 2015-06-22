TOS -- The Other ~~System~~ Shit
================================

A very simple and spartan Linux system. I call it TOS as a homage to DOS, which was the operating system on the original IBM PC, and because I can. It is meant to serve in situations where DOS is closer to what I want then a modern burping and farting GNU/Linux distribution. Yet actually have modern programming goodness like POSIX interfaces and preemptive multitasking. 

If you want much more than this:

    linux root=/dev/sda init=/bin/sh

Then you probably should move along little geeky.

Instructions
------------

Because in all the time since ~1976, we have yet to create anything significantly better than Make: that is what I use to build TOS from source.

Because GNU Make is the most dominate form of Make in the known universe at this time, that is what I expect will be used.

Additional tools like GNU AWK may be required to build some modules until the build system is proper, e.g. more like a cross compile instead of leach off the host machine for them. When a configure script fails it should let you know.

There are several build flavors and each module may be built by name. See `make help' for further details.

Build Flavors
-------------

  - minimum
    + The bare essentials. Basically linux + busybox.
  - complete
    + Build *ALL* the things!

Run make help or read the Makefile for full details.


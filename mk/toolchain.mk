#-
# Copyright 2015 Terry Mathew Poulin <BigBoss1964@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include config.mk

ARCH ?= $(shell uname -m)
TARGET ?= $(ARCH)-tos-linux-gnu

O := $(OBJDIR)/toolchain

binutils_srcdir := $(CURDIR)/binutils
binutils_objdir := $(O)/binutils
# We'll use this file as a way to say, "Yeah, binutils is there."
binutils_outfile := $(TOOLSDIR)/bin/$(TARGET)-as

gcc_srcdir := $(CURDIR)/gcc
gcc_objdir := $(O)/gcc
gcc_gmpver := 6.0.0a
gcc_mpfrver := 3.1.3
gcc_mpcver := 1.0.3
gcc_outfile := $(TOOLSDIR)/bin/$(TARGET)-gcc


COMPLETED_MSG = @echo "Completed $@ for target $(TARGET)."

toolchain: $(O) binutils gcc glibc
	@echo "toolchain for $(TARGET) is now in $(TOOLSDIR)."

$(O):
	mkdir -p "$@"

binutils: $(binutils_outfile)
	$(COMPLETED_MSG)

$(binutils_outfile): $(binutils_objdir) $(binutils_objdir)/Makefile
	$(MAKE) -C "$(binutils_objdir)"
	$(MAKE) -C "$(binutils_objdir)" install

$(binutils_objdir):
	mkdir -p "$@"

$(binutils_objdir)/Makefile: $(binutils_srcdir)/configure
	cd $(binutils_objdir) && $(binutils_srcdir)/configure \
		--prefix="$(TOOLSDIR)" \
		--with-sysroot="$(DISTDIR)" \
		--with-lib-path="$(TOOLSDIR)/lib" \
		--target="$(TARGET)" \
		--disable-nls --disable-werror

gcc: $(gcc_outfile)
	$(COMPLETED_MSG)
	@printf "\nDoing git clean -f in $@ to clean up build stuff.\n"
	rm -rf gcc/{gmp,mpfr,mpc}

$(gcc_outfile): gcc-setup $(gcc_objdir)/Makefile
	$(MAKE) -C "$(gcc_objdir)"
	$(MAKE) -C "$(gcc_objdir)" install

$(gcc_objdir)/Makefile: $(gcc_srcdir)/configure
	cd $(gcc_objdir) && $(gcc_srcdir)/configure \
		--target="$(TARGET)" \
		--prefix="$(TOOLSDIR)" \
		--with-sysroot="$(DISTDIR)" \
		--with-glibc-version=2.11 \
		--with-newlib \
		--without-headers \
		--with-local-prefix=/tools \
		--with-native-system-header-dir=/tools/include \
		--disable-nls \
		--disable-shared \
		--disable-multilib \
		--disable-decimal-float \
		--disable-threads \
		--disable-libatomic \
		--disable-libgomp \
		--disable-libquadmath \
		--disable-libssp \
		--disable-libvtv \
		--disable-libstdcxx \
		--enable-languages=c,c++

#
## GCC is kind of a pickle.
#
# We need upstream libraries that are managed using a mixture of version control systems.
# And honestly all I care about is that the C/C++ compiler _works_.
# So let's just download the darn things.
#
gcc-setup: $(gcc_objdir) $(gcc_srcdir)/gmp $(gcc_srcdir)/mpfr $(gcc_srcdir)/mpc

$(gcc_objdir):
	mkdir -p "$@"

RENAME_ARCHIVE = mv -v "$(dir $@)$(notdir $(basename $(basename $<)))" "$@"

# This S.O.B. names the archive different from the content!
$(gcc_srcdir)/gmp: $(O)/gmp-$(gcc_gmpver).tar.xz
	tar -C gcc -xJf "$<"
	mv -v "$@-6.0.0" "$@"
$(gcc_srcdir)/mpfr: $(O)/mpfr-$(gcc_mpfrver).tar.xz
	tar -C gcc -xJf "$<"
	$(RENAME_ARCHIVE)
$(gcc_srcdir)/mpc: $(O)/mpc-$(gcc_mpcver).tar.gz
	tar -C gcc -xzf "$<"
	$(RENAME_ARCHIVE)

$(O)/gmp-$(gcc_gmpver).tar.xz: $(O)
	@echo "Downloading GMP version $(gcc_gmpver)."
	wget -N -P "$(dir $@)" "https://gmplib.org/download/gmp/$(notdir $@)"
$(O)/mpfr-$(gcc_mpfrver).tar.xz: $(O)
	@echo "Downloading MPFR version $(gcc_mpfrver)."
	wget -N -P "$(dir $@)" "http://www.mpfr.org/mpfr-current/$(notdir $@)"
$(O)/mpc-$(gcc_mpcver).tar.gz: $(O)
	@echo "Downloading MPFR version $(gcc_mpfrver)."
	wget -N -P "$(dir $@)" "ftp://ftp.gnu.org/gnu/mpc/$(notdir $@)"


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

COMPLETED_MSG = @echo "Completed $@ for target $(TARGET)."

#
# The toolchain consists of
#
toolchain: $(O) binutils
	@echo "toolchain for $(TARGET) is now in $(TOOLSDIR)."

$(O):
	mkdir -p "$@"

binutils: $(binutils_outfile)
	$(COMPLETED_MSG)

$(binutils_outfile): $(binutils_objdir)/Makefile
	$(MAKE) -C "$(binutils_objdir)"
	$(MAKE) -C "$(binutils_objdir)" install

$(binutils_objdir)/Makefile: $(binutils_objdir)
	cd $(binutils_objdir) && $(binutils_srcdir)/configure \
		--prefix="$(TOOLSDIR)" \
		--with-sysroot="$(DISTDIR)" \
		--with-lib-path="$(TOOLSDIR)/lib" \
		--target="$(TARGET)" \
		--disable-nls --disable-werror

$(binutils_objdir):
	mkdir -p "$@"


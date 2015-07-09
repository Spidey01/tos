#-
# Copyright 2014 Terry Mathew Poulin <BigBoss1964@gmail.com>
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

O := $(OBJDIR)/linux
M := $(MAKE) -C linux "O=$(O)"
LINUX_CONFIG := $(CONFIGDIR)/linux.config
header_to_taste = $(DISTDIR)/usr/include/linux/version.h

# Variables that Linux uses for various targets.
# These are the defaults unless passed in from the outside.
#
INSTALL_HDR_PATH ?= $(DISTDIR)/usr/
INSTALL_MOD_PATH ?= $(DISTDIR)
INSTALL_FW_PATH ?= $(DISTDIR)/lib/firmware

linux: $(DISTDIR)/boot/vmlinuz

# N.B. tar-pkg doesn't include firmware.
$(DISTDIR)/boot/vmlinuz: $(O) $(O)/.config $(header_to_taste) $(DISTDIR)/lib/firmware
	$(M)
	$(M) tar-pkg
	tar -C "$(DISTDIR)" -xf $(O)/linux-*.tar
	cp -iv $@-* "$@"

$(O):
	mkdir -p $@

$(O)/.config: $(LINUX_CONFIG)
	cp -v -- "$<" "$@"
	$(M) olddefconfig

$(header_to_taste): linux-headers_install

$(DISTDIR)/lib/firmware: linux-firmware_install

linux-firmware_install:
	$(M) "INSTALL_FW_PATH=$(INSTALL_FW_PATH)" firmware_install

linux-headers_install:
	$(M) "INSTALL_HDR_PATH=$(INSTALL_HDR_PATH)" headers_install

linux-help:
	$(M) help

linux-menuconfig: $(O)/.config
	$(M) menuconfig
	cp -v -- "$<" $(LINUX_CONFIG)

linux-olddefconfig: $(O)/.config
	$(M) olddefconfig
	cp -v -- "$<" $(LINUX_CONFIG)


.PHONY: linux-olddefconfig

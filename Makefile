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

help:
	@echo "Available targets:"
	@echo
	@echo "\tCleaning targets:"
	@echo
	@echo "\tclean      -- clean all the things."
	@echo "\tdistclean  -- even more clean."
	@echo
	@echo "Module targets:"
	@echo
	@echo "\tbusybox                -- compile busybox."
	@echo "\tbusybox-menuconfig     -- edit etc/busybox.config."
	@echo "\tbusybox-olddefconfig   -- update etc/busybox.config."
	@echo "\tetc                    -- prepare /etc."
	@echo "\tlinux                  -- compile linux."
	@echo "\tlinux-firmware_install -- see linux-help -> firmware_headers."
	@echo "\tlinux-headers_install  -- see linux-help -> headers_install."
	@echo "\tlinux-help             -- run make help for linux."
	@echo "\tlinux-menuconfig       -- edit etc/linux.config."
	@echo "\tlinux-olddefconfig     -- update etc/linux.config."
	@echo "\tglibc                  -- compile GNU C library."
	@echo "\te2fsprogs              -- compile e2fsprogs."
	@echo "\tparted                 -- compile parted."
	@echo "\tfile                   -- compile file utility."
	@echo "\tzlib                   -- compile zlib library."
	@echo
	@echo "Special targets:"
	@echo
	@echo "\tboot       -- tape boot image."
	@echo "\trecovery   -- tape recovery image."
	@echo "\troot       -- tape root image."
	@echo "\tminimum    -- make $(MINIMUM_MODULES)."
	@echo "\tcomplete   -- make $(MODULES)."
	@echo
	@echo "Note that make root does not imply make complete or make minimum."
	@echo

setup:
	-clear
	mkdir -p dist
	mkdir -p dist/dev
	mkdir -p tmp

clean:
	for M in $(MODULES); do $(MAKE) -C "$$M" distclean; done
	rm -rf tmp

distclean: clean
	rm -rf dist


MAKE_MODULE_CMD = script -c "$(MAKE) -I mk -f mk/$@.mk $@" tmp/$@.typescript

MINIMUM_MODULES = busybox etc linux
MODULES = $(MINIMUM_MODULES) glibc e2fsprogs parted zlib file

include $(CURDIR)/mk/extract.mk
include $(CURDIR)/busybox/Makefile

etc: setup
	$(MAKE_MODULE_CMD)

linux: setup
	$(MAKE_MODULE_CMD)

linux-firmware_install:
	$(MAKE) -I mk -f mk/linux.mk $@
linux-headers_install:
	$(MAKE) -I mk -f mk/linux.mk $@
linux-help:
	$(MAKE) -I mk -f mk/linux.mk $@
# Targets to work with the linux configuration.
linux-menuconfig:
	$(MAKE) -I mk -f mk/linux.mk $@
linux-olddefconfig:
	$(MAKE) -I mk -f mk/linux.mk $@

glibc: setup linux-headers_install
	$(MAKE_MODULE_CMD)

# TODO:
# Depends on glibc but we're not able to build against our glibc module yet.
e2fsprogs: setup
	$(MAKE_MODULE_CMD)
parted: setup
	$(MAKE_MODULE_CMD)
zlib: setup
	$(MAKE_MODULE_CMD)
# also depends on zlib but we can't build against our glibc & zlib yet.
file: setup
	$(MAKE_MODULE_CMD)

minimum: $(MINIMUM_MODULES)
	@echo "Minimum TOS build completed."

complete: $(MODULES)
	@echo "Complete TOS build completed."

boot: linux
	$(MAKE_MODULE_CMD)

recovery: setup
	$(MAKE_MODULE_CMD)

root: root.txz
root.txz:
	tar -C dist --exclude ./recovery --exclude ./boot -cJvf "$@" .

usb:
	$(MAKE_MODULE_CMD)

.PHONY: clean setup linux-menuconfig $(MODULES) usb

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

#
# recovery: create a recovery tape.
#

include config.mk

R = $(DISTDIR)/recovery
S = $(CURDIR)/recovery
syslinux_version := 6.03
recovery_dirs = $(foreach D,dev mnt boot images,$(R)/$(D))

recovery: recovery.txz
	@echo "Recovery tape is ready"

$(R) $(recovery_dirs):
	mkdir -p "$@"

$(R)/installer.lib: $(S)/installer.lib $(R)
	cp -v "$<" "$@"
$(R)/installer: $(S)/installer.sh $(R)
	cp -v "$<" "$@"
$(R)/gpt-install: $(S)/gpt-install.sh $(R)
	cp -v "$<" "$@"
$(R)/mbr-install: $(S)/mbr-install.sh $(R)
	cp -v "$<" "$@"

# This actually pulls in everything we want from the OS.
# Not just busybox.
$(R)/bin/busybox: $(R)
	$(MAKE) -C linux O=$(OBJDIR)/linux INSTALL_HDR_PATH=$(R)/usr headers_install
	$(MAKE) "DISTDIR=$(R)" etc busybox e2fsprogs glibc parted

# Apparently syslinux shouldn't be compiled from scratch so use a binary release.
$(R)/syslinux: $(OBJDIR)/syslinux-$(syslinux_version).tar.xz $(R)
	tar -C $(R) -xJf "$<"
	mv "$(R)/syslinux-$(syslinux_version)" "$@"
	
$(OBJDIR)/syslinux-$(syslinux_version).tar.xz:
	wget -N -P "$(dir $@)" "https://www.kernel.org/pub/linux/utils/boot/syslinux/$(notdir $@)"

recovery.txz: $(R) $(recovery_dirs) $(R)/bin/busybox $(R)/syslinux $(R)/installer.lib $(R)/installer $(R)/gpt-install $(R)/mbr-install
	tar -C "$(R)" -f "$@" -cvJ .


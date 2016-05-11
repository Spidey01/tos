#-
# Copyright 2016 Terry Mathew Poulin <BigBoss1964@gmail.com>
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

UEFI_SRCDIR := $(CURDIR)/uefi
UEFI_DISTDIR := $(DISTDIR)/uefi
UEFI_OBJDIR := $(OBJDIR)/uefi
UEFI_BOOTDIR := $(UEFI_DISTDIR)/EFI/BOOT

SYSLINUX_VERSION := 6.03
SYSLINUX_ARCHIVE := $(UEFI_OBJDIR)/syslinux-$(SYSLINUX_VERSION).zip
SYSLINUX_URL := https://www.kernel.org/pub/linux/utils/boot/syslinux/$(notdir $(SYSLINUX_ARCHIVE))
SYSLINUX_DIR := $(UEFI_SRCDIR)/syslinux

uefi: $(UEFI_DISTDIR) $(UEFI_OBJDIR) $(UEFI_BOOTDIR) $(SYSLINUX_DIR)
	cp -u "$(SYSLINUX_DIR)/efi32/efi/syslinux.efi" "$(UEFI_BOOTDIR)/BOOTIA32.EFI"
	cp -u "$(SYSLINUX_DIR)/efi64/efi/syslinux.efi" "$(UEFI_BOOTDIR)/BOOTX64.EFI"
	cp -u \
		"$(SYSLINUX_DIR)/efi32/com32/elflink/ldlinux/ldlinux.e32" \
		"$(SYSLINUX_DIR)/efi64/com32/elflink/ldlinux/ldlinux.e64" \
			"$(UEFI_BOOTDIR)/"
	cp -u "$(UEFI_SRCDIR)/syslinux.cfg" "$(UEFI_BOOTDIR)/"

.PHONY: uefi

$(SYSLINUX_DIR): $(SYSLINUX_ARCHIVE)
	unzip -uo -d "$@" "$<"

$(SYSLINUX_ARCHIVE):
	wget -N -P "$(dir $@)" "$(SYSLINUX_URL)"

$(UEFI_DISTDIR) $(UEFI_OBJDIR) $(UEFI_BOOTDIR):
	mkdir -p "$@"


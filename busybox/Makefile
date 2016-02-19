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

BUSYBOX_VERSION := 1.23.2
BUSYBOX_ARCHIVE := busybox/busybox-$(BUSYBOX_VERSION).tar.bz2
BUSYBOX_SOURCE := $(basename $(basename $(BUSYBOX_ARCHIVE)))
BUSYBOX_URL := https://busybox.net/downloads/$(notdir $(BUSYBOX_ARCHIVE))
BUSYBOX_CONFIG := etc/busybox.config
O := $(OBJDIR)/busybox

busybox: busybox-download busybox-extract busybox-configure busybox-build busybox-install

busybox-download: $(BUSYBOX_ARCHIVE)
$(BUSYBOX_ARCHIVE):
	$(call download_source, $@, $(BUSYBOX_URL))

busybox-extract: $(BUSYBOX_SOURCE)
$(BUSYBOX_SOURCE): $(BUSYBOX_ARCHIVE)
	$(call extract_tbz2_source,$<)

busybox-configure: $(O)/.config

busybox-build:
	$(MAKE) -C $(BUSYBOX_SOURCE) "O=$(O)" "CONFIG_PREFIX=$(DISTDIR)" 

busybox-install:
	$(MAKE) -C $(BUSYBOX_SOURCE) "O=$(O)" "CONFIG_PREFIX=$(DISTDIR)" install

$(O):
	mkdir -p $@

$(O)/.config: $(BUSYBOX_CONFIG) $(O)
	cp "$<" "$@"
	$(MAKE) -C $(BUSYBOX_SOURCE) "O=$(O)" oldconfig

busybox-menuconfig: $(O)/.config
	$(MAKE) -C $(BUSYBOX_SOURCE) "O=$(O)" menuconfig
	cp -v -- "$<" $(BUSYBOX_CONFIG)

busybox-olddefconfig: $(O)/.config
	cp -v -- "$<" $(BUSYBOX_CONFIG)

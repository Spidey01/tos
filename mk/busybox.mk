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

O := $(OBJDIR)/busybox
BB_CONFIG := $(CONFIGDIR)/busybox.config

busybox: $(O)/.config
	$(MAKE) -C $@ "O=$(O)" "CONFIG_PREFIX=$(DISTDIR)" install

$(O):
	mkdir -p $@

$(O)/.config: $(BB_CONFIG) $(O)
	cp "$<" "$@"
	$(MAKE) -C busybox "O=$(O)" oldconfig

busybox-menuconfig: $(O)/.config
	$(MAKE) -C busybox "O=$(O)" menuconfig
	cp -v -- "$<" $(BB_CONFIG)

busybox-olddefconfig: $(O)/.config
	cp -v -- "$<" $(BB_CONFIG)

.PHONY: busybox-olddefconfig

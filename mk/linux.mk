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

# N.B. tar-pkg doesn't include firmware.
linux: $(O) $(O)/.config
	$(M)
	$(M) tar-pkg
	tar -C "$(DISTDIR)" -xf $(O)/linux-*.tar
	$(M) "INSTALL_MOD_PATH=$(DISTDIR)" firmware_install
	$(M) "INSTALL_HDR_PATH=$(DISTDIR)/usr/" headers_install

$(O):
	mkdir -p $@

$(O)/.config: etc/linux.config
	cp -v -- "$<" "$@"
	$(M) olddefconfig


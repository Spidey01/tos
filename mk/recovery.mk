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
S = $(CURDIR)/installer

recovery: $(R)/bin/busybox $(R)/installer.lib $(R)/installer $(R)/gpt-install $(R)/mbr-install recovery.txz

$(R):
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
	$(MAKE) "DISTDIR=$(R)" busybox e2fsprogs glibc

recovery.txz:
	tar -C "$(R)" -f "$@" -cvJ .


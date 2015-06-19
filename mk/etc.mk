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

CP = cp -Rv "$<" "$@" 
CHMOD =	chmod 0644 "$@"
# Should we embed sudo here or what?
CHOWN = @echo TODO: chown root.root "$<"

etc: $(DISTDIR)/etc $(foreach efile,$(wildcard etc/*),$(DISTDIR)/$(efile))
.PHONY: etc

$(DISTDIR)/etc:
	mkdir -p $@

$(DISTDIR)/etc/busybox.config: etc/busybox.config
	$(CP)
	$(CHMOD)
	$(CHOWN)

$(DISTDIR)/etc/linux.config: etc/linux.config
	 $(CP)
	 $(CHOWN)
	 $(CHMOD)


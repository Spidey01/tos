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
	@echo "\tbusybox    -- compile busybox."
	@echo "\tetc        -- prepare /etc."
	@echo "\tlinux      -- compile linux."
	@echo "\tminimum    -- $(MINIMUM_MODULES)."
	@echo "\tclean      -- clean all the things."
	@echo "\tdistclean  -- even more clean."
	@echo

setup:
	-clear
	mkdir -p dist
	mkdir -p tmp

clean:
	for M in $(MODULES); do $(MAKE) -C "$$M" distclean; done
	rm -rf tmp

distclean: clean
	rm -rf dist


MAKE_MODULE_CMD = script -c "$(MAKE) -I mk -f mk/$@.mk $@" tmp/$@.typescript

MINIMUM_MODULES = busybox etc linux
MODULES = $(MINIMUM_MODULES)

busybox: setup
	$(MAKE_MODULE_CMD)

etc: setup
	$(MAKE_MODULE_CMD)

linux: setup
	$(MAKE_MODULE_CMD)

minimum: 
	@echo "Minimum TOS build completed."

installer: setup $(MODULES)
	$(MAKE_MODULE_CMD)

.PHONY: clean setup $(MODULES)

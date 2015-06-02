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
	@echo "\tbusybox -- compile busybox."
	@echo "\tclean   -- clean all the things."
	@echo

setup:
	-clear
	mkdir -p dist
	mkdir -p tmp

clean:
	make -C busybox distclean
	rm -rf tmp


MAKE_MODULE_CMD = script -c "$(MAKE) -I mk -f mk/$@.mk $@" tmp/$@.typescript

MODULES = busybox

busybox: setup
	$(MAKE_MODULE_CMD)

installer: setup $(MODULES)
	$(MAKE_MODULE_CMD)

.PHONY: clean setup $(MODULES)

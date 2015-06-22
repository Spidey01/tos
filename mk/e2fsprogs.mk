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

O := $(OBJDIR)/e2fsprogs

# TODO:
# Ideally we want to build against our glibc but our build system doesn't support that yet.
# Thus for now we build against the host environment :'(.

e2fsprogs: $(O) $(O)/Makefile
	$(MAKE) -C $(O) 
	$(MAKE) -C $(O) DESTDIR=$(DISTDIR) install-libs
	$(MAKE) -C $(O) DESTDIR=$(DISTDIR) install

$(O):
	mkdir -p $@

# TODO: dont' hard code lib64 like an ass :'(
$(O)/Makefile: e2fsprogs/configure
	cd $(O) && ../../e2fsprogs/configure \
		--prefix=/usr \
		--libdir=/usr/lib64 \
		--enable-elf-shlibs


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

O := $(OBJDIR)/zlib

# zlib doesn't support out of tree builds? :/. Clean up after.
# TODO: dont' hard code lib64 like an ass :'(
zlib: zlib/libz.so 
	cd $@ && git clean -f
	cd $@ && git reset --hard HEAD

zlib/libz.so: zlib/configure.log
	$(MAKE) -C $(dir $@)
	$(MAKE) -C $(dir $@) DESTDIR=$(DISTDIR) install

zlib/configure.log:
	cd $(dir $@) && ./configure \
		--prefix=/usr \
		--libdir=/usr/lib64


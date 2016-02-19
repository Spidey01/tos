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

ZLIB_VERSION := 1.2.8
ZLIB_ARCHIVE := zlib/zlib-$(ZLIB_VERSION).tar.xz
ZLIB_SOURCE := $(basename $(basename $(ZLIB_ARCHIVE)))
ZLIB_URL := http://zlib.net/$(notdir $(ZLIB_ARCHIVE))

zlib: zlib-download zlib-extract zlib-configure zlib-build zlib-install

zlib-download: $(ZLIB_ARCHIVE)
$(ZLIB_ARCHIVE):
	$(call download_source, $@, $(ZLIB_URL))

zlib-extract: $(ZLIB_SOURCE)
$(ZLIB_SOURCE): $(ZLIB_ARCHIVE)
	$(call extract_txz_source,$<)

zlib-configure: $(ZLIB_SOURCE)/configure.log
$(ZLIB_SOURCE)/configure.log:
	cd $(dir $@) && ./configure \
		--prefix=/usr \
		--libdir=/usr/lib64

# Sigh, zlib doesn't support building from outside its source tree.
zlib-build:
	$(MAKE) -C $(ZLIB_SOURCE)

zlib-install:
	$(MAKE) -C $(ZLIB_SOURCE) DESTDIR=$(DISTDIR) install


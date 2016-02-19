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

PARTED_VERSION := 3.2
PARTED_ARCHIVE := parted/parted-$(PARTED_VERSION).tar.xz
PARTED_SOURCE := $(basename $(basename $(PARTED_ARCHIVE)))
PARTED_URL := ftp://ftp.gnu.org/gnu/parted/$(notdir $(PARTED_ARCHIVE))
O := $(OBJDIR)/parted

parted: parted-download parted-extract parted-configure parted-build parted-install

parted-download: $(PARTED_ARCHIVE)
$(PARTED_ARCHIVE):
	$(call download_source, $@, $(PARTED_URL))

parted-extract: $(PARTED_SOURCE)
$(PARTED_SOURCE): $(PARTED_ARCHIVE)
	$(call extract_txz_source,$<)

parted-configure: $(O)/config.log
$(O)/config.log: $(O)
	cd $O && $(CURDIR)/$(PARTED_SOURCE)/configure \
		--prefix=/usr \
		--libdir=/usr/lib64 \
		--sysconfdir=/etc \
		--without-readline \
		--disable-nls \
		--disable-device-mapper

parted-build:
	$(MAKE) -C $(O)

parted-install:
	$(MAKE) -C $(O) DESTDIR=$(DISTDIR) install

$(O):
	mkdir -p $@



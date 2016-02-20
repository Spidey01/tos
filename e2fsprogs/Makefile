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

# uhh, why is there a separate -libs tarball?
#
#	https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.13/e2fsprogs-1.42.13.tar.xz
#	https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.13/e2fsprogs-libs-1.42.13.tar.xz
#
E2FSPROGS_VERSION := 1.42.13
E2FSPROGS_ARCHIVE := e2fsprogs/e2fsprogs-$(E2FSPROGS_VERSION).tar.xz
E2FSPROGS_SOURCE := $(basename $(basename $(E2FSPROGS_ARCHIVE)))
E2FSPROGS_URL := http://kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.13/$(notdir $(E2FSPROGS_ARCHIVE))
O := $(OBJDIR)/e2fsprogs

e2fsprogs: e2fsprogs-download e2fsprogs-extract e2fsprogs-configure e2fsprogs-build e2fsprogs-install

e2fsprogs-download: $(E2FSPROGS_ARCHIVE)
$(E2FSPROGS_ARCHIVE):
	$(call download_source, $@, $(E2FSPROGS_URL))

e2fsprogs-extract: $(E2FSPROGS_SOURCE)
$(E2FSPROGS_SOURCE): $(E2FSPROGS_ARCHIVE)
	$(call extract_txz_source,$<)

e2fsprogs-configure: $(O)/config.log
$(O)/config.log: $(O)
	cd $O && $(CURDIR)/$(E2FSPROGS_SOURCE)/configure \
		--prefix=/usr \
		--libdir=/usr/lib64 \
		--sysconfdir=/etc \
		--enable-elf-shlibs

e2fsprogs-build:
	$(MAKE) -C $(O)

e2fsprogs-install:
	$(MAKE) -C $(O) DESTDIR=$(DISTDIR) install-libs install

$(O):
	mkdir -p $@


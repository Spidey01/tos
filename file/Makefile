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

FILE_VERSION := 5.25
FILE_ARCHIVE := file/file-$(FILE_VERSION).tar.gz
FILE_SOURCE := $(basename $(basename $(FILE_ARCHIVE)))
FILE_URL := ftp://ftp.astron.com/pub/file/$(notdir $(FILE_ARCHIVE))
O := $(OBJDIR)/file

#####################

# We need to autoreconf the source so may as well clean up the git after a build.
# file: $(O) $(O)/Makefile
	# $(MAKE) -C $(O) 
	# $(MAKE) -C $(O) DESTDIR=$(DISTDIR) install
	# @printf "\nDoing git clean -f in $@ to clean up autoconf stuff.\n"
	# cd "$@" && git clean -f
	# rm -rf "$@/autom4te.cache"

# file/configure: file/configure.ac $(O)
	# autoreconf -f -i file

####################################

file: file-download file-extract file-configure file-build file-install

file-download: $(FILE_ARCHIVE)
$(FILE_ARCHIVE):
	$(call download_source, $@, $(FILE_URL))

file-extract: $(FILE_SOURCE)
$(FILE_SOURCE): $(FILE_ARCHIVE)
	$(call extract_tgz_source,$<)

file-configure: $(O)/config.log
$(O)/config.log: $(O)
	cd $O && $(CURDIR)/$(FILE_SOURCE)/configure \
		--prefix=/usr \
		--libdir=/usr/lib64 \
		--sysconfdir=/etc \
		--disable-silent-rules

file-build:
	$(MAKE) -C $(O)

file-install:
	$(MAKE) -C $(O) DESTDIR=$(DISTDIR) install

$(O):
	mkdir -p $@


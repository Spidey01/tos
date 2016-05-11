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

include config.mk

RPI_SRCDIR := $(CURDIR)/raspberry_pi
RPI_DISTDIR := $(DISTDIR)/raspberry_pi
RPI_OBJDIR := $(OBJDIR)/raspberry_pi

FIRMWARE_VERSION := 1.20160315
FIRMWARE_URL := https://github.com/raspberrypi/firmware/archive/$(FIRMWARE_VERSION).zip
FIRMWARE_ARCHIVE := $(RPI_OBJDIR)/$(FIRMWARE_VERSION).zip
FIRMWARE_DIR := $(RPI_SRCDIR)/firmware-$(basename $(notdir $(FIRMWARE_ARCHIVE)))

.PHONY: raspberry_pi
raspberry_pi: $(RPI_DISTDIR) $(RPI_OBJDIR) $(FIRMWARE_DIR)
	cp -ur "$(FIRMWARE_DIR)"/boot/* "$(RPI_DISTDIR)/"
	cp -ur "$(FIRMWARE_DIR)/documentation" "$(RPI_DISTDIR)/"
	cp -ur "$(FIRMWARE_DIR)/extra" "$(RPI_DISTDIR)/"
	cp -ur "$(FIRMWARE_DIR)/hardfp" "$(RPI_DISTDIR)/"
	cp -ur "$(FIRMWARE_DIR)/modules" "$(RPI_DISTDIR)/"
	cp -ur "$(FIRMWARE_DIR)/opt" "$(RPI_DISTDIR)/"
	cp -u "$(RPI_SRCDIR)"/*.cmdline "$(RPI_DISTDIR)/"
	
$(FIRMWARE_DIR): $(FIRMWARE_ARCHIVE)
	unzip -uo -d $(dir $@) $<

$(FIRMWARE_ARCHIVE):
	wget -N -P "$(dir $@)" "$(FIRMWARE_URL)"

$(RPI_DISTDIR) $(RPI_OBJDIR):
	mkdir -p "$@"


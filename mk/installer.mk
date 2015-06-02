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

include config.mk

all: image-file

BB := "$(DISTDIR)/bin/busybox"
NAME := $(shell $(BB) date "+%Y-%m-%dT%H%M%S").img
#
## N.B. that Busybox defines:
#
# 'M' megabytes as MiB, e.g. 1024*1024.
# 'MB' megabytes as MB, e.g. 1000*1000
#
# As far as du -m and dd bs=1M and dd bs=1MB is concerned.
#
SIZE := $(shell $(BB) du -sm $(DISTDIR) | cut -f 1)
# Double it.
SIZE := $(shell $(BB) expr $(SIZE) \* 2)
#
# For right now it's so tiny just hard code 10.
#
SIZE := 10
#
#
MNT := "$(OBJDIR)/mnt"

debug:
	@echo "Using Busybox from '$(BB)'."
	@echo "Image name is '$(NAME)'."
	@echo "Size required is '$(SIZE)' MiB."

.PHONY: debug

installer: image-file

image-file: debug $(NAME)

$(NAME):
ifneq ($(shell id -u),0)
	$(error target '$@' must be run as root!)
endif
	$(BB) dd if=/dev/zero "of=$@" "count=$(SIZE)" bs=1M
	$(BB) mkfs.ext2 -F -L "TOS" "$@"
	$(BB) mkdir -p $(MNT)
	$(BB) mount -o loop,rw "$@" $(MNT)
	$(warning best would be an error handler to umount)
	-$(BB) tar -C dist -f - -c . | $(BB) tar -C $(MNT) -f - -x
	$(BB) umount $(MNT)


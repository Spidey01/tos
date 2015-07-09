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

help:
	@echo "Use the usb target with DEVICE=/dev/... and MNT=/your/mount/point"
	$(warning You must do make complete or make minimum before using this makefile.)

usb: usb-setup boot.txz recovery.txz root.txz

usb-setup:
ifndef DEVICE
	$(error Must call make with DEVICE set to the USB device to build.)
endif
ifndef MNT
	$(error Must call make with MNT set to the mount place for build.)
endif
	sudo $(CURDIR)/scripts/mk-usb "$(DEVICE)" "$(MNT)"

boot.txz recovery.txz root.txz:
	$(MAKE) $(basename $@)


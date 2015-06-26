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

#
# boot: create a boot tape for the kernel.
#

include config.mk

B = $(DISTDIR)/boot

boot: boot.txz
	@echo "Boot tape is ready"

# This target makes sure running this manually will blow up unless you already
# did meet the dependency on a linux kernel.
boot.txz: $(B)/vmlinuz
	tar -C "$(B)" -f "$@" --exclude vmlinux\* -cvJ .



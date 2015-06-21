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

O := $(OBJDIR)/glibc

# Clear this because otherwise it tends to mess up everything.
LD_LIBRARY_PATH = 

# According to glibc FAQ, glibc cannot be built with -fstack-protector
CFLAGS += -fno-stack-protector -U_FORTIFY_SOURCE

# TODO: but it doesn't pass. Maybe if we properly cross-compile instead of using the host environment?
# $(MAKE) -C $(O) stop-on-test-failure=y check
glibc: $(O) $(O)/Makefile
	$(MAKE) -C $(O) 
	$(MAKE) -C $(O) DESTDIR=$(DISTDIR) install

$(O):
	mkdir -p $@

# TODO: either make a way to centralize kernel version or drop the config option.
# Can probably parse the git tag. or just assume the users uname is <= our linux.
# Also can probably move these into a file as with_headers=, blah, blah and just env CONFIG_SITE=thatfile.
$(O)/Makefile: glibc/configure
	cd $(O) && ../../glibc/configure \
		--prefix=/usr \
		--with-headers=$(DISTDIR)/usr/include/ \
		--enable-kernel=3.0.0 \
		--disable-profile \
		--enable-hardcoded-path-in-tests


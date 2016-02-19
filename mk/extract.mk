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


# format, input
define extract_source
	[ -d $(basename $2) -o -d $(basename $(basename $2)) ] || tar -x $1 -f $2 -C $(dir $2)
endef

# input
extract_txz_source = $(call extract_source, -J, $1)
extract_tgz_source = $(call extract_source, -z, $1)
extract_tbz2_source = $(call extract_source, -j, $1)


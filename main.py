#
# Copyright 2022 Erwan Mahe (github.com/erwanM974)
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

from implem.generate import generation_process
from implem.analyze import analysis_process



def experiment(num_tries,polling_timeout):
    confs = [("coping", 5, False), ("sensor", 3, True), ("abp", 5, True), ("network", 5, True)]
    for (int_name,num_slices_per_mu,is_slice_wide) in confs:
        generation_process(int_name,num_slices_per_mu,is_slice_wide)
        analysis_process(int_name, num_tries, polling_timeout)


if __name__ == '__main__':
    experiment(5,4)


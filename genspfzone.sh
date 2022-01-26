#!/bin/sh
##############################################################################
#
# Copyright 2015 spf-tools team (see AUTHORS)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.
#
##############################################################################

test -n "$DEBUG" && set -x

ORIGDOMAIN=${1:-'spf-orig.spf-tools.eu.org'}
DOMAIN=${1:-'spf-tools.eu.org'}

a="/$0"; a=${a%/*}; a=${a:-.}; a=${a#/}/; BINDIR=$(cd "$a" || exit; pwd)
PATH=$BINDIR:$PATH

despf.sh "$ORIGDOMAIN" | simplify.sh | mkblocks.sh "$DOMAIN" spf | mkzoneent.sh

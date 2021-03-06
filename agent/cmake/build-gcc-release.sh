#!/bin/sh
#*******************************************************************************
# Copyright (c) 2011, 2013 Wind River Systems, Inc. and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# and Eclipse Distribution License v1.0 which accompany this distribution.
# The Eclipse Public License is available at
# http://www.eclipse.org/legal/epl-v10.html
# and the Eclipse Distribution License is available at
# http://www.eclipse.org/org/documents/edl-v10.php.
# You may elect to redistribute this code under either of these licenses.
#
# Contributors:
#     Wind River Systems - initial API and implementation
#*******************************************************************************
[ -d gcc-release ] || mkdir gcc-release
cd gcc-release
[ -f Makefile ] || cmake -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ../..
make $*

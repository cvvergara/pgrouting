# This file is part of the pgRouting project.
# Copyright (c) 2022-2026 pgRouting developers
# License: GPL-2 See https://github.com/pgRouting/pgrouting/blob/main/LICENSE
ADD_LIBRARY(ordering OBJECT
    kingOrdering.c
    cuthillMckeeOrdering.c
    cuthillMckeeOrdering_driver.cpp
    sloanOrdering.c
    ordering_driver.cpp
    ordering_process.cpp
    )

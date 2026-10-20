#!/bin/bash
# This file is part of the pgRouting project.
# Copyright (c) 2026-2026 pgRouting developers
# License: GPL-2 See https://github.com/pgRouting/pgrouting/blob/main/LICENSE

# This test checks that the pgTAP plan() uses the positive form:
#   SELECT CASE WHEN min_version('x.y.z') THEN plan(N) ELSE plan(1) END;
# instead of the negative form:
#   SELECT CASE WHEN NOT min_version('x.y.z') THEN plan(1) ELSE plan(N) END;
#
# Usage: test_pgtap_plan.sh [PATH] [--strict]
#   PATH      file or directory to check (default: pgtap)
#   --strict  exit with non zero status when violations are found
#
# By default the check is report only: the violations are listed but the
# exit status is 0, so it can be enabled in CI while the legacy tests are
# being updated. Use --strict to make the violations fail the run.

DIR=$(git rev-parse --show-toplevel)
pushd "${DIR}" > /dev/null || exit 1

TARGET="pgtap"
STRICT=0
for arg in "$@"; do
    case "${arg}" in
        --strict) STRICT=1 ;;
        *) TARGET="${arg}" ;;
    esac
done

if [ ! -e "${TARGET}" ]; then
    echo " *** ${TARGET} does not exist"
    popd > /dev/null || exit 1
    exit 1
fi

if [ -d "${TARGET}" ]; then
    mapfile -t FILES < <(find "${TARGET}" -name '*.pg' | sort)
else
    FILES=("${TARGET}")
fi

found=0
for f in "${FILES[@]}"; do
    matches=$(grep -nE 'NOT min_version.*plan\(|plan\(.*NOT min_version' "${f}")
    if [ -n "${matches}" ]; then
        if [ "${found}" -eq 0 ]; then
            echo " *****************************************************************"
            echo " *** pgTAP plan() must use the positive form:"
            echo " ***   CASE WHEN min_version(...) THEN plan(N) ELSE plan(1) END"
            echo " *** instead of:"
            echo " ***   CASE WHEN NOT min_version(...) THEN plan(1) ELSE plan(N) END"
            echo " *****************************************************************"
        fi
        found=1
        while IFS= read -r line; do
            echo "${f}:${line}"
        done <<< "${matches}"
    fi
done

if [ "${found}" -eq 0 ]; then
    echo "pgTAP plan() positivity check: OK"
else
    echo
    echo " *** Negative plan() form found in ${TARGET} (report only, see --strict)"
fi

popd > /dev/null || exit 1

if [ "${STRICT}" -eq 1 ]; then
    exit "${found}"
fi
exit 0

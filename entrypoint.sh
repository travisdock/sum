#!/bin/bash

if bundle check
then
  echo "Bundle installing..."
  bundle install --jobs=`getconf _NPROCESSORS_ONLN` > ${BUNDLE_PATH}/bundle_install
  tail -n 2 ${BUNDLE_PATH}/bundle_install
else
  bundle install --jobs=`getconf _NPROCESSORS_ONLN`
fi

exec "$@"

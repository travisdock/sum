#!/bin/bash

if bundle check
then
  echo "Bundle installing..."
  bundle install --jobs=$(nproc) > ${BUNDLE_PATH}/bundle_install
  tail -n 2 ${BUNDLE_PATH}/bundle_install
else
  bundle install --jobs=$(nproc)
fi

exec "$@"

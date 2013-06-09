#!/bin/bash

MASTER=./apmea/ApplicationResources.utf8

for CHILD in $(find . | grep utf8)
do
  diff -bB \
  --old-line-format='-%l
  ' \
  --new-line-format='>>%l
  ' \
  --unchanged-line-format=' %l
  ' \
  $MASTER $CHILD
  echo
done

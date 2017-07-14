#!/bin/bash

if [ -z $1 ];then
  echo "Runtime version required"
  exit 1
fi

EL_RUNTIME_ROOT=/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS\ ${1}.simruntime/Contents/Resources/RuntimeRoot

sudo cp -vR ${PWD}/layout/System/Library/TextInput/TextInput_emoji.bundle/*.lproj "${EL_RUNTIME_ROOT}/System/Library/TextInput/TextInput_emoji.bundle/"

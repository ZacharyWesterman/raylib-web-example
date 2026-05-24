#!/usr/bin/env bash

#Create a new shell for the emsdk env

bash --rcfile <(echo '. ~/.bashrc; export PS1="(emsdk) $PS1"; EMSDK_QUIET=1 source emsdk/emsdk_env.sh')

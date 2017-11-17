#!/usr/bin/env bash

PASS="See.matt.run.2017b"

vsql -h 'shr4-vrt-pro-vglb1.houston.hp.com' -U 'matthew.jeremy.wright@hpe.com' -w $PASS -p 5433 -c \
    "select count(*) from hpcom_usr.mjw_sum1_grm;"
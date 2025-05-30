#!/bin/bash

eb create algatransito-prod \
    --instance_type t3.micro \
    --single \
    --keyname aws-eb-algatransito \
    --database \
    --database.engine mysql \
    --database.version 8.0 \
    --database.instance db.t3.micro \
    --database.size 20 \
    --database.username admin \
    --database.password DaXKdT7sZo
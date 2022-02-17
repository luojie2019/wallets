#!/bin/bash

ln -fs ../environments/$1/config/database.yml .

ln -fs ../environments/$1/config/redis.yml .

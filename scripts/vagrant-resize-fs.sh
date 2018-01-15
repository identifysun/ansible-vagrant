#! /bin/bash

cfdisk /dev/sda
xfs_growfs /dev/sda1

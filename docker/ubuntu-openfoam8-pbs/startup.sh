#!/bin/bash

# start TORQUE services
service torque-server start
service torque-scheduler start
service torque-mom start

# create and set the "batch" Queue
qmgr -c "create queue batch queue_type = execution"
qmgr -c "set queue batch priority = 0"
qmgr -c "set queue batch resources_default.nodes = 1"
qmgr -c "set queue batch resources_default.ncpus = 1"
qmgr -c "set queue batch resources_default.walltime = 24:00:00"
qmgr -c "set queue batch keep_completed = 60"
qmgr -c "set queue batch enabled = true"
qmgr -c "set queue batch started = true"

# set server profile
qmgr -c "set server default_queue = batch"
qmgr -c "set server operators += root@HOST"
qmgr -c "set server managers += root@HOST"
qmgr -c "set server scheduling = true"
qmgr -c "set server allow_node_submit = true"
qmgr -c "set server acl_roots += root@*"

# start TORQUE services
service torque-server stop
service torque-scheduler restart
sleep 5
service torque-server start

# keep alive
tail -f /dev/null
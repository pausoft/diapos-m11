# Muntar clúster HA amb ClusterLabs

## Corosync

Group Communication System with additional features for implementing high availability within applications.

The project provides four C Application Programming Interface features:

- **Virtual synchrony:** A closed process group communication model with virtual synchrony guarantees for creating replicated state machines.
- **Availavility:** A simple availability manager that restarts the application process when it has failed.
- **Information:** A configuration and statistics in-memory database that provide the ability to set, retrieve, and receive change notifications of information.
 - **Quorum:** A quorum system that notifies applications when quorum is achieved or lost.

## Pacemaker

Pacemaker is an Open Source, High Availability resource manager suitable for both small and large clusters.

Features

- Detection and recovery of machine and application-level failures
- Supports practically any redundancy configuration
- Supports both quorate and resource-driven clusters
- Configurable strategies for dealing with quorum loss (when multiple machines fail)
- Supports application startup/shutdown ordering, regardless machine(s) the applications are on
- Supports applications that must/must-not run on the same machine
- Supports applications which need to be active on multiple machines
- Supports applications with multiple modes (eg. master/slave)
- Provably correct response to any failure or cluster state. The cluster's response to any stimuli can be tested offline before the condition exists

## DRDB


## ScanCore
Alert and monitoring

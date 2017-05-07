# ServiceChains

## Overview

This workshop will teach you how to use network rule chains to push traffic through security functions. This allows security functions, such as network monitors, IDS/IPS, web filters and web proxies, to be placed inline with the network traffic without having to route traffic through layer 3 IPs.

As part of this workshop, each attendee will be assigned a physical server running their own private OpenStack cloud. This physical server can be access via SSH or the Horizon GUI. Each physical server has 32 GB of RAM and 6 floating IP addresses. This allows six virtual machines to run comfortably in the cloud. The floating IP addresses allow remote network access to the virtual machines.

The MidoNet neutron plugin has been installed to allow the service chaining. For more information about rule chains in MidoNet, please read: https://docs.midonet.org/docs/latest-en/operations-guide/content/index.html

This workshop consists of a number of exercises going from the basics through more advanced configurations. Once you've completed the steps below to familiarize your self and configure the lab, please proceed to the exercises.

## Cloud Assignments

Each workshop attendee is provided an OpenStack cloud preconfigured with the required networking plugins to support service chains. When you arrive at the workshop, you'll be assigned a lab number (i.e. 001), a server name (i.e. ewr001.openstacksandiego.us) and a password.

At this point, please proceed to https://github.com/OpenStackSanDiego/ServiceChains/blob/master/LabSetup.md

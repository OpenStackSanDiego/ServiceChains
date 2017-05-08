# About This Workshop

Some background about this workshop around how it works and why we we put it together.

## Contacts

 * @_techcet_ - Cynthia Thomas - Director of Customer Success with Midokura
 * @johnstudarus - John Studarus - Technical Risk, Compliance, and Security Advisor with JHL Consulting

## Why Layer 2?

I (John) got involved with OpenStack when a client asked me to put together a bundle of multiple underlying security products (i.e. an IDS/IPS/DDOS/DLP combo of multiple products/VMs) that could quickly and seamlessly be deployed into a customers virtual private cloud. Normally this would be done at layer three (IP) and route traffic through various devices. Unfortunately, this requires reconfiguration of the customers network as these additional networks are introduced. This is best done at layer 2 allowing virtualized security solutions to be slipped in and out of the traffic flow without requiring any changes to the layer 3 networking. This lead me to looking at OpenStack Neutron plugins that allow for such layer 2 manipulation of traffic.

This workshop provides all the tools needed to deploy a number of open source security products within an OpenStack layer two cloud. This includes a full OpenStack cloud, an OpenStack neutron plugin with layer two support (MidoNet), some open source security tools and the instructions to make it all happen.

## OpenStack with MidoNet Plugin

This lab consists of an OpenStack cloud with the open-source MidoNet neutron plugin. This plugin allows for layer 2 manipulation of traffic. Using Terraform and the MidoNet Aomi set of playbooks, each lab is configured with a physical server with a full OpenStack installation. More about MidoNet is available at http://www.midokura.com/midonet/

The MidoNet neutron plugin has been installed to allow the service chaining. For more information about rule chains in MidoNet, please read: https://docs.midonet.org/docs/latest-en/operations-guide/content/index.html

Here's some other MidoNet references:
Join our Slack channel! https://midonet.slack.com/
MidoNet community page: https://www.midonet.org/

## Hardware and Internet Networking with Packet

Thank you to Packet Hosting (www.packet.net) for providing the underlying bare metal as a service to run this lab. Physical servers are allocated (one physical server per lab) using the Packet APIs via Terraform. Packet provided each physical server/lab a /29 subnet to be used for external Internet connectivity (configured via OpenStack external networking). More about Packet is available at http://www.packet.net

## Security Products

A number of opensource security products are made available within each cloud lab (Snort, TCPDump, Squid, pfSense). Within the workshop, these can be deployed as virtual machines to view and manipulate the traffic at layer 2.




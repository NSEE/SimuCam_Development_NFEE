/******************************************************************************
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
* All rights reserved. All use of this software and documentation is          *
* subject to the License Agreement located at the end of this file below.     *
******************************************************************************
* Date - October 24, 2006                                                     *
* Module - network_utilities.c                                                *
*                                                                             *
******************************************************************************/

#include "network_utilities.h"

/*
* get_mac_addr
*
* Read the MAC address in a board specific way.
*
*/
int get_mac_addr(NET net, unsigned char mac_addr[6])
{
    bool bSuccess = FALSE;
    
    /* Get MAC from RTC module*/
    bSuccess = RTCC_SPI_R_MAC(mac_addr);

    printf("MAC: %x : %x : %x : %x : %x : %x \n", mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5] );

    if(bSuccess == FALSE)
    {
        /* Fail in read the MAC ADDRESS, loading the Default from sdcard */
    	mac_addr[0] = xConfEth.ucMAC[0];
    	mac_addr[1] = xConfEth.ucMAC[1];
    	mac_addr[2] = xConfEth.ucMAC[2];
    	mac_addr[3] = xConfEth.ucMAC[3];
    	mac_addr[4] = xConfEth.ucMAC[4];
    	mac_addr[5] = xConfEth.ucMAC[5];
    }
    return bSuccess;
}

/*
 * get_ip_addr()
 *
 * This routine is called by InterNiche to obtain an IP address for the
 * specified network adapter. Like the MAC address, obtaining an IP address is
 * very system-dependant and therefore this function is exported for the
 * developer to control.
 *
 * In our system, we are either attempting DHCP auto-negotiation of IP address,
 * or we are setting our own static IP, Gateway, and Subnet Mask addresses our
 * self. This routine is where that happens.
 */
int get_ip_addr(alt_iniche_dev *p_dev,
                ip_addr* ipaddr,
                ip_addr* netmask,
                ip_addr* gw,
                int* use_dhcp)
{

    if (xConfEth.bDHCP == FALSE) {
        *use_dhcp = 0;
        IP4_ADDR(*ipaddr, xConfEth.ucIP[0], xConfEth.ucIP[1], xConfEth.ucIP[2], xConfEth.ucIP[3]);
        IP4_ADDR(*gw, xConfEth.ucGTW[0], xConfEth.ucGTW[1], xConfEth.ucGTW[2], xConfEth.ucGTW[3]);
        IP4_ADDR(*netmask, xConfEth.ucSubNet[0], xConfEth.ucSubNet[1], xConfEth.ucSubNet[2], xConfEth.ucSubNet[3]);
        printf("Static IP Address is %d.%d.%d.%d\n",
            ip4_addr1(*ipaddr),
            ip4_addr2(*ipaddr),
            ip4_addr3(*ipaddr),
            ip4_addr4(*ipaddr));
    } else {
    	*use_dhcp = 1;
        IP4_ADDR(*ipaddr, 0, 0, 0, 0);
        IP4_ADDR(*gw, 0, 0, 0, 0);
        IP4_ADDR(*netmask, 255, 255, 255, 0);
    	printf("Using DHCP \n");
    }

    return 1;
}

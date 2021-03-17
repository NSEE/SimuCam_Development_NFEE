#!/bin/perl

# ============================================================================
# Copyright (c) 2014 by Terasic Technologies Inc. 
# ============================================================================
#
# Permission:
#
#   Terasic grants permission to use and modify this code for use
#   in synthesis for all Terasic Development Boards and Altera Development 
#   Kits made by Terasic.  Other use of this code, including the selling 
#   ,duplication, or modification of any portion is strictly prohibited.
#
# Disclaimer:
#
#   This VHDL/Verilog or C/C++ source code is intended as a design reference
#   which illustrates how these types of functions can be implemented.
#   It is the user's responsibility to verify their design for
#   consistency and functionality through the use of formal
#   verification methods.  Terasic provides no warranty regarding the use 
#   or functionality of this code.
#
# ============================================================================
#           
#                     Terasic Technologies Inc
#                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
#                     HsinChu County, Taiwan
#                     302
#
#                     web: http:#www.terasic.com/
#                     email: support@terasic.com
#
# ============================================================================
# Major Functions:	
#   DE4 Board Program flash tools
#
# ============================================================================
# Design Description:
#
# ===========================================================================
# Revision History :
# ============================================================================
#   Ver  :| Author            :| Mod. Date :| Changes Made:
#   V-.- :| Eric Chen         :| 10/06/06  :| Initial Version
#   V1.0 :| Rodrigo Franca    :| 21/03/16  :| Added option to set cable for nios2-terminal
# ============================================================================


my $board_cable_name	  = "-";


&init;
&menu;


sub	menu
{
	$SELECT = 100;
	until ($SELECT eq "D")# or $SELECT eq "0")
	{
		system "clear";
		printf "DE4 NIOS II Terminal Tools.  ver : 1.0.0.0\n";
		printf "\n";
		printf "*************************  NIOS II Terminal Menu **************************\n";
		printf "\n";
		printf "  0) Open NIOS II Terminal (default)\n";
		printf "  1) Open NIOS II Terminal (persistent)\n";
		printf "\n";
		printf "*************************    Board Cable Menu    **************************\n";
		printf "\n";
		printf "  8) Set cable to use when programming the board flash\n";
		printf "  9) Clear cable settings (will only work with a single cable)\n";
		printf "  L) List all connected cables\n";
		printf "\n";
		printf "     Current board cabe: $board_cable_name\n";
		printf "\n";
		printf "***************************************************************************\n";
		printf "\n";
		printf "Enter a number (D for Done): ";

		$SELECT = <STDIN>;   
		chop($SELECT);
		$SELECT =~ tr/a-z/A-Z/; 

		if	(					 ($SELECT eq "0"))	{&open_nios2_terminal_hardware;}
		if	(					 ($SELECT eq "1"))	{&open_nios2_terminal_persistent;}
		if	(                    ($SELECT eq "8"))	{&board_cable_set;}
		if	(                    ($SELECT eq "9"))	{&board_cable_clear;}
		if	(                    ($SELECT eq "L"))	{&board_cable_list;}
	}
}


sub init
{
	
}

#==============================================================================
#==============================================================================

sub open_nios2_terminal_hardware
{
	system "clear";
	
	printf "Opening NIOS II Terminal (default)...\n";
	if ($board_cable_name eq "-")
	{
		system "nios2-terminal --verbose --hardware";
	}
	else
	{
		system "nios2-terminal --verbose --hardware --cable='$board_cable_name'";
	}
	
	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}

#==============================================================================
#==============================================================================

sub open_nios2_terminal_persistent
{
	system "clear";
	
	printf "Opening NIOS II Terminal (persistent)...\n";
	if ($board_cable_name eq "-")
	{
		system "nios2-terminal --verbose --persistent";
	}
	else
	{
		system "nios2-terminal --verbose --persistent --cable='$board_cable_name'";
	}
	
	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}

#==============================================================================
#==============================================================================

sub board_cable_set
{
	my $BOARD_CABLE_OK = Y;
	my $BOARD_CABLE_NAME = "";
	system "clear";
	
	do
	{
		printf "Please input board cable to be used : ";
		$BOARD_CABLE_OK = "Y";
		$BOARD_CABLE_NAME_IN = <STDIN>;
		chop ($BOARD_CABLE_NAME_IN);
		#$BOARD_CABLE_NAME_IN =~ tr/a-z/A-Z/;
		$BOARD_CABLE_NAME_LEN = length($BOARD_CABLE_NAME_IN);

		if ($BOARD_CABLE_NAME_LEN == 0)
		{
			printf "Not enter any board cable, please re-enter : ";
			$BOARD_CABLE_OK = "N";
		} 
		else
		{
			$BOARD_CABLE_NAME = $BOARD_CABLE_NAME_IN;
			
			# Set the new board cable name
			$board_cable_name = $BOARD_CABLE_NAME;
			
			printf "\n";
			printf "Cable settings changed!\n";
			printf "Programming options will use the selected cable to program the board flash.\n";
			printf "\n";
			printf "WARNING: Programming options will not work if the cable is wrong!\n";
			
		}

	}
	while ($BOARD_CABLE_OK ne "Y");
	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}

#==============================================================================
#==============================================================================

sub board_cable_clear
{	
	system "clear";
	
	$board_cable_name = "-";
	
	printf "Cable settings cleared!\n";
	printf "Programming options will use any available cable to program the board flash.\n";
	printf "\n";
	printf "WARNING: Programming options will not work if multiple cables are connected!\n";
		
	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}

#==============================================================================
#==============================================================================

sub board_cable_list
{
	system "clear";
	
	system "jtagconfig -n";
	
	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}

#==============================================================================
#==============================================================================

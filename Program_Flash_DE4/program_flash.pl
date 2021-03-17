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
#   V1.0 :| Eric Chen         :| 10/06/06  :| Initial Version
#   V1.1 :| Eric Chen         :| 10/08/20  :| Change Flash for one die
#   V1.3 :| Rodrigo Franca    :| 19/10/30  :| Added options for DE4-230 and DE4-530 boards
#   V1.4 :| Rodrigo Franca    :| 20/06/05  :| Removed cable option from flash programming
#   V1.5 :| Rodrigo Franca    :| 21/03/16  :| Added option to set cable for flash programming
# ============================================================================



my $MAC_ADDRESS_IN		  = "0007ED128000";
my $MAC_ADDRESS_OK		  = "Y";
my $FLASH_0_BASE		  = "0x08000000";
my $FLASH_0_END			  = "0x09FFFFFF";
my $FLASH_1_BASE		  = "0x0A000000";
my $FLASH_1_END			  = "0x0BFFFFFF";
my $flash_bup_SOF         = "de4_board_update_portal.sof";
my $flash_bup_de4_230_SOF = "de4_230_board_update_portal.sof";
my $flash_bup_de4_530_SOF = "de4_530_board_update_portal.sof";
my $mac_srec_file		  = "de4_mac_serial.srec";
my $hw_image_file		  = "de4_hw.flash";
my $sw_image_file		  = "de4_sw.flash";
my $pfl_bits_file		  = "de4_hw.map.flash";
my $zip_image_file		  = "rozipfs.flash";
my $board_cable_name	  = "-";


&init;
&menu;


sub	menu
{
	$SELECT = 100;
	until ($SELECT eq "D")# or $SELECT eq "0")
	{
		system "clear";
		printf "DE4 Development Kit Flash Program Tools.  ver : 1.5.0.0\n";
		printf "\n";
		printf "*************************   DE4-230 Board Menu   **************************\n";
		printf "\n";
		printf "  0) Program .sof and .elf to DE4-230 board flash (include pfl option bit)\n";
		printf "  1) Erase DE4-230 board flash\n";
		printf "  2) Program .sof file into the DE4-230 board flash\n";
		printf "  3) Program .elf file into the DE4-230 board flash\n";
#		printf "  -) Program web page (ZIP file) into the DE4-230 board flash\n";
#		printf "  -) Program Ethernet MAC address for DE4-230 board\n";
#		printf "  -) Program pfl option bit into the DE4-230 board flash\n";
#		printf "  -) Readme File for DE4-230 board\n";
		printf "\n";
		printf "*************************   DE4-530 Board Menu   **************************\n";
		printf "\n";
		printf "  4) Program .sof and .elf to DE4-530 board flash (include pfl option bit)\n";
		printf "  5) Erase DE4-530 board flash\n";
		printf "  6) Program .sof file into the DE4-530 board flash\n";
		printf "  7) Program .elf file into the DE4-530 board flash\n";
#		printf "  -) Program web page (ZIP file) into the DE4-530 board flash\n";
#		printf "  -) Program Ethernet MAC address for DE4-530 board\n";
#		printf "  -) Program pfl option bit into the DE4-530 board flash\n";
#		printf "  -) Readme File for DE4-530 board\n";
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

		if	(					 ($SELECT eq "1"))	{$flash_bup_SOF = $flash_bup_de4_230_SOF; &erase_flash;}			# erase flash
		if	(($SELECT eq "0") || ($SELECT eq "2"))	{$flash_bup_SOF = $flash_bup_de4_230_SOF; &program_sof;}
		if	(($SELECT eq "0") || ($SELECT eq "3"))	{$flash_bup_SOF = $flash_bup_de4_230_SOF; &program_elf;}
		if	(					 ($SELECT eq "5"))	{$flash_bup_SOF = $flash_bup_de4_530_SOF; &erase_flash;}			# erase flash
		if	(($SELECT eq "4") || ($SELECT eq "6"))	{$flash_bup_SOF = $flash_bup_de4_530_SOF; &program_sof;}
		if	(($SELECT eq "4") || ($SELECT eq "7"))	{$flash_bup_SOF = $flash_bup_de4_530_SOF; &program_elf;}
#		if	(					 ($SELECT eq "-"))	{&program_zip;}
#		if	(					 ($SELECT eq "-"))	{&program_mac;}
#		if	(					 ($SELECT eq "-"))	{&program_pfl;}
#		if  (					 ($SELECT eq "-"))	{
#														system("cat readme.txt");
#														printf "\nPress ENTER key to continuance... ";
#														$RESULT = <STDIN>;
#													} 
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
# +-------------------------
# | read_file(filename[,error_ref])
# |
# | returns the complete file contents
# |
# |
# |     in: filename -- name (path) of file to read
# |
# | return: one long string with the whole file, or
# |         empty string if no such file or empty file.
# |
# |         (use Perl's -e if you really really care whether
# |         the file was there...)
# |
sub read_file
{
  my ($filename,$error_out) = (@_);
  my $bunch;
  my $file_contents;
  my $did;

  # (return error if ref provided)

  if($error_out)
  {
    $$error_out = (-f $filename) ? 0 : -1;
  }

  # (read the whole file, if present. else "")

  if(open(FILE,$filename))
  {
    binmode FILE;    # Bite me, Windows! --dvb
    while(read(FILE,$bunch,32000))
    {
      $file_contents .= $bunch;
    }
    close FILE;
  }

  return $file_contents;
}
#==============================================================================
#==============================================================================
# -----------------------
# write_file(filename,contents)
#
# creates new file and writes entire
# file contents. Return "ok" if so,
# or "" if not.
#
# |
# |     in: filename -- name of file to create (or replace)
# |         contents -- string of all the bytes to put into file
# |
# | return: 0 for success, <0 for error
# |
sub write_file
{
  my ($filename,$contents) = (@_);

  my $did;

  #
  # If filename is "", print it to stdout
  # and that is all.
  #

  if($filename eq "")
  {
    print $contents;
    return "";
  }

  #
  # Delete existing file, if any.
  #

  unlink ($filename) if(-e $filename);

  $did = open(FILE,">$filename");
  if($did)
  {
    binmode FILE;    # Bite me, Windows! --dvb
    $did = print FILE $contents;
    close FILE;
    return $did ? 0 : -1;
  }

  return -1;
}
#==============================================================================
#==============================================================================
sub erase_flash
{

	if ($board_cable_name eq "-")
	{
		# Load board update portal file into FPGA.
		printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
		system "quartus_pgm -m jtag -o p\\\;$flash_bup_SOF";
		
		# Programming flash with the FPGA configuration.
		printf "\nErase flash, please wait a few minutes ...\n\n";
		system "nios2-flash-programmer --base=$FLASH_0_BASE --erase-all";
	}
	else
	{
		# Load board update portal file into FPGA.
		printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
		system "quartus_pgm -c '$board_cable_name' -m jtag -o p\\\;$flash_bup_SOF";
		
		# Programming flash with the FPGA configuration.
		printf "\nErase flash, please wait a few minutes ...\n\n";
		system "nios2-flash-programmer --base=$FLASH_0_BASE --cable='$board_cable_name' --erase-all";
	}

	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}
#==============================================================================
#==============================================================================
sub program_sof
{
	my $SOF_FILE_OK = Y;
	my $SOF_FILE_NAME = "";
	system "clear";
	
	do
	{
		printf "Please input .sof file name : ";
		$SOF_FILE_OK = "Y";
		$SOF_FILE_NAME_IN = <STDIN>;
		chop ($SOF_FILE_NAME_IN);
		$SOF_FILE_NAME_IN =~ tr/a-z/A-Z/;
		$SOF_FILE_NAME_LEN = length($SOF_FILE_NAME_IN);

		if ($SOF_FILE_NAME_LEN == 0)
		{
			printf "Not enter any filename, please re-enter : ";
			$SOF_FILE_OK = "N";
		} 
		else
		{
			$POS = index($SOF_FILE_NAME_IN,".");	# Find symbol "." Location

			if ($POS == -1)							# if false(-1), insert ".sof"
			{
				$SOF_FILE_NAME = $SOF_FILE_NAME_IN . ".SOF";
			}
			elsif ($SOF_FILE_NAME_IN =~ /.SOF/)
			{
				$SOF_FILE_NAME = $SOF_FILE_NAME_IN;
			}
			else
			{
				printf "Input is not .sof the file name, please re-enter : ";
				$SOF_FILE_OK = "N";
			}
		}

		if (-e $SOF_FILE_NAME)
		{
			# Delete hardware image file (.flash), if the file is exists.
			unlink $hw_image_file if (-e $hw_image_file);

			# Creating .flash file for the FPGA configuration.
			printf "\nStart file conversion, please wait a few minutes ...\n\n";
#			printf "$ENV{QUARTUS_ROOTDIR}\n";
			if ($ENV{QUARTUS_ROOTDIR} =~ /\/90\//)
			{
#				printf "for Quartus 9.0 version\n";
				system "sof2flash --offset=0x20000 --input=$SOF_FILE_NAME --output=$hw_image_file --optionbit=0x18000";
			}
			else
			{
#				printf "After the Quartus 9.1 version\n";
				system "sof2flash --offset=0x20000 --input=$SOF_FILE_NAME --output=$hw_image_file --pfl --programmingmode=FPP --optionbit=0x18000";
				&pfl_option_bit_proc;
			}

			if (-e $hw_image_file)
			{
				if ($board_cable_name eq "-")
				{
					# Load board update portal file into FPGA.
					printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
					system "quartus_pgm -m jtag -o p\\\;$flash_bup_SOF";

					# Programming flash with the FPGA configuration.
					printf "\nProgram flash, please wait a few minutes ...\n\n";
					system "nios2-flash-programmer --base=$FLASH_0_BASE $hw_image_file";
					system "nios2-flash-programmer --base=$FLASH_0_BASE $pfl_bits_file";
				}
				else
				{
					# Load board update portal file into FPGA.
					printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
					system "quartus_pgm -c '$board_cable_name' -m jtag -o p\\\;$flash_bup_SOF";

					# Programming flash with the FPGA configuration.
					printf "\nProgram flash, please wait a few minutes ...\n\n";
					system "nios2-flash-programmer --base=$FLASH_0_BASE --cable='$board_cable_name' $hw_image_file";
					system "nios2-flash-programmer --base=$FLASH_0_BASE --cable='$board_cable_name' $pfl_bits_file";
				}
			}
			else
			{
				printf "\n";
				printf "Can't created the $hw_image_file File, Please check error message.\n";
				$SOF_FILE_OK = "Y";
			}
		}
		else
		{
			printf "\n";
			printf "Files do not exist,please make sure.\n";
			$SOF_FILE_OK = "N";
		}
	}
	while ($SOF_FILE_OK ne "Y");
	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}

#==============================================================================
#==============================================================================
sub program_elf
{
	my $ELF_FILE_OK = Y;
	my $ELF_FILE_NAME = "";
	my $KIT_ROOTDIR;

	$KIT_ROOTDIR = $ENV{SOPC_KIT_NIOS2};
	$KIT_ROOTDIR =~ s/nios2eds//g;

	system "clear";
	do
	{
		printf "Please input .ELF file name : ";
		$ELF_FILE_OK = "Y";
		$ELF_FILE_NAME_IN = <STDIN>;
		chop ($ELF_FILE_NAME_IN);
		$ELF_FILE_NAME_IN =~ tr/a-z/A-Z/;
		$ELF_FILE_NAME_LEN = length($ELF_FILE_NAME_IN);

		if ($ELF_FILE_NAME_LEN == 0)
		{
			printf "Not enter any filename, please re-enter : ";
			$ELF_FILE_OK = "N";
		} 
		else
		{
			$POS = index($ELF_FILE_NAME_IN,".");	# Find symbol "." Location

			if ($POS == -1)							# if false(-1), insert ".ELF"
			{
				$ELF_FILE_NAME = $ELF_FILE_NAME_IN . ".ELF";
			}
			elsif ($ELF_FILE_NAME_IN =~ /.ELF/)
			{
				$ELF_FILE_NAME = $ELF_FILE_NAME_IN;
			}
			else
			{
				printf "Input is not .elf the file name, please re-enter : ";
				$ELF_FILE_OK = "N";
			}
		}

		if (-e $ELF_FILE_NAME)
		{
			# Delete software image file (.flash), if the file is exists.
			unlink $sw_image_file if (-e $sw_image_file);

#			printf "$ENV{QUARTUS_ROOTDIR}\n";
#			printf "$ENV{SOPC_KIT_NIOS2}\n";
			# Creating .flash file for the FPGA configuration.
			printf "\nStart file conversion, please wait a few minutes ...\n\n";

			if ($ENV{QUARTUS_ROOTDIR} =~ /\/90\// or $ENV{QUARTUS_ROOTDIR} =~ /\/91\//)
			{
				system "elf2flash --base=$FLASH_0_BASE --end=0xbffffff --reset=0xa020000 --input=$ELF_FILE_NAME --output=$sw_image_file --boot=\"$KIT_ROOTDIR/ip/altera/nios2_ip/altera_nios2/boot_loader_cfi.srec\"";
			}
			else
			{
#				print "Support converting all versions after Quartus 11.1\n";
				system "elf2flash --base=$FLASH_0_BASE --end=0xbffffff --reset=0xa020000 --input=$ELF_FILE_NAME --output=$sw_image_file --boot=\"$KIT_ROOTDIR/nios2eds/components/altera_nios2/boot_loader_cfi.srec\"";
			}

			if (-e $sw_image_file)
			{
				if ($board_cable_name eq "-")
				{
					# Load board update portal file into FPGA.
					printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
					system "quartus_pgm -m jtag -o p\\\;$flash_bup_SOF";

					# Programming flash with the FPGA configuration.
					printf "\nProgram flash, please wait a few minutes ...\n\n";
					system "nios2-flash-programmer --base=$FLASH_0_BASE $sw_image_file";
				}
				else
				{
					# Load board update portal file into FPGA.
					printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
					system "quartus_pgm -c '$board_cable_name' -m jtag -o p\\\;$flash_bup_SOF";

					# Programming flash with the FPGA configuration.
					printf "\nProgram flash, please wait a few minutes ...\n\n";
					system "nios2-flash-programmer --base=$FLASH_0_BASE --cable='$board_cable_name' $sw_image_file";
				}

			}
			else
			{
				printf "\n";
				printf "Can't created the $sw_image_file File, Please check error message.\n";
				$ELF_FILE_OK = "Y";
			}
		}
		else
		{
			printf "\n";
			printf "Files do not exist,please make sure.\n";
			$ELF_FILE_OK = "N";
		}
	}
	while ($ELF_FILE_OK ne "Y");
	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}
#==============================================================================
#==============================================================================
sub program_pfl
{
	&pfl_option_bit_proc;

	if (-e $pfl_bits_file)
	{
		if ($board_cable_name eq "-")
		{
			printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
			system "quartus_pgm -m jtag -o p\\\;$flash_bup_SOF";
		
			printf "\nProgram flash, please wait a few minutes ...\n\n";
			system "nios2-flash-programmer --base=$FLASH_0_BASE $pfl_bits_file";
		}
		else
		{
			printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
			system "quartus_pgm -c '$board_cable_name' -m jtag -o p\\\;$flash_bup_SOF";
		
			printf "\nProgram flash, please wait a few minutes ...\n\n";
			system "nios2-flash-programmer --base=$FLASH_0_BASE --cable='$board_cable_name' $pfl_bits_file";
		}
		
	}
	else
	{
		printf "Can't conversion the $pfl_bits_file File, Please check error message.\n";
		printf "\nPress ENTER key to continuance... ";
		$RESULT = <STDIN>;
	}
}
#==============================================================================
sub pfl_option_bit_proc
{

	my $pfl_end_string = "S21501808003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6";

	if (-e $pfl_bits_file)
	{
		my $pfl_bit_string = read_file($pfl_bits_file);
		#  printf "pfl option bit file dump \n $pfl_bit_string\n\n"
		if ($pfl_bit_string =~ /$pfl_end_string/)
		{
			printf "File is ok, no change the file contents.\n";
		}
		else
		{
			write_file($pfl_bits_file,$pfl_bit_string . $pfl_end_string . "\n");
			printf "Modify de4_hw.map.flash file ok.\n";
		}
	}
	else
	{
		printf "File does not exist, please be .sof file conversion.\n";
	}
}
#==============================================================================
#==============================================================================
sub program_zip
{
	my $ZIP_FILE_OK = Y;
	my $ZIP_FILE_NAME = "";
	system "clear";
	do
	{
		printf "Please input .zip file name : ";
		$ZIP_FILE_OK = "Y";
		$ZIP_FILE_NAME_IN = <STDIN>;
		chop ($ZIP_FILE_NAME_IN);
		$ZIP_FILE_NAME_IN =~ tr/a-z/A-Z/;
		$ZIP_FILE_NAME_LEN = length($ZIP_FILE_NAME_IN);

		if ($ZIP_FILE_NAME_LEN == 0)
		{
			printf "Not enter any filename, please re-enter : ";
			$ZIP_FILE_OK = "N";
		} 
		else
		{
			$POS = index($ZIP_FILE_NAME_IN,".");	# Find symbol "." Location

			if ($POS == -1)							# if false(-1), insert ".ZIP"
			{
				$ZIP_FILE_NAME = $ZIP_FILE_NAME_IN . ".ZIP";
			}
			elsif ($ZIP_FILE_NAME_IN =~ /.ZIP/)
			{
				$ZIP_FILE_NAME = $ZIP_FILE_NAME_IN;
			}
			else
			{
				printf "Input is not .zip the file name, please re-enter : ";
				$ZIP_FILE_OK = "N";
			}
		}

		if (-e $ZIP_FILE_NAME)
		{
			# Delete ZIP image file (.flash), if the file is exists.
			unlink $zip_image_file if (-e $zip_image_file);

			# Creating .flash file for the FPGA configuration.
			printf "\nStart file conversion, please wait a few minutes ...\n\n";
			system "bin2flash --base=$FLASH_0_BASE --location=0x1820000 --input=$ZIP_FILE_NAME --output=$zip_image_file";

			if (-e $zip_image_file)
			{
				if ($board_cable_name eq "-")
				{
					# Load board update portal file into FPGA.
					printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
					system "quartus_pgm -m jtag -o p\\\;$flash_bup_SOF";

					# Programming flash with the FPGA configuration.
					printf "\nProgram flash, please wait a few minutes ...\n\n";
					system "nios2-flash-programmer --base=$FLASH_0_BASE $zip_image_file";
				}
				else
				{
					# Load board update portal file into FPGA.
					printf "\nLoad board update portal file into FPGA, please wait ...\n\n";
					system "quartus_pgm -c '$board_cable_name' -m jtag -o p\\\;$flash_bup_SOF";

					# Programming flash with the FPGA configuration.
					printf "\nProgram flash, please wait a few minutes ...\n\n";
					system "nios2-flash-programmer --base=$FLASH_0_BASE --cable='$board_cable_name' $zip_image_file";
				}
				
			}
			else
			{
				printf "\n";
				printf "Can't created the $zip_image_file File, Please check error message.\n";
				$ZIP_FILE_OK = "Y";
			}
		}
		else
		{
			printf "\n";
			printf "Files do not exist,please make sure.\n";
			$ZIP_FILE_OK = "N";
		}
	}
	while ($ZIP_FILE_OK ne "Y");
	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}
#==============================================================================
#==============================================================================
sub program_mac
{
	system "clear";
	printf "Please enter the network card address (MAC Address) : ";
	do
	{
		$MAC_ADDRESS_OK = "Y";
		$MAC_ADDRESS_IN = <STDIN>;
		chop ($MAC_ADDRESS_IN);
		$MAC_ADDRESS_IN =~ tr/a-z/A-Z/;
		$MAC_ADDRESS_LEN = length($MAC_ADDRESS_IN);

		if ($MAC_ADDRESS_LEN == 0)
		{
			printf "Not enter a network card address, please re-enter the network card address : ";
			$MAC_ADDRESS_OK = "N";
		} 
		elsif ($MAC_ADDRESS_LEN != 12)
		{
			printf "Enter the network address may be incorrect, please re-enter the network card address : ";
			$MAC_ADDRESS_OK = "N";
		}
		else
		{
			{
				for ($k=0 ; $k < $MAC_ADDRESS_LEN ; $k++)
				{
					$ADDR_CHAR = substr($MAC_ADDRESS_IN,$k,1);
					$ADDR_CHAR_ASC = ord($ADDR_CHAR);
##					printf "k=$k , $ADDR_CHAR 的 ASCII %X\n",$ADDR_CHAR_ASC;
					if (!(($ADDR_CHAR_ASC >= 0x30 && $ADDR_CHAR_ASC <= 0x39) 
					 || ($ADDR_CHAR_ASC >= 0x41 && $ADDR_CHAR_ASC <= 0x46)))
					{
						printf "Enter the network address is incorrect, please re-enter the network card address : ";
						$MAC_ADDRESS_OK = "N";
					}
					last if ($MAC_ADDRESS_OK ne "Y");
				}
			}
		}
	}
	while ($MAC_ADDRESS_OK ne "Y");
	
	&generated_mac_address;
	printf "Load board update portal file into FPGA, please wait ...\n";
	if ($board_cable_name eq "-")
	{
		system "quartus_pgm -m jtag -o p\\\;$flash_bup_SOF";
		system "nios2-flash-programmer --base=$FLASH_0_BASE $mac_srec_file";
	}
	else
	{
		system "quartus_pgm -c '$board_cable_name' -m jtag -o p\\\;$flash_bup_SOF";
		system "nios2-flash-programmer --base=$FLASH_0_BASE --cable='$board_cable_name' $mac_srec_file";
	}

	printf "\nPress ENTER key to continuance... ";
	$RESULT = <STDIN>;
}
#==============================================================================
sub generated_mac_address
{
  my $board_ip_address	= "0.0.0.0";
  my $oci_base			= "0x920800";
  my $flash_base		= "0x08000000";		# Should match NIOS system base address (except for multi die flash)
  my $test_status_log	= "test.log";		# Test status log used to determine if .elf files executed succesfully

  my $DHCP_stop_file	= "stop_DHCP.txt";	#this file contains a ! which will stop the board from looking for a DHCP file
  my $DHCP_start_file	= "start_DHCP.txt";	#this file contains a ! which will stop the board from looking for a DHCP file


  # The IP, gateway, and subnet mask address below are used as a last resort if
  # if no network settings can be found, and DHCP (if enabled) fails. You can
  # edit these as a quick-and-dirty way of changing network settings if desired.
  #
  # Default fall-back address:
  #           IP: 192.168.1.234
  #      Gateway: 192.168.1.255
  #  Subnet Mask: 255.255.255.0
    
  my $IPADDR0  = "C0";	# 192 in decimal
  my $IPADDR1  = "A8";	# 168
  my $IPADDR2  = "01";	# 1
  my $IPADDR3  = "EA";	# 234
    
  my $GWADDR0  = "C0";	# 192
  my $GWADDR1  = "A8";	# 168
  my $GWADDR2  = "01";	# 1
  my $GWADDR3  = "FF";	# 255
    
  my $MSKADDR0 = "FF";	# 255
  my $MSKADDR1 = "FF";	# 255
  my $MSKADDR2 = "FF";	# 255
  my $MSKADDR3 = "00";	# 0

  # Update the serializing files. sure we could skip an address on accident
  # by quitting early. ha ha ha. that would be funny. ha ha ha.

    # ----- change by Eric 2008/9/16
  my $mac_serial_string = $MAC_ADDRESS_IN;
  my @mac_serial_bytes = ("00", "00", "00", "00", "00", "00");	# = split(/[:\n]/,$mac_serial_string,6);

	# Transform $mac_serial_string to @mac_serial_bytes (6 byte MAC Address)
  for($i = 0; $i < 12; $i+=2)
	{
		$mac_serial_bytes[$i/2] = substr $mac_serial_string,$i,2;
##		printf "MAC Serial Byte $i = $mac_serial_bytes[i]\n";
	}
  printf "[INF] MAC Serial string is $mac_serial_string\n";
  printf "[INF] MAC Serial Bytes @mac_serial_bytes\n";

  # |
  # | create an elf of the mac address for programming
  # |

  #turned the last word to 00 instead of ff ff attempting to turn DHCP off
  my @network_settings_dhcp_off = ("FF", "FF", $IPADDR0, $IPADDR1, $IPADDR2, $IPADDR3, "FF", "FF", "FF", "FF", $MSKADDR0,
  $MSKADDR1, $MSKADDR2, $MSKADDR3, $GWADDR0, $GWADDR1, $GWADDR2, $GWADDR3, "00", "00", "FF", "FF"); 

  #The second to last word is turned back to FF FF in order to turn DHCP back on 
  my @network_settings_dhcp_on = ("FF", "FF", $IPADDR0, $IPADDR1, $IPADDR2, $IPADDR3, "FF", "FF", "FF", "FF", $MSKADDR0,
  $MSKADDR1, $MSKADDR2, $MSKADDR3, $GWADDR0, $GWADDR1, $GWADDR2, $GWADDR3, "FF", "FF", "FF", "FF"); 
 
  # append the mac address string to the header
  # 00:07:ED:0F:00:00
  # ORIGINAL:
  my $mac_srec_string = "S32500008000FE5A0000" . $mac_serial_string . join("",@network_settings_dhcp_on); 

  # S3 = 4 byte address
  # 25 = 25h character pairs of data
  # 00008000 = Address					--> 00008000 = ethernet option bits (Dual die Intel Flash)
  # FE5A0000 = Start of data?

  # remove characters we don't like
  $mac_srec_string =~ s/://g;		#除去字串內的 : 號
  $mac_srec_string =~ s/\n\s//g;	#除去字串內的換行符號 \n

  # compute the checksum, starting with the header bytes
##  my $mac_flash_sum = 0x25 + 0x01 + 0xFC + 0xFE + 0x5A;
  my $mac_flash_sum = 0x25 + 0x80 + 0xFE + 0x5A;

  # then each of the bytes in the mac address
  foreach my $byte (@mac_serial_bytes)
  {
    $mac_flash_sum += hex($byte);
  }

  foreach my $byte (@network_settings_dhcp_on)
  {
    $mac_flash_sum += hex($byte);
  } 

  # invert the sum, and lop off all but the last byte
  $mac_flash_sum = ~$mac_flash_sum % 256;

  # and append the sum to the string
  $mac_srec_string .= sprintf("%02x",$mac_flash_sum);

  # finally write the mac address SREC to a file
  write_file($mac_srec_file,$mac_srec_string . "\n");

  printf "\nMac SREC String is\n$mac_srec_string\n";

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

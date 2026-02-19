// (C) 2001-2011 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/11.1sp1/ip/merlin/altera_tristate_conduit_bridge/altera_tristate_conduit_bridge.sv.terp#1 $
// $Revision: #1 $
// $Date: 2011/09/26 $
// $Author: max $

//Defined Terp Parameters


			    

`timescale 1 ns / 1 ns
  				      
module DE4_SOPC_flash_tristate_bridge_bridge_0 (
     input  logic clk
    ,input  logic reset
    ,input  logic request
    ,output logic grant
    ,input  logic[ 24 :0 ] tcs_flash_tristate_bridge_address
    ,output  wire [ 24 :0 ] flash_tristate_bridge_address
    ,input  logic[ 0 :0 ] tcs_flash_tristate_bridge_writen
    ,output  wire [ 0 :0 ] flash_tristate_bridge_writen
    ,output logic[ 15 :0 ] tcs_flash_tristate_bridge_data_in
    ,input  logic[ 15 :0 ] tcs_flash_tristate_bridge_data
    ,input  logic tcs_flash_tristate_bridge_data_outen
    ,inout  wire [ 15 :0 ]  flash_tristate_bridge_data
    ,input  logic[ 0 :0 ] tcs_select_n_to_the_ext_flash
    ,output  wire [ 0 :0 ] select_n_to_the_ext_flash
    ,input  logic[ 0 :0 ] tcs_flash_tristate_bridge_readn
    ,output  wire [ 0 :0 ] flash_tristate_bridge_readn
		     
   );
   reg grant_reg;
   assign grant = grant_reg;
   
   always@(posedge clk) begin
      if(reset)
	grant_reg <= 0;
      else
	grant_reg <= request;      
   end
   


 // ** Output Pin flash_tristate_bridge_address 
 
    reg                       flash_tristate_bridge_addressen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   flash_tristate_bridge_addressen_reg <= 'b0;
	 end
	 else begin
	   flash_tristate_bridge_addressen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 24 : 0 ] flash_tristate_bridge_address_reg;   

     always@(posedge clk) begin
	 flash_tristate_bridge_address_reg   <= tcs_flash_tristate_bridge_address[ 24 : 0 ];
      end
          
 
    assign 	flash_tristate_bridge_address[ 24 : 0 ] = flash_tristate_bridge_addressen_reg ? flash_tristate_bridge_address_reg : 'z ;
        


 // ** Output Pin flash_tristate_bridge_writen 
 
    reg                       flash_tristate_bridge_writenen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   flash_tristate_bridge_writenen_reg <= 'b0;
	 end
	 else begin
	   flash_tristate_bridge_writenen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] flash_tristate_bridge_writen_reg;   

     always@(posedge clk) begin
	 flash_tristate_bridge_writen_reg   <= tcs_flash_tristate_bridge_writen[ 0 : 0 ];
      end
          
 
    assign 	flash_tristate_bridge_writen[ 0 : 0 ] = flash_tristate_bridge_writenen_reg ? flash_tristate_bridge_writen_reg : 'z ;
        


 // ** Bidirectional Pin flash_tristate_bridge_data 
   
    reg                       flash_tristate_bridge_data_outen_reg;
  
    always@(posedge clk) begin
	 flash_tristate_bridge_data_outen_reg <= tcs_flash_tristate_bridge_data_outen;
     end
  
  
    reg [ 15 : 0 ] flash_tristate_bridge_data_reg;   

     always@(posedge clk) begin
	 flash_tristate_bridge_data_reg   <= tcs_flash_tristate_bridge_data[ 15 : 0 ];
      end
         
  
    assign 	flash_tristate_bridge_data[ 15 : 0 ] = flash_tristate_bridge_data_outen_reg ? flash_tristate_bridge_data_reg : 'z ;
       
  
    reg [ 15 : 0 ] 	flash_tristate_bridge_data_in_reg;
								    
    always@(posedge clk) begin
	 flash_tristate_bridge_data_in_reg <= flash_tristate_bridge_data[ 15 : 0 ];
    end
    
  
    assign      tcs_flash_tristate_bridge_data_in[ 15 : 0 ] = flash_tristate_bridge_data_in_reg[ 15 : 0 ];
        


 // ** Output Pin select_n_to_the_ext_flash 
 
    reg                       select_n_to_the_ext_flashen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   select_n_to_the_ext_flashen_reg <= 'b0;
	 end
	 else begin
	   select_n_to_the_ext_flashen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] select_n_to_the_ext_flash_reg;   

     always@(posedge clk) begin
	 select_n_to_the_ext_flash_reg   <= tcs_select_n_to_the_ext_flash[ 0 : 0 ];
      end
          
 
    assign 	select_n_to_the_ext_flash[ 0 : 0 ] = select_n_to_the_ext_flashen_reg ? select_n_to_the_ext_flash_reg : 'z ;
        


 // ** Output Pin flash_tristate_bridge_readn 
 
    reg                       flash_tristate_bridge_readnen_reg;     
  
    always@(posedge clk) begin
	 if( reset ) begin
	   flash_tristate_bridge_readnen_reg <= 'b0;
	 end
	 else begin
	   flash_tristate_bridge_readnen_reg <= 'b1;
	 end
     end		     
   
 
    reg [ 0 : 0 ] flash_tristate_bridge_readn_reg;   

     always@(posedge clk) begin
	 flash_tristate_bridge_readn_reg   <= tcs_flash_tristate_bridge_readn[ 0 : 0 ];
      end
          
 
    assign 	flash_tristate_bridge_readn[ 0 : 0 ] = flash_tristate_bridge_readnen_reg ? flash_tristate_bridge_readn_reg : 'z ;
        

endmodule



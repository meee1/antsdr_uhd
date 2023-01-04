//------------------------------------------------------------------------------
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version : 3.6
//  \   \         Application : 7 Series FPGAs Transceivers Wizard 
//  /   /         Filename : one_gig_eth_pcs_pma_gtwizard_init.v
// /___/   /\      
// \   \  /  \ 
//  \___\/\___\
//
//  Description : This module instantiates the modules required for
//                reset and initialisation of the Transceiver
//
// Module GTWIZARD_init
// Generated by Xilinx 7 Series FPGAs Transceivers Wizard
// 
// 
// (c) Copyright 2010-2012 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 


`timescale 1ns / 1ps
`define DLY #1

//***********************************Entity Declaration************************
(* DowngradeIPIdentifiedWarnings="yes" *)
module one_gig_eth_pcs_pma_GTWIZARD_init #
(
    parameter EXAMPLE_SIM_GTRESET_SPEEDUP            = "TRUE",     // Simulation setting for GT SecureIP model
    parameter EXAMPLE_SIMULATION                     =  0,         // Set to 1 for simulation
    parameter STABLE_CLOCK_PERIOD                    = 10,         //Period of the stable clock driving this state-machine, unit is [ns]
    parameter EXAMPLE_USE_CHIPSCOPE                  =  0          // Set to 1 to use Chipscope to drive resets

)
(
output          mmcm_reset,
output          recclk_mmcm_reset,
input           sysclk_in,
input           soft_reset_tx_in,
input           soft_reset_rx_in,
input           dont_reset_on_data_error_in,
output          gt0_tx_fsm_reset_done_out,
output          gt0_rx_fsm_reset_done_out,
input           gt0_data_valid_in,
    //_________________________________________________________________________
    //GT0  (X1Y0)
    //____________________________CHANNEL PORTS________________________________
    //------------------------------- CPLL Ports -------------------------------
    output          gt0_cpllfbclklost_out,
    output          gt0_cplllock_out,
    input           gt0_cplllockdetclk_in,
    input           gt0_cpllreset_in,
    //------------------------ Channel - Clocking Ports ------------------------
    input           gt0_gtrefclk0_in,
    input           gt0_gtrefclk0_bufg_in,
    //-------------------------- Channel - DRP Ports  --------------------------
    input   [8:0]   gt0_drpaddr_in,
    input           gt0_drpclk_in,
    input   [15:0]  gt0_drpdi_in,
    output  [15:0]  gt0_drpdo_out,
    input           gt0_drpen_in,
    output          gt0_drprdy_out,
    input           gt0_drpwe_in,


    //----------------------------- Loopback Ports -----------------------------
    input   [2:0]   gt0_loopback_in,
    //---------------------------- Power-Down Ports ----------------------------
    input   [1:0]   gt0_rxpd_in,
    input   [1:0]   gt0_txpd_in,
    //------------------- RX Initialization and Reset Ports --------------------
    input           gt0_eyescanreset_in,
    input           gt0_rxuserrdy_in,
    //------------------------ RX Margin Analysis Ports ------------------------
    output          gt0_eyescandataerror_out,
    input           gt0_eyescantrigger_in,
    //----------------------- Receive Ports - CDR Ports ------------------------
    input           gt0_rxcdrhold_in,
    //----------------- receive ports - clock correction ports -----------------
    output  [1:0]   gt0_rxclkcorcnt_out,
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    input           gt0_rxusrclk_in,
    input           gt0_rxusrclk2_in,
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    output  [15:0]  gt0_rxdata_out,
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    output          gt0_rxprbserr_out,
    input   [2:0]   gt0_rxprbssel_in,
    //----------------- Receive Ports - Pattern Checker ports ------------------
    input           gt0_rxprbscntreset_in,
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    output  [1:0]   gt0_rxdisperr_out,
    output  [1:0]   gt0_rxnotintable_out,
    //------------------------- Receive Ports - RX AFE -------------------------
    input           gt0_gtxrxp_in,
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    input           gt0_gtxrxn_in,
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    input           gt0_rxbufreset_in,
    output  [2:0]   gt0_rxbufstatus_out,
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    output          gt0_rxbyteisaligned_out,
    output          gt0_rxbyterealign_out,
    output          gt0_rxcommadet_out,
    input           gt0_rxmcommaalignen_in,
    input           gt0_rxpcommaalignen_in,
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    input           gt0_rxdfeagcovrden_in,
    input           gt0_rxdfelpmreset_in,
    output  [6:0]   gt0_rxmonitorout_out,
    input   [1:0]   gt0_rxmonitorsel_in,
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    output          gt0_rxoutclk_out,
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    input           gt0_gtrxreset_in,
    input           gt0_rxpmareset_in,
    //---------------- Receive Ports - RX Margin Analysis ports ----------------
    input           gt0_rxlpmen_in,
    //--------------- Receive Ports - RX Polarity Control Ports ----------------
    input           gt0_rxpolarity_in,
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    output  [1:0]   gt0_rxchariscomma_out,
    output  [1:0]   gt0_rxcharisk_out,
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    output          gt0_rxresetdone_out,
    //---------------------- TX Configurable Driver Ports ----------------------
    input   [4:0]   gt0_txpostcursor_in,
    input   [4:0]   gt0_txprecursor_in,
    //------------------- TX Initialization and Reset Ports --------------------
    input           gt0_gttxreset_in,
    input           gt0_txuserrdy_in,
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    input   [1:0]   gt0_txchardispmode_in,
    input   [1:0]   gt0_txchardispval_in,
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    input           gt0_txusrclk_in,
    input           gt0_txusrclk2_in,
    //------------------- Transmit Ports - PCI Express Ports -------------------
    input           gt0_txelecidle_in,
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    input           gt0_txprbsforceerr_in,
    //-------------------- Transmit Ports - TX Buffer Ports --------------------
    output  [1:0]   gt0_txbufstatus_out,
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    input   [3:0]   gt0_txdiffctrl_in,
    input           gt0_txinhibit_in,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [15:0]  gt0_txdata_in,
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    output          gt0_gtxtxn_out,
    output          gt0_gtxtxp_out,
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    output          gt0_txoutclk_out,
    output          gt0_txoutclkfabric_out,
    output          gt0_txoutclkpcs_out,
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    input   [1:0]   gt0_txcharisk_in,
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    output          gt0_txresetdone_out,
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    input           gt0_txpolarity_in,
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    input   [2:0]   gt0_txprbssel_in,

    input            gt0_txpmareset_in      ,
    input            gt0_txpcsreset_in      ,
    input            gt0_rxpcsreset_in      ,
    output [7:0]    gt0_dmonitorout_out    ,
    //____________________________COMMON PORTS________________________________
    input      gt0_qplloutclk_in,
    input      gt0_qplloutrefclk_in

);

//***********************************Parameter Declarations********************

    //Typical CDRLOCK Time is 50,000UI, as per DS183
    localparam RX_CDRLOCK_TIME      = (EXAMPLE_SIMULATION == 1) ? 1000 : 50000/1.25;
       
    integer   WAIT_TIME_CDRLOCK    = RX_CDRLOCK_TIME / STABLE_CLOCK_PERIOD;      

  
//-------------------------- GT Wrapper Wires ------------------------------
    wire           gt0_cpllreset_i;
    wire           gt0_cpllreset_t;
    wire           gt0_cpllrefclklost_i;
    wire           gt0_cplllock_i;
    wire           gt0_txresetdone_i;
    wire           gt0_rxresetdone_i;
    wire           gt0_gttxreset_i;
    wire           gt0_gttxreset_t;
    wire           gt0_gtrxreset_i;
    wire           gt0_gtrxreset_t;
    wire           gt0_txpcsreset_i;
    wire           gt0_rxpcsreset_i;
    wire           gt0_txpmareset_i;
    wire           gt0_rxdfelpmreset_i;
    wire           gt0_txuserrdy_i;
    wire           gt0_txuserrdy_t;
    wire           gt0_rxuserrdy_i;
    wire           gt0_rxuserrdy_t;

    wire           gt0_rxdfeagchold_i;
    wire           gt0_rxdfelfhold_i;
    wire           gt0_rxlpmlfhold_i;
    wire           gt0_rxlpmhfhold_i;



    wire   [8:0]   gt0_drpaddr_i;
    wire   [15:0]  gt0_drpdi_i;
    wire   [15:0]  gt0_drpdo_o;
    wire           gt0_drpen_i;
    wire           gt0_drpwe_i;
    wire           gt0_drprdy_o;

    wire   [8:0]   gt0_drpaddr_int;
    wire   [15:0]  gt0_drpdi_int;
    wire   [15:0]  gt0_drpdo_int;
    wire           gt0_drpen_int;
    wire           gt0_drpwe_int;
    wire           gt0_drprdy_int;
    


    wire           gt0_qpllreset_i;
    wire           gt0_qpllreset_t;
    wire           gt0_qpllrefclklost_i;
    wire           gt0_qplllock_i;
//------------------------------- Global Signals -----------------------------
    wire          tied_to_ground_i;
    wire          tied_to_vcc_i;

    wire           gt0_txoutclk_i;
    wire           gt0_rxoutclk_i;
    wire           gt0_recclk_stable_i;
    reg            gt0_rx_cdrlocked;
    integer  gt0_rx_cdrlock_counter= 0;






    reg              rx_cdrlocked;

    wire           gt0_gttxreset_gt;
    wire           gt0_gtrxreset_gt;

//**************************** Main Body of Code *******************************
    //  Static signal Assigments
    assign  tied_to_ground_i                     =  1'b0;
    assign  tied_to_vcc_i                        =  1'b1;
    assign  gt0_gttxreset_gt                     =  gt0_gttxreset_t || gt0_gttxreset_in;
    assign  gt0_gtrxreset_gt                     =  gt0_gtrxreset_t || gt0_gtrxreset_in;

//    ----------------------------- The GT Wrapper -----------------------------
    
    // Use the instantiation template in the example directory to add the GT wrapper to your design.
    // In this example, the wrapper is wired up for basic operation with a frame generator and frame 
    // checker. The GTs will reset, then attempt to align and transmit data. If channel bonding is 
    // enabled, bonding should occur after alignment.


    one_gig_eth_pcs_pma_GTWIZARD_multi_gt #
    (
        .WRAPPER_SIM_GTRESET_SPEEDUP    (EXAMPLE_SIM_GTRESET_SPEEDUP)
    )
    gtwizard_i
    (
        .gt0_rxclkcorcnt_out            (gt0_rxclkcorcnt_out),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .gt0_rxusrclk_in                (gt0_txusrclk_in),
        .gt0_rxusrclk2_in               (gt0_txusrclk_in),
        .gt0_gtrxreset_in               (gt0_gtrxreset_gt),
        .gt0_gttxreset_in               (gt0_gttxreset_gt),
  
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT0  (X1Y0)

        //------------------------------- CPLL Ports -------------------------------
        .gt0_cpllfbclklost_out          (gt0_cpllfbclklost_out),
        .gt0_cplllock_out               (gt0_cplllock_i),
        .gt0_cplllockdetclk_in          (gt0_cplllockdetclk_in),
        .gt0_cpllrefclklost_out         (gt0_cpllrefclklost_i),
        .gt0_cpllreset_in               (gt0_cpllreset_i),
        //------------------------ Channel - Clocking Ports ------------------------
        .gt0_gtrefclk0_in               (gt0_gtrefclk0_in),
        .gt0_gtrefclk0_bufg_in          (gt0_gtrefclk0_bufg_in),
        //-------------------------- Channel - DRP Ports  --------------------------
        .gt0_drpaddr_in                 (gt0_drpaddr_in),
        .gt0_drpclk_in                  (gt0_drpclk_in),
        .gt0_drpdi_in                   (gt0_drpdi_in),
        .gt0_drpdo_out                  (gt0_drpdo_out),
        .gt0_drpen_in                   (gt0_drpen_in),
        .gt0_drprdy_out                 (gt0_drprdy_out),
        .gt0_drpwe_in                   (gt0_drpwe_in),
        .gt0_dmonitorout_out                (gt0_dmonitorout_out),
        //----------------------------- Loopback Ports -----------------------------
        .gt0_loopback_in                (gt0_loopback_in),
        //---------------------------- Power-Down Ports ----------------------------
        .gt0_rxpd_in                    (gt0_rxpd_in),
        .gt0_txpd_in                    (gt0_txpd_in),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt0_eyescanreset_in            (gt0_eyescanreset_in),
        .gt0_rxuserrdy_in               (gt0_rxuserrdy_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt0_eyescandataerror_out       (gt0_eyescandataerror_out),
        .gt0_eyescantrigger_in          (gt0_eyescantrigger_in),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .gt0_rxcdrhold_in               (gt0_rxcdrhold_in),// input wire  gt0_rxcdrhold_in
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt0_rxdata_out                 (gt0_rxdata_out),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt0_rxprbserr_out              (gt0_rxprbserr_out),
        .gt0_rxprbssel_in               (gt0_rxprbssel_in),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt0_rxprbscntreset_in          (gt0_rxprbscntreset_in),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt0_rxdisperr_out              (gt0_rxdisperr_out),
        .gt0_rxnotintable_out           (gt0_rxnotintable_out),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt0_gtxrxp_in                  (gt0_gtxrxp_in),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt0_gtxrxn_in                  (gt0_gtxrxn_in),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt0_rxbufreset_in              (gt0_rxbufreset_in),
        .gt0_rxbufstatus_out            (gt0_rxbufstatus_out),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .gt0_rxbyteisaligned_out        (gt0_rxbyteisaligned_out),
        .gt0_rxbyterealign_out          (gt0_rxbyterealign_out),
        .gt0_rxcommadet_out             (gt0_rxcommadet_out),
        .gt0_rxmcommaalignen_in         (gt0_rxmcommaalignen_in),
        .gt0_rxpcommaalignen_in         (gt0_rxpcommaalignen_in),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt0_rxlpmhfhold_in             (gt0_rxlpmhfhold_i),
        .gt0_rxdfeagcovrden_in          (gt0_rxdfeagcovrden_in),
        .gt0_rxlpmlfhold_in             (gt0_rxlpmlfhold_i),
        .gt0_rxdfelpmreset_in           (gt0_rxdfelpmreset_in),
        .gt0_rxmonitorout_out           (gt0_rxmonitorout_out),
        .gt0_rxmonitorsel_in            (gt0_rxmonitorsel_in),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt0_rxoutclk_out               (gt0_rxoutclk_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt0_rxpcsreset_in              (gt0_rxpcsreset_in),
        .gt0_rxpmareset_in              (gt0_rxpmareset_in),
        //---------------- Receive Ports - RX Margin Analysis ports ----------------
        .gt0_rxlpmen_in                 (gt0_rxlpmen_in),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .gt0_rxpolarity_in              (gt0_rxpolarity_in),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .gt0_rxchariscomma_out          (gt0_rxchariscomma_out),
        .gt0_rxcharisk_out              (gt0_rxcharisk_out),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt0_rxresetdone_out            (gt0_rxresetdone_i),
        //---------------------- TX Configurable Driver Ports ----------------------
        .gt0_txpostcursor_in            (gt0_txpostcursor_in),
        .gt0_txprecursor_in             (gt0_txprecursor_in),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt0_txuserrdy_in               (gt0_txuserrdy_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .gt0_txchardispmode_in          (gt0_txchardispmode_in),
        .gt0_txchardispval_in           (gt0_txchardispval_in),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .gt0_txusrclk_in                (gt0_txusrclk_in),
        .gt0_txusrclk2_in               (gt0_txusrclk2_in),
        //------------------- Transmit Ports - PCI Express Ports -------------------
        .gt0_txelecidle_in              (gt0_txelecidle_in),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt0_txprbsforceerr_in          (gt0_txprbsforceerr_in),
        //-------------------- Transmit Ports - TX Buffer Ports --------------------
        .gt0_txbufstatus_out            (gt0_txbufstatus_out),
        //------------- Transmit Ports - TX Configurable Driver Ports --------------
        .gt0_txdiffctrl_in              (gt0_txdiffctrl_in),
        .gt0_txinhibit_in               (gt0_txinhibit_in),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt0_txdata_in                  (gt0_txdata_in),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt0_gtxtxn_out                 (gt0_gtxtxn_out),
        .gt0_gtxtxp_out                 (gt0_gtxtxp_out),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt0_txoutclk_out               (gt0_txoutclk_i),
        .gt0_txoutclkfabric_out         (gt0_txoutclkfabric_out),
        .gt0_txoutclkpcs_out            (gt0_txoutclkpcs_out),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .gt0_txcharisk_in               (gt0_txcharisk_in),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt0_txpcsreset_in              (gt0_txpcsreset_in),
        .gt0_txpmareset_in              (gt0_txpmareset_in),
        .gt0_txresetdone_out            (gt0_txresetdone_i),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .gt0_txpolarity_in              (gt0_txpolarity_in),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt0_txprbssel_in               (gt0_txprbssel_in),




    //____________________________COMMON PORTS________________________________
        .gt0_qplloutclk_in              (gt0_qplloutclk_in),
        .gt0_qplloutrefclk_in           (gt0_qplloutrefclk_in)

    );


    assign  gt0_cplllock_out                     =  gt0_cplllock_i;
    assign  gt0_txresetdone_out                  =  gt0_txresetdone_i;
    assign  gt0_rxresetdone_out                  =  gt0_rxresetdone_i;
    assign  gt0_rxoutclk_out                     =  gt0_rxoutclk_i;
assign  gt0_txoutclk_out                     =  gt0_txoutclk_i;
generate
if (EXAMPLE_USE_CHIPSCOPE == 1) 
begin : chipscope
assign  gt0_cpllreset_i                      =  gt0_cpllreset_in || gt0_cpllreset_t;
assign  gt0_gttxreset_i                      =  gt0_gttxreset_in || gt0_gttxreset_t;
assign  gt0_gtrxreset_i                      =  gt0_gtrxreset_in || gt0_gtrxreset_t;
assign  gt0_txuserrdy_i                      =  gt0_txuserrdy_in || gt0_txuserrdy_t;
assign  gt0_rxuserrdy_i                      =  gt0_rxuserrdy_in || gt0_rxuserrdy_t;
end
endgenerate 

generate
if (EXAMPLE_USE_CHIPSCOPE == 0) 
begin : no_chipscope
    assign  gt0_cpllreset_i                      =  gt0_cpllreset_t;
    assign  gt0_gttxreset_i                      =  gt0_gttxreset_t;
    assign  gt0_gtrxreset_i                      =  gt0_gtrxreset_t;
    assign  gt0_txuserrdy_i                      =  gt0_txuserrdy_t;
    assign  gt0_rxuserrdy_i                      =  gt0_rxuserrdy_t;
end
endgenerate 


one_gig_eth_pcs_pma_TX_STARTUP_FSM #
          (
           .EXAMPLE_SIMULATION       (EXAMPLE_SIMULATION),
           .STABLE_CLOCK_PERIOD      (STABLE_CLOCK_PERIOD),           // Period of the stable clock driving this state-machine, unit is [ns]
           .RETRY_COUNTER_BITWIDTH   (8), 
           .TX_QPLL_USED             ("FALSE"),                       // the TX and RX Reset FSMs must
           .RX_QPLL_USED             ("FALSE"),                       // share these two generic values
           .PHASE_ALIGNMENT_MANUAL   ("FALSE")               // Decision if a manual phase-alignment is necessary or the automatic 
                                                                     // is enough. For single-lane applications the automatic alignment is 
                                                                     // sufficient              
             ) 
gt0_txresetfsm_i      
            ( 
        .STABLE_CLOCK                   (sysclk_in),
        .TXUSERCLK                      (gt0_txusrclk_in),
        .SOFT_RESET                     (soft_reset_tx_in),
        .QPLLREFCLKLOST                 (tied_to_ground_i),
        .CPLLREFCLKLOST                 (gt0_cpllrefclklost_i),
        .QPLLLOCK                       (tied_to_vcc_i),
        .CPLLLOCK                       (gt0_cplllock_i),
        .TXRESETDONE                    (gt0_txresetdone_i),
        .MMCM_LOCK                      (gt0_txuserrdy_in),
        .GTTXRESET                      (gt0_gttxreset_t),
        .MMCM_RESET                     (mmcm_reset),
        .QPLL_RESET                     (),
        .CPLL_RESET                     (gt0_cpllreset_t),
        .TX_FSM_RESET_DONE              (gt0_tx_fsm_reset_done_out),
        .TXUSERRDY                      (gt0_txuserrdy_t),
        .RUN_PHALIGNMENT                (),
        .RESET_PHALIGNMENT              (),
        .PHALIGNMENT_DONE               (tied_to_vcc_i),
        .RETRY_COUNTER                  ()
           );






one_gig_eth_pcs_pma_RX_STARTUP_FSM  #
          (
           .EXAMPLE_SIMULATION       (EXAMPLE_SIMULATION),
           .EQ_MODE                  ("LPM"),                   //Rx Equalization Mode - Set to DFE or LPM
           .STABLE_CLOCK_PERIOD      (STABLE_CLOCK_PERIOD),              //Period of the stable clock driving this state-machine, unit is [ns]
           .RETRY_COUNTER_BITWIDTH   (8), 
           .TX_QPLL_USED             ("FALSE"),                          // the TX and RX Reset FSMs must
           .RX_QPLL_USED             ("FALSE"),                          // share these two generic values
           .PHASE_ALIGNMENT_MANUAL   ("FALSE")                           // Decision if a manual phase-alignment is necessary or the automatic 
                                                                         // is enough. For single-lane applications the automatic alignment is 
                                                                         // sufficient              
             )     
gt0_rxresetfsm_i
             ( 
        .STABLE_CLOCK                   (sysclk_in),
        .RXUSERCLK                      (gt0_txusrclk_in),
        .SOFT_RESET                     (soft_reset_rx_in),
        .DONT_RESET_ON_DATA_ERROR       (dont_reset_on_data_error_in),
        .QPLLREFCLKLOST                 (tied_to_ground_i),
        .CPLLREFCLKLOST                 (gt0_cpllrefclklost_i),
        .QPLLLOCK                       (tied_to_vcc_i),
        .CPLLLOCK                       (gt0_cplllock_i),
        .RXRESETDONE                    (gt0_rxresetdone_i),
        .MMCM_LOCK                      (gt0_rxuserrdy_in),
        .RECCLK_STABLE                  (gt0_recclk_stable_i),
        .RECCLK_MONITOR_RESTART         (tied_to_ground_i),
        .DATA_VALID                     (gt0_data_valid_in),
        .TXUSERRDY                      (tied_to_vcc_i),
        .GTRXRESET                      (gt0_gtrxreset_t),
        .MMCM_RESET                     (recclk_mmcm_reset),
        .QPLL_RESET                     (),
        .CPLL_RESET                     (),
        .RX_FSM_RESET_DONE              (gt0_rx_fsm_reset_done_out),
        .RXUSERRDY                      (gt0_rxuserrdy_t),
        .RUN_PHALIGNMENT                (),
        .RESET_PHALIGNMENT              (),
        .PHALIGNMENT_DONE               (tied_to_vcc_i),
        .RXDFEAGCHOLD                   (gt0_rxdfeagchold_i),
        .RXDFELFHOLD                    (gt0_rxdfelfhold_i),
        .RXLPMLFHOLD                    (gt0_rxlpmlfhold_i),
        .RXLPMHFHOLD                    (gt0_rxlpmhfhold_i),
        .RETRY_COUNTER                  ()
           );

  always @(posedge sysclk_in)
  begin
        if(gt0_gtrxreset_gt)
        begin
          gt0_rx_cdrlocked       <= `DLY    1'b0;
          gt0_rx_cdrlock_counter <= `DLY    0;      
        end                
        else if (gt0_rx_cdrlock_counter == WAIT_TIME_CDRLOCK) 
        begin
          gt0_rx_cdrlocked       <= `DLY    1'b1;
          gt0_rx_cdrlock_counter <= `DLY    gt0_rx_cdrlock_counter;
        end
        else
          gt0_rx_cdrlock_counter <= `DLY    gt0_rx_cdrlock_counter + 1;
  end 

assign  gt0_recclk_stable_i                  =  gt0_rx_cdrlocked;


endmodule



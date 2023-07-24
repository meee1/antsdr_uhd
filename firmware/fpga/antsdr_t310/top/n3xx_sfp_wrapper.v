///////////////////////////////////////////////////////////////////
//
// Copyright 2017 Ettus Research, A National Instruments Company
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//
// Module: n3xx_sfp_wrapper
// Description:
//   Reduces clutter at top level.
//   - Aurora: wraps up sfpp_io, axil_regport and axi_dummy
//   - 1/10G: wrapper around network interface
//
//////////////////////////////////////////////////////////////////////

module n3xx_sfp_wrapper #(
  parameter        PROTOCOL     = "10GbE",    // Must be {10GbE, 1GbE, Aurora, Disabled}
  parameter        DWIDTH       = 32,
  parameter        AWIDTH       = 14,
  parameter [7:0]  PORTNUM      = 8'd0,
  parameter        GT_COMMON    = 1,
  parameter        MDIO_EN      = 0,
  parameter [4:0]  MDIO_PHYADDR = 5'd0,
  parameter [15:0] RFNOC_PROTOVER  = {8'd1, 8'd0}
)(
  // Resets
  input         areset,
  input         bus_rst,

  // Clocks
  input         gt_refclk,
  input         gb_refclk,
  input         misc_clk,
  input         bus_clk,
  // FIXME: Merge E320 and N310 files
  input         user_clk,
  input         sync_clk,

  //Axi-lite
  input                s_axi_aclk,
  input                s_axi_aresetn,
  input [AWIDTH-1:0]   s_axi_awaddr,
  input                s_axi_awvalid,
  output               s_axi_awready,

  input [DWIDTH-1:0]   s_axi_wdata,
  input [DWIDTH/8-1:0] s_axi_wstrb,
  input                s_axi_wvalid,
  output               s_axi_wready,

  output [1:0]         s_axi_bresp,
  output               s_axi_bvalid,
  input                s_axi_bready,

  input [AWIDTH-1:0]   s_axi_araddr,
  input                s_axi_arvalid,
  output               s_axi_arready,

  output [DWIDTH-1:0]  s_axi_rdata,
  output [1:0]         s_axi_rresp,
  output               s_axi_rvalid,
  input                s_axi_rready,

  // SFP high-speed IO
  output        txp,
  output        txn,
  input         rxp,
  input         rxn,

  // SFP low-speed IO
  input         sfpp_present_n,
  input         sfpp_rxlos,
  input         sfpp_tx_fault,
  output        sfpp_tx_disable,

  //GT Common
  input         qpllrefclklost,
  input         qplllock,
  input         qplloutclk,
  input         qplloutrefclk,
  output        qpllreset,

  //Aurora MMCM
  input         mmcm_locked,
  output        gt_pll_lock,
  output        gt_tx_out_clk_unbuf,

  // Vita router interface
  output  [63:0]  e2v_tdata,
  output  [31:0]  e2v_tuser,
  output          e2v_tlast,
  output          e2v_tvalid,
  input           e2v_tready,

  input   [63:0]  v2e_tdata,
  input   [31:0]  v2e_tuser,
  input           v2e_tlast,
  input           v2e_tvalid,
  output          v2e_tready,


  // CPU
  output  [63:0]  e2c_tdata,
  output  [7:0]   e2c_tkeep,
  output          e2c_tlast,
  output          e2c_tvalid,
  input           e2c_tready,

  input   [63:0]  c2e_tdata,
  input   [7:0]   c2e_tkeep,
  input           c2e_tlast,
  input           c2e_tvalid,
  output          c2e_tready,

  // MISC
  output   [31:0] port_info,
  input    [15:0] device_id,

  // Timebase Outputs
  output          sfp_pps,
  output          sfp_refclk,

  // Sideband White Rabbit Control
  input           wr_reset_n,
  input           wr_refclk,

  output          wr_dac_sclk,
  output          wr_dac_din,
  output          wr_dac_clr_n,
  output          wr_dac_cs_n,
  output          wr_dac_ldac_n,

  output          wr_eeprom_scl_o,
  input           wr_eeprom_scl_i,
  output          wr_eeprom_sda_o,
  input           wr_eeprom_sda_i,

  input           wr_uart_rx,
  output          wr_uart_tx,

  // WR AXI Control
  output               wr_axi_aclk,
  input                wr_axi_aresetn,
  input [31:0]         wr_axi_awaddr,
  input                wr_axi_awvalid,
  output               wr_axi_awready,
  input [DWIDTH-1:0]   wr_axi_wdata,
  input [DWIDTH/8-1:0] wr_axi_wstrb,
  input                wr_axi_wvalid,
  output               wr_axi_wready,
  output [1:0]         wr_axi_bresp,
  output               wr_axi_bvalid,
  input                wr_axi_bready,
  input [31:0]         wr_axi_araddr,
  input                wr_axi_arvalid,
  output               wr_axi_arready,
  output [DWIDTH-1:0]  wr_axi_rdata,
  output [1:0]         wr_axi_rresp,
  output               wr_axi_rvalid,
  input                wr_axi_rready,
  output               wr_axi_rlast,

  output          link_up,
  output          activity

);

  localparam REG_BASE_SFP_IO      = 14'h0;
  localparam REG_BASE_ETH_SWITCH  = 14'h1000;

  // AXI4-Lite to RegPort (PS to PL Register Access)
  wire                reg_wr_req;
  wire  [AWIDTH-1:0]  reg_wr_addr;
  wire  [DWIDTH-1:0]  reg_wr_data;
  wire                reg_rd_req;
  wire  [AWIDTH-1:0]  reg_rd_addr;
  wire                reg_rd_resp, reg_rd_resp_io, reg_rd_resp_eth_if;
  wire  [DWIDTH-1:0]  reg_rd_data, reg_rd_data_io, reg_rd_data_eth_if;

  axil_regport_master #(
    .DWIDTH         (DWIDTH),   // Width of the AXI4-Lite data bus (must be 32 or 64)
    .AWIDTH         (AWIDTH),   // Width of the address bus
    .WRBASE         (0),        // Write address base
    .RDBASE         (0),        // Read address base
    .TIMEOUT        (10)        // log2(timeout). Read will timeout after (2^TIMEOUT - 1) cycles
  ) sfp_reg_mst_i (
    // Clock and reset
    .s_axi_aclk     (s_axi_aclk),
    .s_axi_aresetn  (s_axi_aresetn),
    // AXI4-Lite: Write address port (domain: s_axi_aclk)
    .s_axi_awaddr   (s_axi_awaddr),
    .s_axi_awvalid  (s_axi_awvalid),
    .s_axi_awready  (s_axi_awready),
    // AXI4-Lite: Write data port (domain: s_axi_aclk)
    .s_axi_wdata    (s_axi_wdata),
    .s_axi_wstrb    (s_axi_wstrb),
    .s_axi_wvalid   (s_axi_wvalid),
    .s_axi_wready   (s_axi_wready),
    // AXI4-Lite: Write response port (domain: s_axi_aclk)
    .s_axi_bresp    (s_axi_bresp),
    .s_axi_bvalid   (s_axi_bvalid),
    .s_axi_bready   (s_axi_bready),
    // AXI4-Lite: Read address port (domain: s_axi_aclk)
    .s_axi_araddr   (s_axi_araddr),
    .s_axi_arvalid  (s_axi_arvalid),
    .s_axi_arready  (s_axi_arready),
    // AXI4-Lite: Read data port (domain: s_axi_aclk)
    .s_axi_rdata    (s_axi_rdata),
    .s_axi_rresp    (s_axi_rresp),
    .s_axi_rvalid   (s_axi_rvalid),
    .s_axi_rready   (s_axi_rready),
    // Register port: Write port (domain: reg_clk)
    .reg_clk        (bus_clk),
    .reg_wr_req     (reg_wr_req),
    .reg_wr_addr    (reg_wr_addr),
    .reg_wr_data    (reg_wr_data),
    // Register port: Read port (domain: reg_clk)
    .reg_rd_req     (reg_rd_req),
    .reg_rd_addr    (reg_rd_addr),
    .reg_rd_resp    (reg_rd_resp),
    .reg_rd_data    (reg_rd_data)
  );

  // Regport Mux for response
  regport_resp_mux #(
    .WIDTH      (DWIDTH),
    .NUM_SLAVES (2)
  ) reg_resp_mux_i (
    .clk(bus_clk), .reset(bus_rst),
    .sla_rd_resp({reg_rd_resp_eth_if, reg_rd_resp_io}),
    .sla_rd_data({reg_rd_data_eth_if, reg_rd_data_io}),
    .mst_rd_resp(reg_rd_resp), .mst_rd_data(reg_rd_data)
  );

  wire [63:0] sfpo_tdata, sfpi_tdata;
  wire [3:0]  sfpo_tuser, sfpi_tuser;
  wire        sfpo_tlast, sfpi_tlast, sfpo_tvalid, sfpi_tvalid, sfpo_tready, sfpi_tready;


    n3xx_mgt_io_core #(
      .PROTOCOL       (PROTOCOL),
      .REG_BASE       (REG_BASE_SFP_IO),
      .REG_DWIDTH     (DWIDTH),   // Width of the AXI4-Lite data bus (must be 32 or 64)
      .REG_AWIDTH     (AWIDTH),   // Width of the address bus
      .GT_COMMON      (GT_COMMON),
      .MDIO_EN        (MDIO_EN),
      .MDIO_PHYADDR   (MDIO_PHYADDR),
      .PORTNUM        (PORTNUM)
    ) mgt_io_i (
      //must reset all channels on quad when sfp1 gtx core is reset
      .areset         (areset),
      .gt_refclk      (gt_refclk),
      .gb_refclk      (gb_refclk),
      .misc_clk       (misc_clk),
      .user_clk       (user_clk),
      .sync_clk       (sync_clk),
      .gt_tx_out_clk_unbuf(gt_tx_out_clk_unbuf),

      .bus_rst        (bus_rst),
      .bus_clk        (bus_clk),
      .qpllreset      (qpllreset),
      .qplllock       (qplllock),
      .qplloutclk     (qplloutclk),
      .qplloutrefclk  (qplloutrefclk),
      .qpllrefclklost (qpllrefclklost),
      .mmcm_locked    (mmcm_locked),
      .gt_pll_lock    (gt_pll_lock),

      .txp            (txp),
      .txn            (txn),
      .rxp            (rxp),
      .rxn            (rxn),

      .sfpp_rxlos     (sfpp_rxlos),
      .sfpp_tx_fault  (sfpp_tx_fault),
      .sfpp_tx_disable(sfpp_tx_disable),

      //RegPort
      .reg_wr_req     (reg_wr_req),
      .reg_wr_addr    (reg_wr_addr),
      .reg_wr_data    (reg_wr_data),
      .reg_rd_req     (reg_rd_req),
      .reg_rd_addr    (reg_rd_addr),
      .reg_rd_resp    (reg_rd_resp_io),
      .reg_rd_data    (reg_rd_data_io),

      // Vita to Ethernet
      .s_axis_tdata   (sfpi_tdata),
      .s_axis_tuser   (sfpi_tuser),
      .s_axis_tlast   (sfpi_tlast),
      .s_axis_tvalid  (sfpi_tvalid),
      .s_axis_tready  (sfpi_tready),

      // Ethernet to Vita
      .m_axis_tdata   (sfpo_tdata),
      .m_axis_tuser   (sfpo_tuser),
      .m_axis_tlast   (sfpo_tlast),
      .m_axis_tvalid  (sfpo_tvalid),
      .m_axis_tready  (sfpo_tready),

      .port_info      (port_info),
      .link_up        (link_up),
      .activity       (activity)
    );


    wire [3:0] e2c_tuser;
    wire [3:0] c2e_tuser;

    // In AXI Stream, tkeep is the byte qualifier that indicates
    // whether the content of the associated byte
    // of TDATA is processed as part of the data stream.
    // tuser as used in eth_interface is the number of valid bytes

    // Converting tuser to tkeep for ingress packets
    assign e2c_tkeep = ~e2c_tlast ? 8'b1111_1111
                      : (e2c_tuser == 4'd0) ? 8'b1111_1111
                      : (e2c_tuser == 4'd1) ? 8'b0000_0001
                      : (e2c_tuser == 4'd2) ? 8'b0000_0011
                      : (e2c_tuser == 4'd3) ? 8'b0000_0111
                      : (e2c_tuser == 4'd4) ? 8'b0000_1111
                      : (e2c_tuser == 4'd5) ? 8'b0001_1111
                      : (e2c_tuser == 4'd6) ? 8'b0011_1111
                      : 8'b0111_1111;

    // Converting tkeep to tuser for egress packets
    assign c2e_tuser = ~c2e_tlast ? 4'd0
                      : (c2e_tkeep == 8'b1111_1111) ? 4'd0
                      : (c2e_tkeep == 8'b0111_1111) ? 4'd7
                      : (c2e_tkeep == 8'b0011_1111) ? 4'd6
                      : (c2e_tkeep == 8'b0001_1111) ? 4'd5
                      : (c2e_tkeep == 8'b0000_1111) ? 4'd4
                      : (c2e_tkeep == 8'b0000_0111) ? 4'd3
                      : (c2e_tkeep == 8'b0000_0011) ? 4'd2
                      : (c2e_tkeep == 8'b0000_0001) ? 4'd1
                      : 4'd0;


    eth_interface #(
      .PROTOVER   (RFNOC_PROTOVER),
      .MTU        (10),
      .NODE_INST  (0),
      .REG_AWIDTH (AWIDTH),
      .BASE       (REG_BASE_ETH_SWITCH)
    ) eth_interface (
      .clk           (bus_clk),
      .reset         (bus_rst),
      .device_id     (device_id),
      .reg_wr_req    (reg_wr_req),
      .reg_wr_addr   (reg_wr_addr),
      .reg_wr_data   (reg_wr_data),
      .reg_rd_req    (reg_rd_req),
      .reg_rd_addr   (reg_rd_addr),
      .reg_rd_resp   (reg_rd_resp_eth_if),
      .reg_rd_data   (reg_rd_data_eth_if),
      .my_mac        (),
      .my_ip         (),
      .my_udp_port   (),
      .eth_tx_tdata  (sfpi_tdata),
      .eth_tx_tuser  (sfpi_tuser),
      .eth_tx_tlast  (sfpi_tlast),
      .eth_tx_tvalid (sfpi_tvalid),
      .eth_tx_tready (sfpi_tready),
      .eth_rx_tdata  (sfpo_tdata),
      .eth_rx_tuser  (sfpo_tuser),
      .eth_rx_tlast  (sfpo_tlast),
      .eth_rx_tvalid (sfpo_tvalid),
      .eth_rx_tready (sfpo_tready),

      .e2v_tdata     (e2v_tdata),
      .e2v_tuser     (e2v_tuser),
      .e2v_tlast     (e2v_tlast),
      .e2v_tvalid    (e2v_tvalid),
      .e2v_tready    (e2v_tready),
      .v2e_tdata     (v2e_tdata),
      .v2e_tuser     (v2e_tuser),
      .v2e_tlast     (v2e_tlast),
      .v2e_tvalid    (v2e_tvalid),
      .v2e_tready    (v2e_tready),


      .e2c_tdata     (e2c_tdata),
      .e2c_tuser     (e2c_tuser),
      .e2c_tlast     (e2c_tlast),
      .e2c_tvalid    (e2c_tvalid),
      .e2c_tready    (e2c_tready),
      .c2e_tdata     (c2e_tdata),
      .c2e_tuser     (c2e_tuser),
      .c2e_tlast     (c2e_tlast),
      .c2e_tvalid    (c2e_tvalid),
      .c2e_tready    (c2e_tready)
    );

endmodule // n310_sfp_wrapper

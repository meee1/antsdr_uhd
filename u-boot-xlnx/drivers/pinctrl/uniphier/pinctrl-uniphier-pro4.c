/*
 * Copyright (C) 2015 Masahiro Yamada <yamada.masahiro@socionext.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <dm/device.h>
#include <dm/pinctrl.h>

#include "pinctrl-uniphier.h"

static const struct uniphier_pinctrl_pin uniphier_pro4_pins[] = {
};

static const unsigned emmc_pins[] = {40, 41, 42, 43, 51, 52, 53};
static const int emmc_muxvals[] = {1, 1, 1, 1, 1, 1, 1};
static const unsigned emmc_dat8_pins[] = {44, 45, 46, 47};
static const int emmc_dat8_muxvals[] = {1, 1, 1, 1};
static const unsigned ether_mii_pins[] = {160, 161, 162, 163, 164, 165, 166,
					  167, 168, 169, 170, 171, 172, 173,
					  174, 175, 176, 177, 178, 179};
static const int ether_mii_muxvals[] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					0, 0, 0, 0, 0, 0, 0};
static const unsigned ether_rgmii_pins[] = {160, 161, 162, 163, 164, 165, 167,
					    168, 169, 170, 171, 172, 176, 177,
					    178, 179};
static const int ether_rgmii_muxvals[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					  0, 0, 0, 0};
static const unsigned ether_rmii_pins[] = {160, 161, 162, 165, 168, 169, 172,
					   173, 176, 177, 178, 179};
static const int ether_rmii_muxvals[] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static const unsigned ether_rmiib_pins[] = {161, 162, 165, 167, 168, 169, 172,
					    173, 176, 177, 178, 179};
static const int ether_rmiib_muxvals[] = {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0};
static const unsigned i2c0_pins[] = {142, 143};
static const int i2c0_muxvals[] = {0, 0};
static const unsigned i2c1_pins[] = {144, 145};
static const int i2c1_muxvals[] = {0, 0};
static const unsigned i2c2_pins[] = {146, 147};
static const int i2c2_muxvals[] = {0, 0};
static const unsigned i2c3_pins[] = {148, 149};
static const int i2c3_muxvals[] = {0, 0};
static const unsigned i2c6_pins[] = {308, 309};
static const int i2c6_muxvals[] = {6, 6};
static const unsigned nand_pins[] = {40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
				     50, 51, 52, 53, 54};
static const int nand_muxvals[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static const unsigned nand_cs1_pins[] = {131, 132};
static const int nand_cs1_muxvals[] = {1, 1};
static const unsigned sd_pins[] = {150, 151, 152, 153, 154, 155, 156, 157, 158};
static const int sd_muxvals[] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
static const unsigned sd1_pins[] = {319, 320, 321, 322, 323, 324, 325, 326,
				    327};
static const int sd1_muxvals[] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
static const unsigned uart0_pins[] = {127, 128};
static const int uart0_muxvals[] = {0, 0};
static const unsigned uart1_pins[] = {129, 130};
static const int uart1_muxvals[] = {0, 0};
static const unsigned uart2_pins[] = {131, 132};
static const int uart2_muxvals[] = {0, 0};
static const unsigned uart3_pins[] = {88, 89};
static const int uart3_muxvals[] = {2, 2};
static const unsigned usb0_pins[] = {180, 181};
static const int usb0_muxvals[] = {0, 0};
static const unsigned usb1_pins[] = {182, 183};
static const int usb1_muxvals[] = {0, 0};
static const unsigned usb2_pins[] = {184, 185};
static const int usb2_muxvals[] = {0, 0};
static const unsigned usb3_pins[] = {186, 187};
static const int usb3_muxvals[] = {0, 0};

static const struct uniphier_pinctrl_group uniphier_pro4_groups[] = {
	UNIPHIER_PINCTRL_GROUP_SPL(emmc),
	UNIPHIER_PINCTRL_GROUP_SPL(emmc_dat8),
	UNIPHIER_PINCTRL_GROUP(ether_mii),
	UNIPHIER_PINCTRL_GROUP(ether_rgmii),
	UNIPHIER_PINCTRL_GROUP(ether_rmii),
	UNIPHIER_PINCTRL_GROUP(ether_rmiib),
	UNIPHIER_PINCTRL_GROUP(i2c0),
	UNIPHIER_PINCTRL_GROUP(i2c1),
	UNIPHIER_PINCTRL_GROUP(i2c2),
	UNIPHIER_PINCTRL_GROUP(i2c3),
	UNIPHIER_PINCTRL_GROUP(i2c6),
	UNIPHIER_PINCTRL_GROUP(nand),
	UNIPHIER_PINCTRL_GROUP(nand_cs1),
	UNIPHIER_PINCTRL_GROUP(sd),
	UNIPHIER_PINCTRL_GROUP(sd1),
	UNIPHIER_PINCTRL_GROUP_SPL(uart0),
	UNIPHIER_PINCTRL_GROUP_SPL(uart1),
	UNIPHIER_PINCTRL_GROUP_SPL(uart2),
	UNIPHIER_PINCTRL_GROUP_SPL(uart3),
	UNIPHIER_PINCTRL_GROUP(usb0),
	UNIPHIER_PINCTRL_GROUP(usb1),
	UNIPHIER_PINCTRL_GROUP(usb2),
	UNIPHIER_PINCTRL_GROUP(usb3),
};

static const char * const uniphier_pro4_functions[] = {
	UNIPHIER_PINMUX_FUNCTION_SPL(emmc),
	UNIPHIER_PINMUX_FUNCTION(ether_mii),
	UNIPHIER_PINMUX_FUNCTION(ether_rgmii),
	UNIPHIER_PINMUX_FUNCTION(ether_rmii),
	UNIPHIER_PINMUX_FUNCTION(i2c0),
	UNIPHIER_PINMUX_FUNCTION(i2c1),
	UNIPHIER_PINMUX_FUNCTION(i2c2),
	UNIPHIER_PINMUX_FUNCTION(i2c3),
	UNIPHIER_PINMUX_FUNCTION(i2c6),
	UNIPHIER_PINMUX_FUNCTION(nand),
	UNIPHIER_PINMUX_FUNCTION(sd),
	UNIPHIER_PINMUX_FUNCTION(sd1),
	UNIPHIER_PINMUX_FUNCTION_SPL(uart0),
	UNIPHIER_PINMUX_FUNCTION_SPL(uart1),
	UNIPHIER_PINMUX_FUNCTION_SPL(uart2),
	UNIPHIER_PINMUX_FUNCTION_SPL(uart3),
	UNIPHIER_PINMUX_FUNCTION(usb0),
	UNIPHIER_PINMUX_FUNCTION(usb1),
	UNIPHIER_PINMUX_FUNCTION(usb2),
	UNIPHIER_PINMUX_FUNCTION(usb3),
};

static struct uniphier_pinctrl_socdata uniphier_pro4_pinctrl_socdata = {
	.pins = uniphier_pro4_pins,
	.pins_count = ARRAY_SIZE(uniphier_pro4_pins),
	.groups = uniphier_pro4_groups,
	.groups_count = ARRAY_SIZE(uniphier_pro4_groups),
	.functions = uniphier_pro4_functions,
	.functions_count = ARRAY_SIZE(uniphier_pro4_functions),
	.caps = UNIPHIER_PINCTRL_CAPS_DBGMUX_SEPARATE,
};

static int uniphier_pro4_pinctrl_probe(struct udevice *dev)
{
	return uniphier_pinctrl_probe(dev, &uniphier_pro4_pinctrl_socdata);
}

static const struct udevice_id uniphier_pro4_pinctrl_match[] = {
	{ .compatible = "socionext,uniphier-pro4-pinctrl" },
	{ /* sentinel */ }
};

U_BOOT_DRIVER(uniphier_pro4_pinctrl) = {
	.name = "uniphier-pro4-pinctrl",
	.id = UCLASS_PINCTRL,
	.of_match = of_match_ptr(uniphier_pro4_pinctrl_match),
	.probe = uniphier_pro4_pinctrl_probe,
	.remove = uniphier_pinctrl_remove,
	.priv_auto_alloc_size = sizeof(struct uniphier_pinctrl_priv),
	.ops = &uniphier_pinctrl_ops,
	.flags = DM_FLAG_PRE_RELOC,
};

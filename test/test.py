# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    async def reg_write(a, d):
        dut.ui_in.value = ((d >> 4) & 0x70) | a
        dut.uio_in.value = d & 0xFF
        await ClockCycles(dut.clk, 1)
        dut.ui_in.value = 0x80 | ((d >> 4) & 0x70) | a
        dut.uio_in.value = d & 0xFF
        await ClockCycles(dut.clk, 1)
        dut.ui_in.value = ((d >> 4) & 0x70) | a
        dut.uio_in.value = d & 0xFF
        await ClockCycles(dut.clk, 1)

    async def vga_reset():
        dut.rst_n.value = 0
        await ClockCycles(dut.clk, 1)
        dut.rst_n.value = 1
        await ClockCycles(dut.clk, 1)

    await reg_write(0, 0)
    await vga_reset()
    assert dut.uo_out.value == 0b01110111

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
    await reg_write(3, 0)
    await reg_write(12, 0x00)
    assert dut.uo_out.value == 0b00000000

    await reg_write(12, 0x03)
    assert dut.uo_out.value == 0b01000100

    await reg_write(12, 0x0C)
    assert dut.uo_out.value == 0b00100010

    await reg_write(12, 0x30)
    assert dut.uo_out.value == 0b00010001

    await reg_write(12, 0x3F)
    assert dut.uo_out.value == 0b01110111

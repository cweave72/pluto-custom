/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xscutimer.h"
#include "xgpiops.h"

#define TIMER_DEVICE_ID  XPAR_XSCUTIMER_0_DEVICE_ID
#define TIMER_LOAD_VALUE    0x13de4355 // 1 sec @ timer clk freq of 333.333333 MHz)

#define GPIO_DEVICE_ID  XPAR_XGPIOPS_0_DEVICE_ID
#define LED_PIN  15
#define TOGGLE(pin) ((pin) ? 0x0 : 0x1)

XScuTimer timer;
XScuTimer_Config *timercfg;

XGpioPs gpio;

int main()
{
    int status;
    int iters = 0;
    unsigned int cnt = 0;
    u32 led = 1;
    XScuTimer *pt = &timer;
    XGpioPs_Config *gpioconfig;
    XGpioPs *gp = &gpio;

    init_platform();

    xil_printf("Hello World\r\n");

    timercfg = XScuTimer_LookupConfig(TIMER_DEVICE_ID);
    if (!timercfg)
    {
        xil_printf("Error getting timer config\r\n");
        goto exit;
    }

    status = XScuTimer_CfgInitialize(pt, timercfg, timercfg->BaseAddr);
    if (status != XST_SUCCESS)
    {
        xil_printf("Error initializing timer.\r\n");
        goto exit;
    }

    XScuTimer_SetPrescaler(pt, 0);
    XScuTimer_ClearInterruptStatus(pt);

    xil_printf("Current counter value = 0x%08x\r\n", XScuTimer_GetCounterValue(pt));
    xil_printf("Current counter prescaler = 0x%08x\r\n", XScuTimer_GetPrescaler(pt));
    xil_printf("IsReady = 0x%08x\r\n", timer.IsReady);
    xil_printf("IsStarted = 0x%08x\r\n", timer.IsStarted);
    xil_printf("IsExpired = 0x%08x\r\n", XScuTimer_IsExpired(pt));

    XScuTimer_LoadTimer(pt, TIMER_LOAD_VALUE);
    xil_printf("counter value after load = 0x%08x\r\n", XScuTimer_GetCounterValue(pt));

    XScuTimer_Start(pt);
    xil_printf("IsStarted = 0x%08x\r\n", timer.IsStarted);

    /* PS GPIO */
    gpioconfig = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
    if (!gpioconfig)
    {
        xil_printf("Error configuring ps gpio\r\n");
        goto exit;
    }
    status = XGpioPs_CfgInitialize(gp, gpioconfig, gpioconfig->BaseAddr);
    if (status != XST_SUCCESS)
    {
        xil_printf("Error on ps gpio init\r\n");
        goto exit;
    }

    XGpioPs_SetDirectionPin(gp, LED_PIN, 1);
    XGpioPs_SetOutputEnablePin(gp, LED_PIN, 1);
    XGpioPs_WritePin(gp, LED_PIN, led);
    led = XGpioPs_ReadPin(gp, LED_PIN);
    xil_printf("led pin = 0x%08x\r\n", led);

    for(;;)
    {
        iters++;
        if (XScuTimer_IsExpired(pt))
        {
            xil_printf("Timer expired! (%u)\r\n", cnt++);
            XScuTimer_ClearInterruptStatus(pt);
            XScuTimer_LoadTimer(pt, TIMER_LOAD_VALUE);

            /* Toggle led */
            led = XGpioPs_ReadPin(gp, LED_PIN);
            XGpioPs_WritePin(gp, LED_PIN, TOGGLE(led));
        }
        //else if (iters == 10000)
        //{
        //    xil_printf("Timer did not expire after a number of iters (0x%08x)!\r\n", XScuTimer_GetCounterValue(pt));
        //    break;
        //}
    }

exit:
    cleanup_platform();
    return 0;
}

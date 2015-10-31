/*
 * Filename: dip_timer.h
 *
 * (C) Copyright 1995-1997               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 * author: Geert van Kempen
 *
 */

#ifndef DIP_TIMER_H
#define DIP_TIMER_H
#ifdef __cplusplus
extern "C" {
#endif

/* define dip_Timer structure */
typedef  struct
{
	dip_int setTime;           /* time stamp when dip_TimerSet() was called, see time(2) */
	dip_int getTime;           /* time stamp when dip_TimerGet() was called, see time(2) */

	dip_float getClockTime;    /* amount of seconds passed between dip_TimerSet() and dip_TimerGet() */
	dip_float getSystemTime;   /* amount of CPU time (s) the system was doing things for the process */
	dip_float getUserTime;     /* amount of CPU time (s) executing instructions in the process */

   /* The values below are set by dip_TimerSet(), just ignore these! */
	dip_float setClockTime;
	dip_float setSystemTime;
	dip_float setUserTime;
} dip_Timer;

/* declarations of the timer functions */
DIP_ERROR dip_TimerSet ( dip_Timer * );
DIP_ERROR dip_TimerGet ( dip_Timer * );

#ifdef __cplusplus
}
#endif
#endif

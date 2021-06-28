#ifndef MY_SLEEP_H
#define MY_SLEEP_H

#include <stdio.h>
#include<stdlib.h>

#ifdef _MSC_VER
#include "unistd.h"

#include <sys/timeb.h>
#include <sys/types.h>
#include <winsock2.h>
 
int gettimeofday(struct timeval* t,void* timezone);
 
// from linux's sys/times.h
 
//#include <features.h>
 
#define __need_clock_t
#include <time.h>
 
 
/* Structure describing CPU time used by a process and its children.  */
struct tms
  {
    clock_t tms_utime;          /* User CPU time.  */
    clock_t tms_stime;          /* System CPU time.  */
 
    clock_t tms_cutime;         /* User CPU time of dead children.  */
    clock_t tms_cstime;         /* System CPU time of dead children.  */
  };
  
struct timezone {int dummy;}; // don't need it
 
/* Store the CPU time used by this process and all its
   dead children (and their dead children) in BUFFER.
   Return the elapsed real time, or (clock_t) -1 for errors.
   All times are in CLK_TCKths of a second.  */
clock_t times (struct tms *__buffer);
 
typedef long long suseconds_t ;

inline int gettimeofday(struct timeval* t,void* timezone)
{       struct _timeb timebuffer;
        _ftime( &timebuffer );
        t->tv_sec=timebuffer.time;
        t->tv_usec=1000*timebuffer.millitm;
		return 0;
}
 
inline clock_t times (struct tms *__buffer) {
 
	__buffer->tms_utime = clock();
	__buffer->tms_stime = 0;
	__buffer->tms_cstime = 0;
	__buffer->tms_cutime = 0;
	return __buffer->tms_utime;
}
#else
#include<unistd.h>

#include <sys/times.h> 
#include <sys/time.h>
#endif

#include <time.h>
#include <errno.h>

/*! Utility function to have a sleep function with better resolution and which only stops one thread. */

static void my_sleep(double sleeptime){
  struct timeval tv;
  struct timezone tzp;
  double start;
  double real;
  if(gettimeofday(&tv,&tzp)!=0) {
    perror("get_time: ");
    exit(-1);
  }
  start = (double)tv.tv_sec + ((double)tv.tv_usec/1000000.0);
  real=start;
  while( (real-start)<sleeptime){
    if(gettimeofday(&tv,&tzp)!=0) {
      perror("get_time: ");
      exit(-1);
    }
    real = (double)tv.tv_sec + ((double)tv.tv_usec/1000000.0);
  }
}

#endif

/* on sun4, GCC doesn't have printf prototypes, we provide them here */
#ifdef SUNOS41
   #ifdef GCC
      #include <stdio.h>
      #include <sys/stdtypes.h>
      #include <sys/param.h>
      #include <sys/types.h>
      #include <sys/time.h>
      #include <sys/times.h>
      time_t time(time_t *);
      long clock( void );
      #ifndef CLK_TCK
         #define CLK_TCK   HZ
      #endif
      #ifndef CLOCKS_PER_SEC
         #define CLOCKS_PER_SEC (1000000)
      #endif
      int printf(const char *, ...);
      int fprintf(FILE *, const char *, ...);
      int fclose(FILE *);
      int fscanf(FILE *, char *, ...);
      void fflush(FILE * );
      int fread(char *, int, int, FILE *);
      int fwrite(char *, int, int, FILE *);
      int fseek(FILE *, long, int );
      long fteel(FILE * );
      int rewind( FILE *);
   #endif
#endif

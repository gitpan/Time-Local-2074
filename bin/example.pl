#!/usr/bin/perl -w

use strict;
use blib;
use Time::Local::2074 qw(:ALL);

my $seconds     = timelocal(0,0,0,1,10,170);
my $nice_time   = localtime(2**31);
my $gmt_seconds = timegm(0,0,0,1,10,170);
my $gmt_time    = gmtime(2**31);
my $ux_time     = UNIX_TIMESTAMP('2073-07-04 12:34:56');
my $date        = FROM_UNIXTIME(2**31);

print 
  "There are $seconds seconds between Epoch and Nov 1, 2070 in my time zone.\n"
, "There are $gmt_seconds seconds between Epoch and Nov 1, 2070 GMT.\n"
, "2**31 seconds from Epoch, the time is $nice_time in my time zone.\n"
, "2**31 seconds from Epoch, the time is $gmt_time GMT\n"
, "UNIX_TIMESTAMP('2073-07-04 12:34:56') is $ux_time\n"
, "FROM_UNIXTIME(2**31) is $date\n";


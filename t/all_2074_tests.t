use Test;
BEGIN { plan tests => 36 };
use strict;
use Time::Local::2074 qw(:ALL);

local $^W = 1; # warnings on, compatible with old Perls

#
# Testing of CORE:: and Time::Local::
# modules can be turned on, but it is off by default.
# Certain platforms behave differently.  If you turn
# $RUN_ALL_TESTS = 1, update the number of tests to 54.
# (from 36)
#
my $RUN_ALL_TESTS = 0;

#
# Do not test unless we are in the Eastern time zone.
# To do otherwise would be bloody involved.
#

my $localtime    = Time::Local::timelocal(0,0,0,3,10,103);
my $gmtime       = Time::Local::timegm(0,0,0,3,10,103);
my $gmt_diff     = ($gmtime - $localtime) / 3600;
my $gmt_offset   = $gmt_diff * 3600;
my $eastern_diff = $gmt_diff + 5;

if ($eastern_diff)
{
    warn "No tests for your time zone (yet).\n";
    for (1..36)
    {
        skip(1, 1);
    }
    exit;
}

#
# Setup
#

my $old_limit_a = 2**31 - 1;
my $old_limit_b = $old_limit_a + 1;
my $new_limit_a = 2**31 + 86400 * 365.25 * 36 - 1;
my $old_last_timelocal = 2145934799; # End of Year 2037
my $new_last_timelocal = 3282008399; # End of Year 2073
my $old_last_timegm  = $old_last_timelocal + $gmt_offset;
my $new_last_timegm  = $new_last_timelocal + $gmt_offset;
my $new_gmtime_limit = $new_limit_a        + $gmt_offset;
my $random_time_1 = 3182043600;
my $random_time_2 = 3266411696;

###########
#         #
#  Tests  #
#         #
###########

#
# timelocal
#
ok (timelocal(59,59,23,31,11,137) == $old_last_timelocal);
ok (timelocal(0,0,0,1,0,138)      == $old_last_timelocal + 1);
ok (timelocal(7,14,22,18,0,138)   == $old_limit_a);
ok (timelocal(8,14,22,18,0,138)   == $old_limit_b);
ok (timelocal(0,0,0,1,10,170)     == $random_time_1);
ok (timelocal(59,59,23,31,11,173) == $new_last_timelocal);

#
# timegm
#

ok (timegm(59,59,23,31,11,137) == $old_last_timegm);
ok (timegm(0,0,0,1,0,138)      == $old_last_timegm + 1);

ok (timegm(7,14,3,19,0,138)    == $old_limit_a);
ok (timegm(8,14,3,19,0,138)    == $old_limit_b);
ok (timegm(0,0,5,1,10,170)     == $random_time_1);
ok (timegm(59,59,23,31,11,173) == $new_last_timegm);

#
# localtime
#

ok (join ('|',localtime(0)) eq '0|0|19|31|11|69|3|364|0');
ok (scalar localtime(0)     eq 'Wed Dec 31 19:00:00 1969');

ok (join ('|',localtime($old_limit_a)) eq '7|14|22|18|0|138|1|17|0');
ok (scalar localtime($old_limit_a)     eq 'Mon Jan 18 22:14:07 2038');

ok (join ('|',localtime($old_limit_b)) eq '8|14|22|18|0|138|1|17|0');
ok (scalar localtime($old_limit_b)     eq 'Mon Jan 18 22:14:08 2038');

ok (join ('|',localtime($new_limit_a)) eq '7|14|22|18|0|174|4|17|0');
ok (scalar localtime($new_limit_a)     eq 'Thu Jan 18 22:14:07 2074');

#
# gmtime
#

ok (join ('|',gmtime(0)) eq '0|0|0|1|0|70|4|0|0');
ok (scalar gmtime(0)     eq 'Thu Jan  1 00:00:00 1970');

ok (join ('|',gmtime($old_limit_a)) eq '7|14|3|19|0|138|2|18|0');
ok (scalar gmtime($old_limit_a)     eq 'Tue Jan 19 03:14:07 2038');

ok (join ('|',gmtime($old_limit_b)) eq '8|14|3|19|0|138|2|18|0');
ok (scalar gmtime($old_limit_b)     eq 'Tue Jan 19 03:14:08 2038');

ok (join ('|',gmtime($new_gmtime_limit)) eq '7|14|22|18|0|174|4|17|0');
ok (scalar gmtime($new_gmtime_limit)     eq 'Thu Jan 18 22:14:07 2074');

#
# UNIX_TIMESTAMP
#

ok (UNIX_TIMESTAMP('1970-01-01 00:00:00') == 3600 * 5);
ok (UNIX_TIMESTAMP('2038-01-18 22:14:07') == $old_limit_a);
ok (UNIX_TIMESTAMP('2038-01-18 22:14:08') == $old_limit_b);
ok (UNIX_TIMESTAMP('2073-07-04 12:34:56') == $random_time_2);
ok (UNIX_TIMESTAMP('2073-12-31 23:59:59') == $new_last_timelocal);
# The following breaks under some (all?) Win32 configurations.
#ok (UNIX_TIMESTAMP('1969-12-31 19:00:00') == 0);


#
# FROM_UNIXTIME
#

ok (FROM_UNIXTIME($old_limit_a) eq '2038-01-18 22:14:07');
ok (FROM_UNIXTIME($old_limit_b) eq '2038-01-18 22:14:08');
ok (FROM_UNIXTIME($new_limit_a) eq '2074-01-18 22:14:07');

# Testing of CORE:: and Time::Local::
if ($RUN_ALL_TESTS)
{
    #
    # localtime
    #
    ok (join ('|',CORE::localtime(0)) eq '0|0|19|31|11|69|3|364|0');
    ok (scalar CORE::localtime(0)     eq 'Wed Dec 31 19:00:00 1969');
    ok (join ('|',CORE::localtime($old_limit_a)) eq '7|14|22|18|0|138|1|17|0');
    ok (scalar CORE::localtime($old_limit_a)     eq 'Mon Jan 18 22:14:07 2038');
    ok (join ('|',CORE::localtime($old_limit_b)) eq '52|45|15|13|11|1|5|346|0');
    ok (scalar CORE::localtime($old_limit_b)     eq 'Fri Dec 13 15:45:52 1901');
    ok (join ('|',CORE::localtime($new_limit_a)) eq '51|45|15|13|11|37|1|346|0');
    ok (scalar CORE::localtime($new_limit_a)     eq 'Mon Dec 13 15:45:51 1937');

    #
    # gmtime
    #
    ok (join ('|',CORE::gmtime(0)) eq '0|0|0|1|0|70|4|0|0');
    ok (scalar CORE::gmtime(0)     eq 'Thu Jan  1 00:00:00 1970');

    ok (join ('|',CORE::gmtime($old_limit_a)) eq '7|14|3|19|0|138|2|18|0');
    ok (scalar CORE::gmtime($old_limit_a)     eq 'Tue Jan 19 03:14:07 2038');

    ok (join ('|',CORE::gmtime($old_limit_b)) eq '52|45|20|13|11|1|5|346|0');
    ok (scalar CORE::gmtime($old_limit_b)     eq 'Fri Dec 13 20:45:52 1901');

    ok (join ('|',CORE::gmtime($new_gmtime_limit)) eq '51|45|15|13|11|37|1|346|0');
    ok (scalar CORE::gmtime($new_gmtime_limit)     eq 'Mon Dec 13 15:45:51 1937');

    #
    # timelocal
    #
    ok (Time::Local::timelocal(59,59,23,31,11,137) == $old_last_timelocal);
    ok (Time::Local::timegm(59,59,23,31,11,137) == $old_last_timegm);
}

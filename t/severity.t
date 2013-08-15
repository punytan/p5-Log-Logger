use strict;
use warnings;
use Test::More;
use Log::Logger::Severity ':all';

subtest 'severity order' => sub {
    ok LOG_LEVEL_DEBUG < LOG_LEVEL_INFO;
    ok LOG_LEVEL_INFO  < LOG_LEVEL_WARN;
    ok LOG_LEVEL_WARN  < LOG_LEVEL_ERROR;
    ok LOG_LEVEL_ERROR < LOG_LEVEL_FATAL;
    ok LOG_LEVEL_FATAL < LOG_LEVEL_UNKNOWN;
};

done_testing;

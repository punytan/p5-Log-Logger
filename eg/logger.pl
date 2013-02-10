use strict;
use warnings;
use Log::Logger;
use Log::Logger::Severity ':all';
use Log::Logger::Formatter::Default;
use Log::Logger::Formatter::LTSV;
use Log::Logger::Handler::Screen;

{
    my $logger = Log::Logger->new;
    $logger->debug('hi, debug');
    $logger->info('hi, info');
    $logger->warn('hi, warn');
    $logger->error('hi, error');
    $logger->fatal('hi, fatal');
    $logger->unknown('hi, any');
}

{
    my $logger = Log::Logger->new(
        Screen => {
            level_condition => sub { $_[0] > LOG_LEVEL_DEBUG },
            formatter => {
                Default => { enable_color => 0 }
            }
        },
    );
    $logger->debug('hi, debug');
    $logger->info('hi, info');
    $logger->warn('hi, warn');
    $logger->error('hi, error');
    $logger->fatal('hi, fatal');
    $logger->unknown('hi, any');
}

{
    my $logger = Log::Logger->new(
        Screen => {
            level_condition => sub { $_[0] > LOG_LEVEL_DEBUG },
            formatter => {
                LTSV => {
                    enable_dump => 1,
                    sort_key    => 1,
                }
            }
        },
    );

    $logger->debug('hi, debug');

    $logger->info({
        time      => scalar(localtime),
        host      => "192.168.0.1",
        method    => "GET",
        path_info => "/list",
        protocol  => "HTTP/1.1",
        status    => 200,
        size      => 5316,
        referer   => "-",
        ua        => "Mozilla/5.0",
        taken     => 9789,
        isrobot   => 1,
        dos       => "-",
        harddos   => "-",
        cache     => "-",
    });

    my $res = {
        errors => [
            {
                code => 215,
                message => "Bad Authentication data",
            }
        ]
    };

    $logger->warn($res);
    $logger->error($res);
    $logger->fatal($res);
    $logger->unknown($res);
}

{
    my $logger = Log::Logger->new(
        File => {
            level_condition => sub { $_[0] > LOG_LEVEL_DEBUG },
            filename  => 'eg.log.%Y%m%d',
            formatter => {
                Default => { enable_color => 0 }
            }
        },
    );

    $logger->debug('hi, debug');
    $logger->info('hi, info');
    $logger->warn('hi, warn');
    $logger->error('hi, error');
    $logger->fatal('hi, fatal');
    $logger->unknown('hi, any');
}


__END__

D, [2013-02-08T00:30:08 #93116] DEBUG -- logger.pl: hi, debug
I, [2013-02-08T00:30:08 #93116]  INFO -- logger.pl: hi, info
W, [2013-02-08T00:30:08 #93116]  WARN -- logger.pl: hi, warn
E, [2013-02-08T00:30:08 #93116] ERROR -- logger.pl: hi, error
F, [2013-02-08T00:30:08 #93116] FATAL -- logger.pl: hi, fatal
A, [2013-02-08T00:30:08 #93116]   ANY -- logger.pl: hi, any
I, [2013-02-08T00:30:08 #93116]  INFO -- logger.pl: hi, info
W, [2013-02-08T00:30:08 #93116]  WARN -- logger.pl: hi, warn
E, [2013-02-08T00:30:08 #93116] ERROR -- logger.pl: hi, error
F, [2013-02-08T00:30:08 #93116] FATAL -- logger.pl: hi, fatal
A, [2013-02-08T00:30:08 #93116]   ANY -- logger.pl: hi, any
cache:- dos:-   harddos:-   host:192.168.0.1    isrobot:1   level:INFO  method:GET  path_info:/list protocol:HTTP/1.1   referer:-   size:5316   status:200  taken:9789  time:Fri Feb  8 00:30:08 2013   ua:Mozilla/5.0
errors:0.code:215   errors:0.message:Bad Authentication data    level:WARN
errors:0.code:215   errors:0.message:Bad Authentication data    level:ERROR
errors:0.code:215   errors:0.message:Bad Authentication data    level:FATAL
errors:0.code:215   errors:0.message:Bad Authentication data    level:ANY

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

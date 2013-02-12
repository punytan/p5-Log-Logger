package Log::Logger::Severity;
use strict;
use warnings;
use constant {
    LOG_LEVEL_DEBUG   => 1,
    LOG_LEVEL_INFO    => 1 << 1,
    LOG_LEVEL_WARN    => 1 << 2,
    LOG_LEVEL_ERROR   => 1 << 3,
    LOG_LEVEL_FATAL   => 1 << 4,
    LOG_LEVEL_UNKNOWN => 1 << 5,
};

use Exporter 'import';
our @EXPORT_OK = qw(
    LOG_LEVEL_DEBUG
    LOG_LEVEL_INFO
    LOG_LEVEL_WARN
    LOG_LEVEL_ERROR
    LOG_LEVEL_FATAL
    LOG_LEVEL_UNKNOWN
);

our %EXPORT_TAGS = (
    all => \@EXPORT_OK
);

our $NAME = {
    LOG_LEVEL_DEBUG,   'DEBUG',
    LOG_LEVEL_INFO,    'INFO',
    LOG_LEVEL_WARN,    'WARN',
    LOG_LEVEL_ERROR,   'ERROR',
    LOG_LEVEL_FATAL,   'FATAL',
    LOG_LEVEL_UNKNOWN, 'ANY',
};

our $MAP = { reverse %$NAME };

1;
__END__

=head1 NAME

Log::Logger::Severity - Log level constants for Log::Logger

=head1 SYNOPSIS

    use Log::Logger::Severity ':all'; # export all log levels

    # levels
    LOG_LEVEL_DEBUG
    LOG_LEVEL_INFO
    LOG_LEVEL_WARN
    LOG_LEVEL_ERROR
    LOG_LEVEL_FATAL
    LOG_LEVEL_UNKNOWN

=head1 DESCRIPTION

Log::Logger::Severity exports logging level constants for L<Log::Logger>

=head1 AUTHOR

punytan E<lt>punytan@gmail.comE<gt>

=head1 SEE ALSO

L<Log::Logger>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


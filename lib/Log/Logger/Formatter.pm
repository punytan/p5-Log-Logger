package Log::Logger::Formatter;
use strict;
use warnings;
use Time::Piece;
use Time::HiRes;
use File::Basename ();
use Sys::Hostname  ();
use Log::Logger::Severity;

sub new {
    my ($class, %args) = @_;

    bless {
        timestamp_format => ($args{timestamp_format} || '%Y-%m-%dT%H:%M:%S'),
    }, $class;
}

sub timestamp {
    my $self = shift;
    my ($seconds, $microseconds) = Time::HiRes::gettimeofday;
    localtime( Time::Piece->strptime($seconds, "%s")->epoch )->strftime($self->{timestamp_format});
}

sub log_level {
    my ($self, $level) = @_;
    $Log::Logger::Severity::NAME->{$level};
}

sub process_basename  { File::Basename::basename($0) }
sub pid               { $$ }
sub hostname          { Sys::Hostname::hostname() }
sub user              { scalar getpwuid($<) }
sub group             { scalar getgrgid($(+0) }
sub caller_filename   {}
sub caller_package    {}
sub caller_subroutine {}
sub caller_line       {}

1;
__END__

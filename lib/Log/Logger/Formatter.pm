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

    my $ts_format = $args{timestamp_format} // '%Y-%m-%dT%H:%M:%S';
    my $auto_newline  = $args{auto_newline} // 1;
    my $caller_level  = $args{caller_level} // 4;

    bless {
        timestamp_format => $ts_format,
        auto_newline     => $auto_newline,
        caller_level     => $caller_level,
    }, $class;
}

sub timestamp {
    my $self = shift;
    my ($seconds, $microseconds) = Time::HiRes::gettimeofday;
    localtime( Time::Piece->strptime($seconds, "%s")->epoch )
        ->strftime($self->{timestamp_format});
}

sub level_name {
    my ($self, $level) = @_;
    $Log::Logger::Severity::NAME->{$level};
}

sub pid      { $$ }
sub hostname { Sys::Hostname::hostname() }
sub user     { scalar getpwuid($<) }
sub group    { scalar getgrgid($(+0) }
sub basename { File::Basename::basename($0) }
sub caller_package    { (caller shift->{caller_level})[0] }
sub caller_filename   { (caller shift->{caller_level})[1] }
sub caller_line       { (caller shift->{caller_level})[2] }
sub caller_subroutine { (caller shift->{caller_level} + 1)[3] || "" }

1;
__END__

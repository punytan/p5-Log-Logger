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
    my $message_layout = $args{message_layout} // "%I, [%T #%P] %x -- %p: %m at %f line %l";

    bless {
        timestamp_format => $ts_format,
        auto_newline     => $auto_newline,
        caller_level     => $caller_level,
        message_layout   => $message_layout,
    }, $class;
}

sub render_layout {
    my ($self, $level, $message) = @_;

    my $caller = $self->caller;
    my %map = (
        I => sub { substr $self->level_name($level), 0, 1 },
        T => sub { $self->timestamp },
        P => sub { $self->pid },
        L => sub { $self->level_name($level) },
        x => sub { sprintf "%5s", $self->level_name($level) },
        p => sub { $caller->{package} },
        m => sub { $message },
        f => sub { $caller->{filename} },
        l => sub { $caller->{line} },
    );

    my $layout = $self->{message_layout};
    $layout =~ s/\%([ITPLpmflx])/$map{$1}->()/ge;

    $layout;
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
sub caller   {
    my ($package, $filename, $line);
    for (my $i = 0; ($package, $filename, $line) = caller $i; $i++) {
        last if $package !~ /^Log::Logger/;
    }
    return { package => $package, filename => $filename, line => $line };
}

1;
__END__

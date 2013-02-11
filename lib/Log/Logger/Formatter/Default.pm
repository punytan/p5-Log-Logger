package Log::Logger::Formatter::Default;
use strict;
use warnings;
use Term::ANSIColor ();
use parent 'Log::Logger::Formatter';

sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new(%args);

    $self->{enable_color} = $args{enable_color} // 1;
    $self->{color} = $args{color} // {
        DEBUG => [ qw/ red   on_white  / ],
        INFO  => [ qw/ green           / ],
        WARN  => [ qw/ black on_yellow / ],
        ERROR => [ qw/ red   on_black  / ],
        FATAL => [ qw/ black on_red    / ],
        ANY   => [ qw/ red   on_black  / ],
    };

    $self;
}

sub format {
    my ($self, $level, @args) = @_;

    my $level_name  = $self->level_name($level);
    my $severity_id = substr $level_name, 0, 1;

    my $message = $self->{enable_color}
        ? Term::ANSIColor::colored($self->{color}{$level_name}, "@args")
        : "@args";

    my $caller = $self->caller;
    my $log = sprintf "%s, [%s #%d] %5s -- %s: %s at %s line %s",
        $severity_id, $self->timestamp, $self->pid, $level_name,
        $caller->[0], $message, $caller->[1], $caller->[2];

    if ($self->{auto_newline}) {
        chomp $log;
        return "$log\n";
    }

    return $log;
}

1;
__END__


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

    my $log = sprintf "%s, [%s #%d] %5s -- %s: %s",
        $severity_id,  $self->timestamp, $self->pid, $level_name, $self->process_basename, $message;

    if ($self->{auto_newline}) {
        chomp $log;
        return "$log\n";
    }

    return $log;
}

1;
__END__


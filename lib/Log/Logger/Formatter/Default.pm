package Log::Logger::Formatter::Default;
use strict;
use warnings;
use Term::ANSIColor ();
use parent 'Log::Logger::Formatter';

sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new(%args);
    $self->{enable_color} = $args{enable_color} // 1;
    return $self;
}

sub format {
    my ($self, $level, @args) = @_;

    my $level_name  = $self->log_level($level);
    my $severity_id = substr $level_name, 0, 1;

    my $message = $self->{enable_color}
        ? Term::ANSIColor::colored([ 'green' ], "@args")
        : "@args";

    sprintf "%s, [%s #%d] %5s -- %s: %s",
        $severity_id,  $self->timestamp, $self->pid, $level_name, $self->process_basename, $message;
}

1;
__END__


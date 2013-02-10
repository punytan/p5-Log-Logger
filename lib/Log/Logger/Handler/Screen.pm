package Log::Logger::Handler::Screen;
use strict;
use warnings;
use parent 'Log::Logger::Handler';

sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new(%args);

    $self->{layer}  = $args{layer}  // ':encoding(UTF-8)';
    $self->{log_to} = $args{log_to} // *STDERR;

    $self;
}

sub write {
    my ($self, $level, @args) = @_;
    my $message = $self->formatter->format($level, @args);

    binmode $self->{log_to}, $self->{layer};
    print { $self->{log_to} } $message;
    binmode $self->{log_to}, ':pop';
}

1;
__END__

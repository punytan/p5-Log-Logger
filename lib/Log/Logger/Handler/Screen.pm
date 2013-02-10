package Log::Logger::Handler::Screen;
use strict;
use warnings;
use parent 'Log::Logger::Handler';

sub write {
    my ($self, $level, @args) = @_;

    my $message = $self->formatter->format($level, @args);
    print $message;
}

1;
__END__

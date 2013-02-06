package Log::Logger::Handler::Screen;
use strict;
use warnings;
use Term::ANSIColor ();
use parent 'Log::Logger::Handler';

sub write {
    my ($self, $level, @args) = @_;

    my $message = $self->formatter->format($level, @args);
    chomp $message;
    print $message, "\n";
}

1;
__END__

package Log::Logger;
use strict;
use warnings;
use Log::Logger::Util;
use Log::Logger::Severity ':all';

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my @args  = @_ ? @_ : ( Screen => {} );

    my @handlers;
    while (my ($handler_class, $opts) = splice @args, 0, 2) {
        my $pkg = Log::Logger::Util::load_class($handler_class, "Log::Logger::Handler");
        my $handler = $pkg->new(%$opts);
        push @handlers, $handler;
    }

    return bless {
        handlers => [ @handlers ],
    }, $class;
}

sub debug {
    my ($self, @args) = @_;
    $self->log(LOG_LEVEL_DEBUG, @args);
}

sub error {
    my ($self, @args) = @_;
    $self->log(LOG_LEVEL_ERROR, @args);
}

sub fatal {
    my ($self, @args) = @_;
    $self->log(LOG_LEVEL_FATAL, @args);
}

sub info {
    my ($self, @args) = @_;
    $self->log(LOG_LEVEL_INFO, @args);
}

sub unknown {
    my ($self, @args) = @_;
    $self->log(LOG_LEVEL_UNKNOWN, @args);
}

sub warn {
    my ($self, @args) = @_;
    $self->log(LOG_LEVEL_WARN, @args);
}

sub log {
    my ($self, $level, @args) = @_;

    for my $handler (@{ $self->{handlers} }) {
        next unless $handler->should_log($level);
        $handler->write($level, @args);
    }

}

1;
__END__
%N   Newline
%S   Program name
%m   Message

=head1 NAME

Log::Logger -

=head1 SYNOPSIS

  use Log::Logger;

=head1 DESCRIPTION

Log::Logger is

=head1 AUTHOR

punytan E<lt>punytan@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

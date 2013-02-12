package Log::Logger::Handler;
use strict;
use warnings;
use Log::Logger::Util;

sub new {
    my ($class, %args) = @_;

    $args{formatter} ||= {
        Default => {
            enable_color     => 1,
            timestamp_format => undef,
        }
    };

    my ($pkg, $opts) = each %{$args{formatter}};
    $pkg = Log::Logger::Util::load_class($pkg, "Log::Logger::Formatter");

    bless {
        formatter       => $pkg->new(%$opts),
        level_condition => $args{level_condition} || sub { 1 },
    }, $class;
}

sub formatter  { $_[0]->{formatter} }
sub should_log { $_[0]->{level_condition}->($_[1]) }

sub write { }

1;
__END__

=head1 NAME

Log::Logger::Handler - Base class for Log::Logger's output handler

=head1 METHODS

=head2 C<formatter>

Accessor to the formatter instance.

=head2 C<write($level, @args)>

The log level condition is sufficient, logger calls C<write> method with arguments (C<$level> and C<@args>).

=head1 AUTHOR

punytan E<lt>punytan@gmail.comE<gt>

=head1 SEE ALSO

L<Log::Logger::Handler::Screen>
L<Log::Logger::Handler::File>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


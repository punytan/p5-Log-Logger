package Log::Logger::Util;
use strict;
use warnings;

sub load_class { # copy from Plack::Util :D
    my($class, $prefix) = @_;

    if ($prefix) {
        unless ($class =~ s/^\+// || $class =~ /^$prefix/) {
            $class = "$prefix\::$class";
        }
    }

    my $file = $class;
    $file =~ s!::!/!g;
    require "$file.pm"; ## no critic

    return $class;
}

1;
__END__

=head1 NAME

Log::Logger::Util - Utility for Log::Logger

=head1 SYNOPSIS

    use Log::Logger::Util;

    my $pkg = Log::Logger::Util::load_class($class [, $prefix]);

=head1 METHODS

=head2 load_class

Load class in runtime. This is the same implementation as L<Plack::Util>.

    my $class = Log::Logger::Util::load_class($pkg [, $prefix]);

=head1 AUTHOR

punytan E<lt>punytan@gmail.comE<gt>

=head1 SEE ALSO

L<Plack::Util>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut




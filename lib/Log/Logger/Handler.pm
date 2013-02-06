package Log::Logger::Handler;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    $args{formatter} ||= {
        Default => {
            enable_color     => 1,
            timestamp_format => undef,
        }
    };

    my ($formatter) = keys %{ $args{formatter} };
    my $formatter_class = join "::", "Log::Logger::Formatter", $formatter;

    bless {
        level_condition => $args{level_condition} || sub { 1 },
        formatter => $formatter_class->new(
            %{ $args{formatter}->{$formatter} },
        ),
    }, $class;
}

sub formatter  { $_[0]->{formatter} }
sub should_log { $_[0]->{level_condition}->($_[1]) }

sub write { }

1;
__END__


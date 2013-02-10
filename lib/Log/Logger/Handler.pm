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


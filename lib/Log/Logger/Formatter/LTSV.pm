package Log::Logger::Formatter::LTSV;
use strict;
use warnings;
use parent 'Log::Logger::Formatter';
use Hash::Flatten;

sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new(%args);

    $self->{enable_dump} = $args{enable_dump} // 1;
    $self->{sort_keys}   = $args{sort_keys}   // 1;
    $self->{serializer}  = $self->{serializer} // Hash::Flatten->new(
        HashDelimiter  => '.',
        ArrayDelimiter => ',',
    );

    $self;
}

sub serializer { $_[0]->{serializer} }

sub format {
    my ($self, $level, $loginfo) = @_;

    unless (ref $loginfo eq 'HASH') {
        $loginfo = { message => $loginfo };
    }

    my $level_name = $self->log_level($level);
    my %log_hash = $self->{enable_dump}
        ? ( level => $level_name, %{ $self->serializer->flatten($loginfo) } )
        : ( level => $level_name, %$loginfo );

    my @keys = ($self->{sort_keys} ? sort keys %log_hash : keys %log_hash);

    join "\t", (map { "$_:$log_hash{$_}" =~ s/\t/\\t/gr } @keys);
}

1;
__END__

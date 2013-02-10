package Log::Logger::Handler::File;
use strict;
use warnings;
use Carp;
use POSIX;
use Fcntl qw( LOCK_EX LOCK_UN SEEK_END );
use Scalar::Util;
use IO::Handle 'autoflush';
use parent 'Log::Logger::Handler';

sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new(%args);

    unless ($args{filename} or ref $args{filename_generator} eq 'CODE') {
        Carp::croak "`filename` or `filename_generator` is required argument";
    }

    $self->{layer}     = $args{layer}     // '>>:encoding(utf8)';
    $self->{autoflush} = $args{autoflush} // 0;
    $self->{close}     = $args{close_after_write} // 1;
    # TODO $self->{permissions} = $args{permissions};

    $self->{filename}  = $args{filename} // '';
    $self->{generator} = $args{filename_generator} // sub {};

    $self->{max_filesize} = $args{max_filesize} // 0; # TODO

    $self->{_pid} = $$;
    $self->{_fh}  = undef;
    $self->{_prev_filename} = '';

    $self;
}

sub write {
    my ($self, $level, @args) = @_;

    my $filename = $self->_filename;
    my $message  = $self->formatter->format($level, @args);

    if ( $self->{close}               # fh is closed at all times
        or (not defined $self->{_fh}) # no filehandle
        or ($self->{_pid} != $$)      # fork()ed
        or ($filename ne $self->{_prev_filename}) # filename has been changed
        or ( ((stat $self->{_fh})[1] // "x") ne ((stat $filename)[1] // "y") ) # file has been moved (inodes differ)
    ) {
        if (my $fh = delete $self->{_fh}) {
            close $fh;
        }

        open $self->{_fh}, $self->{layer}, $filename
            or Carp::confess "Cannot open $filename: $!";

        autoflush $self->{_fh} if $self->{autoflush};
    }

    flock $self->{_fh}, LOCK_EX;
    seek  $self->{_fh}, 0, SEEK_END;
    print {$self->{_fh}} $message;
    flock $self->{_fh}, LOCK_UN;

    if ($self->{close}) {
        my $fh = delete $self->{_fh};
        close $fh;
    }

    $self->{_prev_filename} = $filename;
}

sub _filename {
    my $self = shift;
    my $filename = $self->{filename}
        ? POSIX::strftime($self->{filename}, localtime) # Hint: %Y-%m-%d %H:%M:%S
        : $self->{generator}->();
    return $filename;
}

sub DESTROY {
    my $self = shift;
    if ($self->{_fh} && Scalar::Util::openhandle($self->{_fh})) {
        close $self->{_fh} or Carp::confess "Cannot close filehandle: $!";
    }
}

1;
__END__


package Elasticsearch::Role::Connection;

use Moo::Role;
with 'Elasticsearch::Role::Error';
use namespace::autoclean;

use IO::Socket();
use URI();

requires qw(    protocol default_port handle );

has 'timeout' => (
    is      => 'ro',
    default => 30
);

has 'handle_params' => (
    is      => 'ro',
    default => sub { +{} }
);

has 'ping_request'  => ( is => 'lazy' );
has 'ping_response' => ( is => 'lazy' );

#===================================
sub inflate {
#===================================
    my $self    = shift;
    my $content = shift;

    my $output;
    require IO::Uncompress::Inflate;
    no warnings 'once';

    IO::Uncompress::Inflate::inflate( \$content, \$output, Transparent => 0 )
        or throw( 'Request',
        "Couldn't inflate response: $IO::Uncompress::Inflate::InflateError" );

    return $output;
}

#===================================
sub open_socket {
#===================================
    my ( $self, $node ) = @_;
    return IO::Socket::INET->new(
        PeerAddr => $node,
        Proto    => 'tcp',
        Blocking => 0
    );

}

1;

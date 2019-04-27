#!/usr/bin/perl -w
# index.pl --- TEst
# Author: Alexandr Selunin <qwars@HP-Laptop-Linux>
# Created: 19 Apr 2019
# Version: 0.01

use warnings;
use strict;

use Mojolicious::Lite;
use Mojo::IOLoop;
use Mojo::Pg;
use Mojo::JSON qw(decode_json encode_json);

use Data::Dumper;

my $count = 0;

`sudo -u postgres psql -c 'CREATE TABLE IF NOT EXISTS snippers ( id serial primary key, body json );'`;

my $pg = Mojo::Pg->new('postgresql://postgres@/postgres');

my $db = $pg->db->listen('insert');

sub getPageSnippers {
    my ( $self, $page, $count ) = @_;
    $self->send({ json => ['a', 'b'] })
        
}

sub getSnipper {
    my ( $self, $id ) = @_;
    # $db->insert('snippers', { title=>'First', body => $body }) && $db->notify('insert');
}

sub setSnipper {
    my ( $self, $json ) = @_;
    print Dumper $json
    # $db->insert('snippers', { body => $body }) && $db->notify('insert');
}

# sub timerSend {
#     my $self = shift;
#     Mojo::IOLoop->timer(
#         5 => sub {
#             my $loop = shift;
#             $self->send( getCountSnippers() );
#             timerSend( $self )
#         }
#     );
# }

post '/' => sub {
    
}

websocket '/' => sub {
    my $self = shift;
    $self->on(
        message => sub {
            my ($self, $message) = @_;
            if ( $message eq 'start' ) {
                $self->send( $db->query('select count(id) from snippers')->hash->{count} );
                $db->on(
                    notification => sub {                        
                        $self->send( $db->query('select count(id) from snippers')->hash->{count} )
                    }
                );
            }
            elsif ( $message =~ /set[:]\s(.+)/ ) { setSnipper( $self, $1 ) }
            elsif ( $message =~ /get[:]\s(\d+)/ ) { getSnipper( $self, $1 ) }
            elsif ( $message =~ /list[:]\s(\d+)\s*(\d+)*/ ) { getPageSnippers( $self, $1, $2 ) }
    });
};


app->start;

__END__

=head1 NAME

index.pl - Describe the usage of script briefly

=head1 SYNOPSIS

index.pl [options] args

      -opt --long      Option description

=head1 DESCRIPTION

Stub documentation for index.pl, 

=head1 AUTHOR

Alexandr Selunin, E<lt>qwars@HP-Laptop-LinuxE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2019 by Alexandr Selunin

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

=head1 BUGS

None reported... yet.

=cut

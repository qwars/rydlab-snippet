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
    $self->send( encode_json $db->select('snippers', '*')->expand->hashes )
}

sub getSnipper {
    my ( $self, $id ) = @_;
    $self->send( $db->select('snippers', ['body'], { id => $id } )->hash->{body} )
}

post '/' => sub {
    my $c = shift;
    $c->req->text;
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Pragma' => 'no-cache');
    $c->res->headers->header('Cache-Control' => 'no-cache');
    $c->render(text =>'Yee');
};

post '/insert' => sub {
    my $c = shift;
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Pragma' => 'no-cache');
    $c->res->headers->header('Cache-Control' => 'no-cache');
    $c->render( text => $db->insert('snippers', { body => $c->req->text }, {returning => 'id'})->hash->{id} )
};

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

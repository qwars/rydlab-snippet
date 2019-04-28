#!/usr/bin/perl -w
# index.pl --- TEst
# Author: Alexandr Selunin <qwars@HP-Laptop-Linux>
# Created: 19 Apr 2019
# Version: 0.01

use warnings;
use strict;

use utf8;
use Mojolicious::Lite;
use Mojo::Pg;
use Mojo::JSON qw(decode_json encode_json);
use MIME::Types;

use Data::Dumper;

`sudo -u postgres psql -c 'CREATE TABLE IF NOT EXISTS snippers ( id serial primary key, body json );'`;

my $pg = Mojo::Pg->new('postgresql://postgres@/postgres');

my $db = $pg->db->listen('insert');

my $mt = MIME::Types->new;

get '/view/:id' => sub {
    my $c = shift;
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Pragma' => 'no-cache');
    $c->res->headers->header('Cache-Control' => 'no-cache');
    my $response = $db->select('snippers', ['body'], { id => $c->param('id') } )->hash;
    $c->render( text => $response ? $response->{body} : 'null' )
};

get '/list/:count/:page' => sub {
    my $c = shift;
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Pragma' => 'no-cache');
    $c->res->headers->header('Cache-Control' => 'no-cache');
    my $count = $c->param('count');
    my $offset = ( $c->param('page') - 1 ) * $count;
    $c->render( json => $db->select('snippers', '*', undef, \"id ASC LIMIT $count OFFSET $offset")->expand->hashes );
};

post '/insert' => sub {
    my $c = shift;
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Pragma' => 'no-cache');
    $c->res->headers->header('Cache-Control' => 'no-cache');
    my $response = $db->insert('snippers', { body => $c->req->text }, {returning => 'id'})->hash;
    $c->render( text => $response ? $response->{id} : 'null' )
};

post '/' => sub {
    my $c = shift;
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Pragma' => 'no-cache');
    $c->res->headers->header('Cache-Control' => 'no-cache');
    my $filename = $c->req->text =~ /ext\.(\w+?)*$/ ? $c->req->text : 'ext.txt' ;
    my $mm = $mt->mimeTypeOf( $filename );
    my $mime = { %{ $mm || {}  }, ( filename => $filename , mode => ( $mm ? $mm->subType() : 'text'  ) ) };
    $c->render( json => $mime )
};


websocket '/' => sub {
    my $self = shift;
    $self->on(
        message => sub {
            my ($self, $message) = @_;
            $self->send( $db->query('select count(id) from snippers')->hash->{count} );
            $db->on(
                notification => sub {                        
                    $self->send( text => $db->query('select count(id) from snippers')->hash->{count} )
                }
            );
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

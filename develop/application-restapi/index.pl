#!/usr/bin/perl -w
# index.pl --- Тестовое задание
# Author: Alexandr Selunin <aka.qwars@gmail.com>
# Created: 19 Apr 2019
# Version: 0.01

use warnings;
use strict;

use utf8;
use Mojolicious::Lite;
use Mojo::Pg;
use Mojo::Pg::Migrations;
use MIME::Types;
use Data::Dumper;

# При первом запуске создаем таблицу 'snippers'

my $pg = Mojo::Pg->new( 'postgresql://postgres@/postgres' );

Mojo::Pg::Migrations->new( pg => $pg )->from_string('CREATE TABLE IF NOT EXISTS snippers ( id serial primary key, created TIMESTAMP DEFAULT NOW(), body json );');

$pg->db->dbh->{pg_enable_utf8} = 1;

my $db = $pg->db->listen( 'insert' );

my $mt = MIME::Types->new;

sub headerOrigin {
    my $c = shift;
    $c->res->headers->header( 'Access-Control-Allow-Origin' => '*' );
    $c->res->headers->header( 'Pragma'                      => 'no-cache' );
    $c->res->headers->header( 'Cache-Control'               => 'no-cache' );
    $c
}


=head1 NAME

index.pl - ws сервер

=head1 SYNOPSIS

morbo -m production -w ./index.pl ./index.pl

=head1 DESCRIPTION

=over

=item C<get '/view/:id'> - Получение данных snipper по id. Пример: C<GET>  http://example.com/view/34

=cut

# Получение данных snipper по id. Пример:  http://example.com/view/34

get '/view/:id' => sub {
    my $c = headerOrigin( shift );
    my $response = $db->select( 'snippers', ['body'], { id => $c->param( 'id' ) } )->hash;
    $c->render( text => $response ? $response->{body} : 'null' );
};

=item C<get '/list/:count/:page'> - Получение данных списка snipper. Пример: C<GET>  http://example.com//list/24/4

=cut

# Получение данных списка snipper. Пример:  http://example.com//list/24/4

get '/list/:count/:page' => sub {
    my $c = headerOrigin( shift );
    return $c->render( json => [] ) if $c->param( 'count' ) =~ /\D/ || $c->param( 'page' )  =~ /\D/;
    my $count  = $c->param( 'count' );
    my $offset = ( $c->param( 'page' ) - 1 ) * $count;
    $c->render( json => $db->select( 'snippers', '*', undef, \"id DESC LIMIT $count OFFSET $offset" )->expand->hashes );
};

=item C<get '/insert'> - Добавление нового snipper. Пример: C<POST>   http://example.com/insert

Тело запроса содержит JSON данные snipper

=cut

# Добавление нового snipper. Пример: C<POST>   http://example.com/insert

post '/insert' => sub {
    my $c = headerOrigin( shift );    
    my $response = $db->insert( 'snippers', { body => $c->req->text }, { returning => 'id' } )->hash;
    $c->render( text => $response ? $response->{id} : 'null' );
};

=item C<get '/'> - Получение MIME данных. Пример: C<POST>   http://example.com/

Тело запроса содержит имя файла

=cut

# Получение MIME данных. Пример: C<POST>   http://example.com/

post '/' => sub {
    my $c = headerOrigin( shift );
    my $filename = $c->req->text =~ /ext\.(\w+?)*$/ ? $c->req->text : 'ext.txt';
    my $mm       = $mt->mimeTypeOf( $filename );
    my $mime     = { %{ $mm || {} }, ( filename => $filename, mode => ( $mm ? $mm->subType() : 'text' ) ) };
    $c->render( json => $mime );
};

=item C<websocket '/' > - Запуск демона ws для слежение за состоянием таблицы Pg 'snipper'. Пример:  ws://example.com/

Возвращаем количество данных в таблице, при изменении данных

=back

=cut

# Демон ws для слежение за состоянием таблицы Pg 'snipper'. Пример:  ws://example.com/

websocket '/' => sub {
    my $self = shift;
    $self->on(
        message => sub {
            my ( $self, $message ) = @_;
            $self->send( $db->query( 'select count(id) from snippers' )->hash->{count} );

            # Вешаем слушателя, возвращаем количество данных в таблице
            $db->on(
                notification => sub {
                    $self->send( text => $db->query( 'select count(id) from snippers' )->hash->{count} );
                } );
        } );
};

# Стартуем демона

app->start;

__END__

=head1 AUTHOR

Alexandr Selunin, E<lt>aka.qwars@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2019 by Alexandr Selunin

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

=head1 BUGS

None reported... yet.

=cut

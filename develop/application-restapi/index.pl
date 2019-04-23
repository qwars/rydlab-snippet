#!/usr/bin/perl -w
# index.pl --- TEst
# Author: Alexandr Selunin <qwars@HP-Laptop-Linux>
# Created: 19 Apr 2019
# Version: 0.01

use warnings;
use strict;

use Mojolicious::Lite;
use Mojo::IOLoop;

my $count = 0;

sub getCountSnippers {
    $count < 40 ? $count++ : $count
}

sub getPageSnippers {
    my ( $self, $page, $count ) = @_;
    $self->send({ json => ['a', 'b'] })
        
}

sub getSnipper {
    my ( $self, $id ) = @_;
    $self->send( { json => { 'id' => $id } } )
}

sub timerSend {
    my $self = shift;
    Mojo::IOLoop->timer(
        5 => sub {
            my $loop = shift;
            $self->send( getCountSnippers() );
            timerSend( $self )
        }
    );
}

websocket '/' => sub {
    my $self = shift;
    $self->on(
        message => sub {
            my ($self, $message) = @_;
            if ( $message eq 'start' ) {
                $self->send( getCountSnippers() );
                timerSend( $self )
            }
            elsif ( $message =~ /get[:]\s(\d+)/ ) { getSnipper( $self, $1 ) }
            elsif ( $message =~ /list[:]\s(\d+)\s*(\d+)*/ ) { getPageSnippers( $self, $1, $2 ) }
    });
};


app->start;

=head_p
use CGI;

print foreach (
    "Content-Type: text/plain\n\n",
    "BW Test version 5.0\n",
    "Copyright 1995-2008 The BearHeart Group, LLC\n\n",
    "Versions:\n=================\n",
    "perl: $]\n",
    "CGI: $CGI::VERSION\n"
);

my $q = CGI::Vars();
print "\nCGI Values:\n=================\n";
foreach my $k ( sort keys %$q ) {
    print "$k [$q->{$k}]\n";
}

print "\nEnvironment Variables:\n=================\n";
foreach my $k ( sort keys %ENV ) {
    print "$k [$ENV{$k}]\n";
}

=cut

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

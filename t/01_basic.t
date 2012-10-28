use strict;
use warnings;
use utf8;
use Text::MojoEP;

use Test::More tests => 3;

my $template = q{<%= my_func(shift) =%>};
my $mt = Text::MojoEP->new;
$mt->add_function('my_func',  sub { $_[0] ** 2 });
is $mt->render($template, 1), 1;
is $mt->render($template, 2), 4;
is $mt->render($template, 3), 9;

use strict;
use warnings;
use utf8;
use Text::MojoEP;

use Test::More tests => 4;

{
    my $template = q{<%= my_func(shift) =%>};
    my $mt = Text::MojoEP->new;
    $mt->add_function('my_func',  sub { $_[0] ** 2 });
    is $mt->render($template, 1), 1;
    is $mt->render($template, 2), 4;
    is $mt->render($template, 3), 9;
}
{
    my $template = <<'EOF';
<%
    my $a = 'foo';
    *{ 'bar::' . $a } = sub {'baz'};
=%>
<%= bar::foo() =%>
EOF
    my $mt = Text::MojoEP->new;
    my $res = $mt->render($template, 1);
    like $res, qr/symbol ref/;
}

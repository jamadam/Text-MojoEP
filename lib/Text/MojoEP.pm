package Text::MojoEP;
use strict;
use warnings;
use Mojo::Base -base;

our $VERSION = '0.01';

__PACKAGE__->attr(mt => sub { Mojo::Template->new });
__PACKAGE__->attr(funcs => sub {{}});

sub add_function {
    my ($self, $name, $cb) = @_;
    $self->funcs->{$name} = $cb;
    return $self;
}

sub render {
    my ($self, $path, @args) = @_;
    
    my $mt = $self->mt;
    
    if (! $mt->compiled) {
        my $prepend = q/no strict 'refs'; no warnings 'redefine';/;
    
        $prepend .= 'my $_H = shift; my $_F = $_H->funcs;';
        for my $name (keys %{$self->funcs}) {
            $prepend .= "sub $name; *$name = sub {\$_F->{$name}->(\@_)};";
        }
        
        $mt->prepend($prepend);
        
        return $mt->render($path, $self, @args);
    }
    
    return $mt->interpret($self, @args);
}

1;

__END__

=head1 NAME

Text::MojoEP - Mojo::Template wrapper

=head1 SYNOPSIS

    use Text::MojoEP;
    
    my $template = q{<%= my_func(shift) %>};
    my $mt = Text::EmbeddedPerl->new;
    
    $mt->add_function('my_func',  sub { $_[0] ** 2 });
    
    print $mt->render($template, 1); # 1
    print $mt->render($template, 2); # 4
    print $mt->render($template, 3); # 9

=head1 DESCRIPTION

Mojo::Template wrapper for encapsulating low level APIs.

=head1 ATTRIBUTES

L<Text::MojoEP> implements the following attributes.

=head2 C<mt>

L<Mojo::Template> instance.

    my $mt = $mojoep->mt;

=head2 C<funcs>

An array ref to contain template functions.

    $self->funcs->{'some name'} = sub {...};

=head1 METHODS

L<Text::MojoEP> implements the following methods.

=head2 C<add_function>

Addes a function.

    $mojoep->add_function('foo', sub {...});

=head2 C<render>

Renders a template with given arguments.

    print $mt->render($template, @args);

=head1 SEE ALSO

L<Mojo::Template>, L<Mojolicious::Plugin::EP>, L<Mojolicious>

=cut

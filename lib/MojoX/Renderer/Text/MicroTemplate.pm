package MojoX::Renderer::Text::MicroTemplate;

use strict;
use warnings;
our $VERSION = '0.01';

use Text::MicroTemplate::File;

sub build_handler {
    my $class   = shift;
    my $mojo    = shift;
    my $handler = shift || 'epl';
    $mojo->renderer->add_handler(
        $handler => sub {
            my ( $self, $c, $output ) = @_;

            my $path = $c->stash->{template_path};
            $self->{_mt_cache} ||= {};
            my $mt = $self->{_mt_cache}->{$path};

            unless ($mt) {
                $mt = $self->{_mt_cache}->{$path}
                    = Text::MicroTemplate::File->new;
                $mt->{line_start} = '%';
                $mt->{tag_start}  = '<%';
                $mt->{tag_end}    = '%>';
            }
            ${$output} = ${ $mt->render_file( $path, $c ) };
        }
    );
}



1;
__END__

=head1 NAME

MojoX::Renderer::Text::MicroTemplate -

=head1 SYNOPSIS

  use MojoX::Renderer::Text::MicroTemplate;

  sub startup {
      $self = shift;

      ...

      MojoX::Renderer::Text::MicroTemplate->build_handler($self);
  }

=head1 DESCRIPTION

MojoX::Renderer::Text::MicroTemplate is Text::MicroTemplate renderer for Mojo.

=head1 TEMPLATE SYNTAX

MojoX::Renderer::Text::MicroTemplate is same syntax of Mojo::Template.
Additional, output the result of expression with automatic escape.
See also L<Text::MicroTemplate>;

    <%= $expr %>
    %= $expr

=head1 AUTHOR

Kazuhiro Shibuya E<lt>stevenlabs {at} gmail.comE<gt>

=head1 SEE ALSO

L<Mojo>, L<Text::MicroTemplate>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

package MojoX::Renderer::Text::MicroTemplate;

use strict;

use warnings;
our $VERSION = '0.01';

use Text::MicroTemplate::File;
use File::Spec;

sub build_handler {
    my $class    = shift;
    my $mojo     = shift;
    my $handler  = shift || 'epl';
    my $io_layer = shift || 'utf8';
    $io_layer = ':encoding(' . $io_layer . ')';
    $mojo->renderer->add_handler(
        $handler => sub {
            my ($r, $c, $output, $options) = @_;

            my $file = $r->template_name($options);
            my $path = $r->root;

            unless (-r $path) {
                $c->app->log->error(
                    "Template $path missing or not readable.");
                return;
            }
            $r->{_mt_cache} ||= {};
            my $mt = $r->{_mt_cache}->{$path};


            unless ($mt) {
                $mt = $r->{_mt_cache}->{$path}
                  = Text::MicroTemplate::File->new(include_path => [$path],);
                $mt->{open_layer} = $io_layer;
                $mt->{line_start} = '%';
                $mt->{tag_start}  = '<%';
                $mt->{tag_end}    = '%>';
            }

            ${$output} = ${$mt->render_file($file, $c)};
            return ${$output};
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

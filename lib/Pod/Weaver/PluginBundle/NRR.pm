use strict;
use warnings;

package Pod::Weaver::PluginBundle::NRR;

# VERSION

use Pod::Weaver::Config::Assembler;

# Dependencies
use Pod::Weaver::Plugin::WikiDoc ();
use Pod::Elemental::Transformer::List 0.101620 ();
use Pod::Weaver::Section::Support 1.001        ();

sub _exp { Pod::Weaver::Config::Assembler->expand_package( $_[0] ) }

sub mvp_bundle_config
{
    my @plugins;
    push @plugins, (
        [ '@NRR/Encoding', _exp( 'Encoding' ),  {} ],
        [ '@NRR/CorePrep', _exp( '@CorePrep' ), {} ],
        [ '@NRR/Name',     _exp( 'Name' ),      {} ],
        [ '@NRR/Version',  _exp( 'Version' ),   {} ],

        [   '@NRR/Prelude',
            _exp( 'Region' ),
            { region_name => 'prelude' }
        ],

        [   '@NRR/Synopsis', _exp( 'Generic' ), { header => 'SYNOPSIS' }
        ],
        [   '@NRR/Description',
            _exp( 'Generic' ),
            { header => 'DESCRIPTION' }
        ],
        [   '@NRR/Overview', _exp( 'Generic' ), { header => 'OVERVIEW' }
        ],
        [ '@NRR/Usage', _exp( 'Generic' ), { header => 'USAGE' } ],
    );

    for my $plugin (
        [ 'Attributes', _exp( 'Collect' ), { command => 'attr' } ],
        [ 'Methods',    _exp( 'Collect' ), { command => 'method' } ],
        [ 'Functions',  _exp( 'Collect' ), { command => 'func' } ],
        )
    {
        $plugin->[2]{header} = uc $plugin->[0];
        push @plugins, $plugin;
    }

    push @plugins,
        (
        [ '@NRR/Leftovers', _exp( 'Leftovers' ), {} ],
        [   '@NRR/postlude',
            _exp( 'Region' ),
            { region_name => 'postlude' }
        ],
        [   '@NRR/Support',
            _exp( 'Support' ),
            {   websites =>
                    'search, ratings, testers, testmatrix, deps',
                bugs               => 'metadata',
                repository_link    => 'both',
                repository_content => '',
            }
        ],
        [ '@NRR/Authors', _exp( 'Authors' ), {} ],
        [ '@NRR/Legal',   _exp( 'Legal' ),   {} ],
        [   '@NRR/List',
            _exp( '-Transformer' ),
            { 'transformer' => 'List' }
        ],
        [ '@NRR/Stopwords', _exp( '-Stopwords' ), {} ],
        );

    return @plugins;
}

# ABSTRACT: Weave a web of Pod the NRR way
# COPYRIGHT

1;

=for Pod::Coverage mvp_bundle_config

=begin wikidoc

= DESCRIPTION

This is a [Pod::Weaver] PluginBundle.

= USAGE

This PluginBundle is used automatically with the C<@NRR> [Dist::Zilla]
plugin bundle.

= SEE ALSO

* [Pod::Weaver]
* [Pod::Weaver::Plugin::WikiDoc]
* [Pod::Elemental::Transformer::List]
* [Dist::Zilla::Plugin::PodWeaver]

=end wikidoc

=cut

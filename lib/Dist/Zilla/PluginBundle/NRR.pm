use strictures;

package Dist::Zilla::PluginBundle::NRR;

use 5.010;
use utf8;
use open qw(:std :utf8);
use charnames qw(:full :short);

use Moose;
use Dist::Zilla;

with 'Dist::Zilla::Role::PluginBundle::Easy';

# VERSION
# ABSTRACT: Rampage through CPAN-Tokyo the NRR way!
# ENCODING: utf-8

=head1 SYNOPSIS

Rawr!

=cut

has _plugins => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    default => sub {
        my $self = shift;
        [   qw(
                AutoPrereqs
                MinimumPerl
                GithubMeta
                ),
            [   'MetaNoIndex' =>
                    { directory => [qw[ t xt examples corpus ]], }
            ],
            [   'Bugtracker' => {
                    web    => 'https://github.com/nrr/%s/issues',
                    mailto => 'nrr+bug-%U@corvidae.org',
                }
            ],
            [ 'MetaProvides::Package' => { meta_noindex => 1, } ],
            qw(
                MetaYAML
                MetaJSON
                ),
            [ 'AutoVersion' => { major => $self->major_version, } ],
            [   'GatherDir' => {
                    exclude_filename => [
                        qw[
                            README.pod
                            META.json
                            perlcritic.rc
                            perltidy.rc
                            ]
                    ],
                }
            ],
            [   'PruneCruft' => {
                    except => [
                        qw[
                            .gitignore
                            perlcritic.rc
                            perltidy.rc
                            ]
                    ],
                }
            ],
            qw(
                ManifestSkip
                OurPkgVersion
                InsertCopyright
                PodWeaver
                ),
            [ 'PerlTidy' => { perltidyrc => 'perltidy.rc', } ],
            qw(
                License
                ReadmeFromPod
                ),
            [   'ReadmeAnyFromPod' => {
                    type     => 'pod',
                    filename => 'README.pod',
                    location => 'root',
                }
            ],
            [ 'Test::Compile' => { fake_home => 1, } ],
            qw(
                Test::PodSpelling
                ),
            [   'Test::Perl::Critic' =>
                    { critic_config => 'perlcritic.rc', }
            ],
            qw(
                MetaTests
                PodSyntaxTests
                PodCoverageTests
                Test::Portability
                Test::Version
                ExecDir
                ShareDir
                MakeMaker
                Manifest
                ),
            [   'CopyFilesFromBuild' => {
                    copy => [qw[ META.json ]],
                    move => [qw[ .gitignore ]],
                }
            ],
            [   'Git::Check' => {
                    allow_dirty => [
                        qw[
                            dist.ini
                            Changes
                            README.pod
                            META.json
                            ]
                    ],
                }
            ],
            qw(
                CheckPrereqsIndexed
                CheckChangesHasContent
                CheckExtraTests
                TestRelease
                ConfirmRelease
                ),
            ( $self->is_test_dist ? 'FakeRelease' : 'UploadToCPAN' ),
            qw(
                NextRelease
                ),
            [   'Git::Commit' => {
                    allow_dirty => [
                        qw[
                            dist.ini
                            Changes
                            README.pod
                            META.json
                            ]
                    ],
                }
            ],
            [ 'Git::Tag'  => { tag_format => 'release-%v', } ],
            [ 'Git::Push' => { push_to    => 'origin', } ],
        ];
    },
);

has stopwords => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{stopwords}
            ? $_[0]->payload->{stopwords}
            : [];
    },
);

has fake_release => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{fake_release} },
);

has weaver_config => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { $_[0]->payload->{weaver_config} || '@NRR' },
);

has major_version => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{major_version}
            ? $_[0]->payload->{major_version}
            : 1;
    },
);

sub configure
{
    my ( $self ) = @_;

    $self->add_plugins(
        map { [ $_ => ( $self->plugin_options->{$_} || {} ) ] }
            @{ $self->_plugins },
    );
}

1;

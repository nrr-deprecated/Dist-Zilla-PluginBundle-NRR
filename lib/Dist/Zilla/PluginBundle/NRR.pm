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
		[
			qw(
				AutoPrereqs
				MinimumPerl
				GithubMeta
				MetaNoIndex
				Bugtracker
				MetaProvides::Package
				MetaYAML
				MetaJSON
				AutoVersion
				GatherDir
				PruneCruft
				ManifestSkip
				OurPkgVersion
				InsertCopyright
				PodWeaver
				PerlTidy
				License
				ReadmeFromPod
				ReadmeAnyFromPod
				Test::Compile
				Test::PodSpelling
				Test::Perl::Critic
				MetaTests
				PodSyntaxTests
				PodCoverageTests
				Test::Portability
				Test::Version
				ExecDir
				ShareDir
				MakeMaker
				Manifest
				CopyFilesFromBuild
				Git::Check
				CheckPrereqsIndexed
				CheckChangesHasContent
				CheckExtraTests
				TestRelease
				ConfirmRelease
			),
			($self->is_test_dist ? 'FakeRelease' : 'UploadToCPAN'),
			qw(
				NextRelease
				Git::Commit
				Git::Tag
				Git::Push
			),
		]
	},
);

has stopwords => (
	is => 'ro',
	isa => 'ArrayRef',
	lazy => 1,
	default => sub {
		exists $_[0]->payload->{stopwords} ? $_[0]->payload->{stopwords} : []
	},
);

has fake_release => (
	is => 'ro',
	isa => 'Bool',
	lazy => 1,
	default => sub { $_[0]->payload->{fake_release} },
);

has weaver_config => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub { $_[0]->payload->{weaver_config} || '@NRR' },
);

sub configure
{
	my ($self) = @_;

	$self->add_plugins(
		[ 'Prereqs' => 'TestMoreDoneTesting' => {
			-phase       => 'test',
			-type        => 'requires',
			'Test::More' => '0.88',
		} ]
	);
	$self->add_plugins(
		map { [ $_ => ($self->plugin_options->{$_} || {}) ] }
		@{ $self->_plugins },
	);
}

1;

# Load the Module::Install bundled in ./inc/
use inc::Module::Install;
use Module::Install::GithubMeta;
use Module::Install::ManifestSkip;
use Module::Install::AutoManifest;

# Define metadata
name           'MooseX-Role-Parameterized';
all_from       'lib/MooseX/Role/Parameterized.pm';
githubmeta;

requires      'Moose' => '2.0300';
test_requires 'Test::Moose';
test_requires 'Test::More' => '0.96';
test_requires 'Test::Fatal';

manifest_skip;
auto_manifest;
WriteAll;


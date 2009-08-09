# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'MooseX-Role-Parameterized';
all_from       'lib/MooseX/Role/Parameterized.pm';
githubmeta;

requires       'Moose' => '0.78';
test_requires  'Test::Moose';

build_requires 'Test::Exception' => '0.27';

WriteAll;



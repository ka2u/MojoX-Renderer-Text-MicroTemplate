use inc::Module::Install;
name 'MojoX-Renderer-Text-MicroTemplate';
all_from 'lib/MojoX/Renderer/Text/MicroTemplate.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

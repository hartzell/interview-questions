
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'File::Find' => '0',
    'File::Temp' => '0',
    'Module::Build' => '0.3601',
    'Test::Class' => '0',
    'Test::MockObject' => '0',
    'Test::More' => '0',
    'Test::Most' => '0',
    'Test::Output' => '0'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Top level documentation for the Zephyr homework assignment.',
  'dist_author' => [
    'George Hartzell'
  ],
  'dist_name' => 'ZephyrTask',
  'dist_version' => '1.102800',
  'license' => 'restrictive',
  'module_name' => 'ZephyrTask',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Log::Log4perl' => '0',
    'Moose' => '0',
    'Moose::Role' => '0',
    'Moose::Util::TypeConstraints' => '0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;

#!perl

# instance script for Test::Class based tests of the
# Zephyr stuff

use lib 't/lib';
use Test::Zephyr::App;
use Test::Zephyr::Fund;

Test::Class->runtests;

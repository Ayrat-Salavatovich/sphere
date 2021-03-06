#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Sphere';
all_from 'lib/Sphere.pm';

requires 'Catalyst::Runtime' => '5.90112';
requires 'Catalyst::Devel' => '1.39';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats

requires 'Catalyst::View::TT' => '0.44';
requires 'Catalyst::View::JSON' => '0.36';
requires 'DBD::Pg' => '3.5.3';
requires 'DBIx::Class' => '0.082840';
requires 'Catalyst::Model::DBIC::Schema' => '0.65';
requires 'DBIx::Class::Schema::Loader' => '0.07045';
requires 'MooseX::NonMoose' => '0.26';
requires 'MooseX::ClassAttribute' => '0.29';
requires 'HTML::FormHandler' => '0.40066';
requires 'HTML::FormHandler::Moose' => '0.40066';
requires 'Furl' => '3.09';
requires 'Catalyst::Action::REST' => '1.20';
requires 'Catalyst::Plugin::Session' => '0.40';
requires 'Catalyst::Plugin::Session::State::Cookie' => '0.17';
requires 'Catalyst::Plugin::Session::Store::DBIC' => '0.14';
requires 'Google::OAuth2::Client::Simple' => '0.004';
requires 'Google::API::OAuth2::Client' => '0.14';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;

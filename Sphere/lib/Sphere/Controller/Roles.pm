package Sphere::Controller::Roles;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use Sphere::Form::Role;

=head1 NAME

Sphere::Controller::Roles - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index : Path Args(0) {
    my ( $self, $c ) = @_;
    
    $c->detach('list');
}

sub base : Chained('/') PathPart('roles') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash( roles    => $c->model('SphereAppDB::Role') );
    $c->stash( statuses => $c->model('SphereAppDB::Status') );
}

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    if ($id =~ /\D/) { # Misuse of URL, ID does not contain only digits.
	$c->detach('/not_found', []);
    } else {
	my $role = $c->stash->{roles}->find({ pk => int($id), key => 'primary' });
	if (not defined $role) { # Could not find a role with ID.
	    $c->stash->{error_msg} = "Role not found.";
	    $c->detach('/not_found', []);
	} else {
	    $c->stash->{role} = $role;
	}
    }
}

sub list : Chained('base') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;
    
    my $roles = $c->stash->{roles}->search(
	{},
	{
	    columns  => [qw/pk name description status_fk/],
	    order_by => 'name',
	}
    );
    $c->stash(roles => $roles);
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Role->new;
	my $result = $form->run( params => $params );
	if ($result->has_errors) {
	    $c->stash->{error_msg} = "Parameters is incorrect.";
	} elsif ($c->stash->{roles}->count_literal("name LIKE ?", $params->{role_name}."%") > 0) {
	    $c->stash->{error_msg} = "Role already exists.";
	} else {
	    $c->forward('save');
	}
    } else {
	$c->forward('form');
    }
}

sub remove : Chained('object') PathPart('remove') Args(0) {
    my ( $self, $c ) = @_;

    my $role = $c->stash->{role};
    $role->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Role->new;
	my $result = $form->run( params => $params );
	if ($result->has_errors) {
	    $c->stash->{error_msg} = "Parameters is incorrect.";
	} else {
	    $c->forward('save');
	}
    } else {
	$c->forward('form');
    }
}

sub view : Chained('object') PathPart('view') Args(0) {
    my ( $self, $c ) = @_;
}

sub save : Private {
    my ($self, $c) = @_;
    
    my $params = $c->req->params;
    my $status = $c->stash->{statuses}->find({ pk => int($params->{role_status}) });
    if ($status) {
	if ($c->stash->{role}) {
	    # Update the role
	    $c->stash->{role}->update({
		name => $params->{role_name},
		description => $params->{role_description},
		status => $status,
	    });
	} else {
	    # Create the role
	    $c->stash->{roles}->create({
		name => $params->{role_name},
		description => $params->{role_description} || '',
		status => $status,
	    });
	}
	$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
    } else {
	$c->stash->{error_msg} = "Status does not exist or you do not have permission.";
    }
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{role}) {
	$c->stash( template => 'roles/edit.tt' );
    } else {
	$c->stash( template => 'roles/add.tt' );
    }
}

=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

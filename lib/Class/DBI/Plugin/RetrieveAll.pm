package Class::DBI::Plugin::RetrieveAll;

our $VERSION = 1.00;

use strict;
use warnings;

=head1 NAME

Class::DBI::Plugin::RetrieveAll - more complex retrieve_all() for Class::DBI

=head1 SYNOPSIS

	use base 'Class::DBI';
	use Class::DBI::Plugin::RetrieveAll;

	my @by_date = My::Class->retrieve_all_sorted_by("date");

=head1 DESCRIPTION

This is a simple plugin to a Class::DBI subclass which provides a
'retrieve_all_sorted_by' method.

=head1 METHODS

=head2 retrieve_all_sorted_by

	my @by_date = My::Class->retrieve_all_sorted_by("date");

This method will be exported into the calling class, and allows for
retrieving all the objects of the class, sorted by the given column.

The argument given will be passed straight through to the database 'as
is', and is not checked in any way, so an error here will probably result
in an error from the database, rather than Class::DBI itself. However,
because of this it is possible to pass more complex ORDER BY clauses
through:

	my @by_date = My::Class->retrieve_all_sorted_by("date DESC, reference_no");

=cut

sub import {
	my ($self, @pairs) = @_;
	my $caller = caller();
	no strict 'refs';

	$caller->set_sql(retrieve_all_sorted => <<'');
		SELECT __ESSENTIAL__
		FROM __TABLE__
		ORDER BY %s

	*{"$caller\::retrieve_all_sorted_by"} = sub {
		my ($class, $order_by) = @_;
		return $class->sth_to_objects($class->sql_retrieve_all_sorted($order_by));
	};
}

=head1 AUTHOR

Tony Bowden, E<lt>kasei@tmtm.comE<gt>.

=head1 COPYRIGHT

Copyright (C) 2004 Kasei. All rights reserved.

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;


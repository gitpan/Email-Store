package Email::Store::Entity::Correlator::Trivial;

sub get_person_order { 99 }
sub get_person {
    my ($self, $person_r, $mail, $role, $name, $address) = @_;
    return if $$person_r;
    my %seen;
    my @candidates = 
        grep {! $seen{$_->id}++ }
        map { $_->entity }
    Email::Store::Addressing->search(
            name => $name->id,
            address => $address->id
    );
    if (@candidates == 0) {
       $$person_r = Email::Store::Entity->create({notes => ""});
       return;
    } elsif (@candidates == 1) {
       $$person_r = $candidates[0];
    } else {
       # This shouldn't happen, but anyway:
       $$person_r = $candidates[0];
    }
}

1;

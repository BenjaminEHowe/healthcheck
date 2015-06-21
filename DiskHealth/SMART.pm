package DiskHealth::SMART;

use strict;
use warnings;

use version; our $VERSION = qv('1.0');

sub check {
    use Spec::Disks;
    my @disks = Spec::Disks::list();
    my %status;
    foreach my $disk (@disks) {
        unless (`/usr/sbin/smartctl -H $disk` =~ m/SMART overall-health self-assessment test result: PASSED/) {
            $status{$disk} = 'SMART self-assessment failed';
            next;
        }
        my $SMART_attributes = `/usr/sbin/smartctl -A $disk`;
        my ($capacity, $media) = Spec::Disks::type($disk);
        $status{$disk} = 'good';
    }
    return %status;
}

1;

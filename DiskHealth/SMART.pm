package DiskHealth::SMART;

use strict;
use warnings;

use version; our $VERSION = qv('1.0');

sub check {
    use Spec::Disks;
    my @disks = Spec::Disks::list();
    my %status;
    my $parted;
    foreach my $disk (@disks) {
        $parted = `/sbin/parted $disk print`;
        if ($parted =~ /Model:.*QEMU/ || $parted =~ /Model: Virtio/) {
            $status{$disk} = 'virtual';
            next;
        }
        unless (`/usr/sbin/smartctl -H $disk` =~ m/SMART overall-health self-assessment test result: PASSED/) {
            $status{$disk} = 'SMART self-assessment failed';
            next;
        }
        $status{$disk} = 'good';
    }
    return %status;
}

1;

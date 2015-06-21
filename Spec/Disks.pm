package Spec::Disks;

use strict;
use warnings;

use version; our $VERSION = qv('1.0');

sub type {
    my $disk = $_[0];
    my $SMART = `/usr/sbin/smartctl -i $disk`;
    my ($capacity, $media);
    if ($SMART =~ /User Capacity:.*\[(.*?) (.B)\]/) {
        $capacity = (sprintf "%.0f", $1) . $2;
    } else {
        my $parted = `parted $disk print`;
        if ($parted =~ /Disk .*: (.*)(.B)/) {
            $capacity = (sprintf "%.0f", $1) . $2;
        }
    }
    if ($SMART =~ /Device Model:.*SSD/) {
        $media = 'SSD';
    } elsif ($SMART =~ /Device Model:.*QEMU/) {
        $media = 'Virtual';
    } else {
        $media = 'HDD';
    }
    return ($capacity, $media);
}

sub list {
    my $diskscan = `/usr/sbin/smartctl --scan`;
    my @disks;
    while ($diskscan =~ /([^\n]+)\n?/g) {
        if ($1 =~ /(.*?) /) {
            push @disks, $1;
        }
    }
    return @disks;
}

1;

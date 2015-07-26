package Spec::Disks;

use strict;
use warnings;

use version; our $VERSION = qv('1.0');

sub type {
    my $disk = $_[0];
    my ($capacity, $media);
    my $parted = `/sbin/parted $disk print`;
    if ($parted =~ /Disk $disk: (.*)/) {
        $capacity = $1;
    }
    if ($parted =~ /Model:.*INTEL/ || $parted =~ /Model:.* TS/) {
        $media = 'SSD';
    } elsif ($parted =~ /Model:.*QEMU/ || $parted =~ /Model: Virtio/) {
        $media = 'Virtual';
    } else {
        $media = 'HDD';
    }
    return ($capacity, $media);
}

sub list {
    my $diskscan = `/sbin/fdisk -l`;
    my @disks;
    while ($diskscan =~ /Disk (\/dev\/[hsv]d.*):/g) {
        push @disks, $1;
    }
    return @disks;
}

1;

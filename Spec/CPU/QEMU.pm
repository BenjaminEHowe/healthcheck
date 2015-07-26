package Spec::CPU::QEMU;

use strict;
use warnings;

use version; our $VERSION = qv('1.0');

sub getcores {
    if ($_[0] =~ m/cpu cores\s*:\s*(\d+)/) {
        return $1;
    } else {
        return 1;
    }
}

sub getfreq {
    my $freq;
    if ($_[0] =~ /cpu MHz		: (.*)/) {
        my $freq = $1;
        $freq = int($freq / 100 + .5) * 100;
        if ($freq >= 1000) {
            $freq /= 1000;
            $freq .= '0 Ghz';
        } else {
            $freq .= ' Mhz';
        }
        return $freq;
    } else {
        warn "Couldn't identify processor frequency\n";
        exit(1);
    }
}

1;

package Spec::CPU::Intel;

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
    if ($_[0] =~ m/@ (.*Hz)/) {
        return $1;
    } else {
        warn "Couldn't identify processor frequency\n";
        exit(1);
    }
}

sub celeron {
    my $family = 'Celeron';

    my %versions = (
        'G5' => 'Sandy Bridge',
        'G4' => 'Sandy Bridge',
        'G16' => 'Ivy Bridge',
        'J1' => 'Bay Trail-D',
        'G18' => 'Haswell-DT',
    );

    my ($model, $url, $arch);

    if ($_[0] =~ m/CPU (.*) @/m) {
        $model = $1;
        $url = "http://ark.intel.com/search?q=$family $model";
        $url =~ s/ /%20/g; # remove spaces (if any) from the model
        if ($model =~ m/^(G\d)\d{2}$/) { # Sandy Bridge
            $arch = $versions{$1};
        } elsif ($model =~ m/^(J\d)/) { # Bay Trail-D
            $arch = $versions{$1}
        } elsif ($model =~ m/^(G\d\d)/) { # Ivy Bridge, Haswell-DT
            $arch = $versions{$1}
        } else {
            warn "Couldn't indentify processor family (Intel, model $model)\n";
            exit(1);
        }
    } else {
        warn "Couldn't identify processor (suspect Intel $family)\n";
        exit(1);
    }

    return "<a href=\"$url\">$family $model</a> ($arch)";
}

sub core {
    my $family = 'Core';

    my %versions = (
        'iX-2' => 'Sandy Bridge',
        'iX-3' => 'Ivy Bridge',
        'iX-4' => 'Haswell',
        'iX-5' => 'Broadwell',
        'iX-6' => 'Skylake',
    );

    my ($model, $url, $arch);

    if ($_[0] =~ m/\(TM\) (.*) CPU/m) {
        $model = $1;
        $url = "http://ark.intel.com/search?q=$family $model";
        $url =~ s/ /%20/g; # remove spaces (if any) from the model
        if ($model =~ m/^i\d-(\d)/) { # Sandy Bridge to Skylake
            $arch = $versions{"iX-$1"};
        } else {
            warn "Couldn't indentify processor family (Intel, model $model)\n";
            exit(1);
        }
    } else {
        warn "Couldn't identify processor (suspect Intel $family)\n";
        exit(1);
    }

    return "<a href=\"$url\">$family $model</a> ($arch)";
}

sub xeon {
    my $family = 'Xeon';

    my %versions = (
        34 => 'Clarkdale / Lynnfield', # could be smarter by examining the third digit, but there's not much point right now
        35 => 'Bloonfield',
        36 => 'Gulftown',
        53 => 'Clovertown',
        54 => 'Harpertown',
        55 => 'Gainestown',
        56 => 'Westmere-EP',
        72 => 'Tigerton',
        73 => 'Tigerton',
        74 => 'Dunnington',
        'V2' => 'Ivy Bridge',
        'V3' => 'Haswell',
    );

    my ($model, $url, $arch);

    if ($_[0] =~ m/CPU\s*(.*?)\s*@/m) {
        $model = $1;
        $url = "http://ark.intel.com/search?q=$family $model";
        $url =~ s/ /%20/g; # remove spaces (if any) from the model
        if ($model =~ m/^E\d-\d/) { # Sandy Bridge to Haswell
            if ($model =~ m/(V\d)$/) { # Ivy Bridge to Haswell
                $arch = $versions{$1};
            } else { # Sandy Bridge
                $arch = 'Sandy Bridge';
            }
        } elsif ($model =~ m/^[A-Z](\d{2})/) {
            $arch = $versions{$1};
        } else {
            warn "Couldn't indentify processor family (Intel, model $model)\n";
            exit(1);
        }
    } else {
        warn "Couldn't identify processor (suspect Intel $family)\n";
        exit(1);
    }

    return "<a href=\"$url\">$family $model</a> ($arch)";
}

1;

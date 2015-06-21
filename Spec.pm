package Spec;

use strict;
use warnings;

use version; our $VERSION = qv('1.0');

sub cpu {
    my $cpu = `cat /proc/cpuinfo`;
    my ($manufacturer, $family, $model, $cores, $freq);
    if ($cpu =~ m/^model name.*Intel\(R\) (.*)\(/m) {
        require Spec::CPU::Intel;
        Spec::CPU::Intel->import;
        $manufacturer = 'Intel';
        $family = $1;
        if ($family eq 'Celeron') {
            $model = Spec::CPU::Intel::celeron($cpu);
        } elsif ($family eq 'Core') {
            $model = Spec::CPU::Intel::core($cpu);
        } elsif ($family eq 'Xeon') {
            $model = Spec::CPU::Intel::xeon($cpu);
        } else {
            return "Unknown (suspected $manufacturer $family)";
        }
        $cores = Spec::CPU::Intel::getcores($cpu);
        $freq = Spec::CPU::Intel::getfreq($cpu);
    } else {
        return 'No processor detected from /proc/cpuinfo';
    }
    return "$manufacturer $model ${cores}x${freq}";
}

sub memory {
    my $mem = `cat /proc/meminfo`;
    if ($mem =~ m/MemTotal:\s*(\d+)\s*kB/) {
        $mem = sprintf "%.0f", $1 / (1024*1024);
    } else {
        warn "Couldn't work out how much memory this system has from /proc/meminfo :(\n";
        exit(1);
    }
    return "${mem}GB";
}

sub disks {
    use Spec::Disks;
    my $disks_nice;
    my @disks = Spec::Disks::list();
    my %disks;
    foreach (@disks) {
        my ($capacity, $media) = Spec::Disks::type($_);
        $disks{"$capacity $media"}++;
    }
    for my $type (sort keys %disks) {
        my $quantity = $disks{$type};
        $disks_nice .= "${quantity}x${type}, ";
    }
    return substr $disks_nice, 0, -2;
}

sub whatami {
    my $cpu = cpu();
    my $memory = memory();
    my $disk = disks();
    return "<strong>CPU:</strong> $cpu &nbsp; <strong>RAM:</strong> $memory &nbsp; <strong>Disk:</strong> $disk";
}

1;

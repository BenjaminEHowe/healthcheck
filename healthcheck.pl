#!/usr/bin/perl

use strict;
use warnings;

use Spec;
use DiskHealth::SMART;

my $status = 'OK';
my $hostname = `hostname`;
chomp $hostname;
my $whatami = Spec::whatami();
my $uptime = substr `uptime --pretty`, 3;
chomp $uptime;
my $load = join ' ', (split / /, `cat /proc/loadavg`)[0,1,2];
my %SMART_status = DiskHealth::SMART::check();
my $pretty_disk_status = '<ul>';
for my $disk (sort keys %SMART_status) {
    $pretty_disk_status .= '<li>';
    if ($SMART_status{$disk} eq 'good') {
        $pretty_disk_status .= "$disk is good.";
    } elsif ($SMART_status{$disk} eq 'virtual') {
        $pretty_disk_status .= "$disk looks like a virtual disk, ignoring...";
    } else {
        $pretty_disk_status .= "$disk has an issue: $SMART_status{$disk}.";
        $status = 'ERROR';
    }
    $pretty_disk_status .= '</li>';
}
$pretty_disk_status .= '</ul>';
my $HTML = <<"END_MESSAGE";
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Healthcheck: $status ($hostname)</title>
    <style>
        a:visited {color:#00f;}
        body {border:1px solid #aaa; font-family:sans-serif; margin:20px auto; max-width:780px; padding:10px 20px;}
    </style>
</head>
<body>
    <h1 style="text-align:center;">Healthcheck: $status ($hostname)</h1>
    <p style="text-align:center;">$whatami</p>
    <p>Uptime: $uptime.</p>
    <p>Load: $load.</p>
    <h3>Disk status</h3>
    $pretty_disk_status
</body>
</html>
END_MESSAGE

print $HTML;

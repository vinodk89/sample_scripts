#!/usr/bin/perl -w 

use strict;
use warnings 'all';
use Archive::Tar;
use File::Find;
use Data::Dumper;

my $home_dir = "C:/Users/EKMRVND/Documents/sample_scripts/";

chdir $home_dir;

my $src_location = "LOG_DIR";
my $dst_location = $home_dir."file.tar.gz";

# Create inventory of files & directories
my @inventory = ();
find (sub { push @inventory, $File::Find::name }, $src_location);

print Dumper(\@inventory);

# Create a new tar object
my $tar = Archive::Tar->new();

$tar->add_files( @inventory );

# Write compressed tar file
$tar->write( $dst_location , 9 );
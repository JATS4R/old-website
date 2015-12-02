#!/usr/bin/perl

use strict;
use LWP::UserAgent;
use JSON;
use Data::Dumper;

my $debug = 0;
my $ua = LWP::UserAgent->new;
$ua->timeout(10);


my $response = $ua->get(
    'http://jatswiki.org/api.php?' .
    'action=query&' .
    'titles=Attribute_values&' .
    'prop=revisions&' .
    'rvprop=content&' .
    'format=json');

my $content_type = $debug ? 'text/plain' : 'application/json';
print "Content-type: $content_type\n\n";

if (!$response->is_success) {
    die $response->status_line;
}

my $result_json = decode_json $response->decoded_content;
my $pages = $result_json->{query}{pages};
my $page_id = (keys $pages)[0];
my $wiki_content = $pages->{$page_id}{revisions}[0]{'*'};

my @lines = split /\n/, $wiki_content;
my $state = 0;
my $attr_vals = [];
my $current_attr_vals;
my $current_attr_val;
foreach my $line (@lines) {
    print "$line\n" if $debug;
    if ($state == 0) {
        #if ($line =~ s/^\=\=\s*(\w+)\s+values\s*\=\=$/$1/) {
        if ($line =~ s/^\=\=\s*(\S+)\s+values\s*\=\=$/$1/) {
	    print "============> Got attribute '$line'!!\n" if $debug;
	    $current_attr_vals = [];
	    push @$attr_vals, {
	        'name' => $line,
		'values' => $current_attr_vals,
	    };
	    $state = 1;
	}
    }
    elsif ($state == 1) {
        if ($line =~ /<!--/) {
	    print "============> start comment\n" if $debug;
	    $state = 2;
        }
    }
    elsif ($state == 2) {
        if ($line =~ /-->/) {
	    print "============> end comment\n" if $debug;
	    $state = 3;
	}
    }
    elsif ($state == 3) {
        if ($line =~ /^\|-\s*$/) {
	    print "------------> got start of values\n" if $debug;
	    $state = 4;
	}
	elsif ($line =~ /^\|\}/) {
	    $state = 0;
	}
    }
    elsif ($state == 4) {
        $line =~ /.*\|(.*?)\].*/;
	my $v = $1;
	print "-----------> value '$v'\n" if $debug;
        $current_attr_val = {
	    'value' => $v,
	};
	push @$current_attr_vals, $current_attr_val;
	$state = 5;
    }
    elsif ($state == 5) {
        $line =~ /^\|\s*(.*)/;
	my $desc = $1;
	print "----------> desc '$desc'\n" if $debug;
	$current_attr_val->{desc} = $desc;
	$state = 6;
    }
    elsif ($state == 6) {
        $line =~ /^\|\s*\[(\S+)\s+(.*?)\]/;
	my $source_url = $1;
	my $source_name = $2;
	print "----------> source_url '$source_url'; source_name '$source_name'\n" if $debug;
	$current_attr_val->{source_url} = $source_url;
	$current_attr_val->{source_name} = $source_name;
	$state = 7;
    }
    elsif ($state == 7) {
        $line =~ /^\|\s*(.*?)\s*$/;
	my $status = $1;
	print "----------> status '$status'\n" if $debug;
	$current_attr_val->{status} = $status;
	$state = 3;
    }
}

print "========================================\n" if $debug;
print encode_json $attr_vals;

package Hash::Diff;

use strict;
use warnings;
use Carp;
use Hash::Merge;

use base 'Exporter';
use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);

$VERSION     = "0.001";
@EXPORT_OK   = qw( diff left_diff );

use Data::Dump qw/dump/;

sub left_diff {
    my ($h1, $h2) = @_;
    my $rh = {};
    
    print "left_diff: ".dump($h1)." ".dump($h2),"\n";
    
    foreach my $k (keys %{$h1}) {
        print "k: $k\n";
        if (ref $h1->{$k} eq 'HASH') {
            if (ref $h2->{$k} eq 'HASH') {
                print "recursion\n";
                $rh->{$k} = left_diff($h1->{$k}, $h2->{$k});
            }
            else {
                $rh->{$k} = $h1->{$k}                
            }
        }
        elsif ($h1->{$k} ne $h2->{$k}) {
            $rh->{$k} = $h1->{$k}
        }
    }
    
    print "return: ".dump($rh)."\n";
    
    return $rh;

}

sub diff {
    my ($h1, $h2) = @_;
    my $rh = {};
    
    print "diff: ".dump($h1)." ".dump($h2),"\n";
    return Hash::Merge::merge(left_diff($h1,$h2),left_diff($h2,$h1));
    
    foreach my $k (keys %{$h1}) {
        print "k: $k\n";
        if (ref $h1->{$k} eq 'HASH') {
            if (ref $h2->{$k} eq 'HASH') {
                print "recursion\n";
                $rh->{$k} = diff($h1->{$k}, $h2->{$k});
            }
            else {
                $rh->{$k} = $h1->{$k}                
            }
        }
        elsif ($h1->{$k} ne $h2->{$k}) {
            $rh->{$k} = $h1->{$k}
        }
    }
    
    foreach my $k (keys %{$h2}) {
        print "k: $k\n";
        if (ref $h2->{$k} eq 'HASH') {
            if (ref $h1->{$k} eq 'HASH') {
                print "recursion\n";
                $rh->{$k} = Hash::Merge::merge( $rh->{$k}, diff($h2->{$k}, $h1->{$k}));
            }
            else {
                $rh->{$k} = Hash::Merge::merge( $rh->{$k}, $h2->{$k} );                
            }
            # TODO: Merge
        }
        elsif ($h2->{$k} ne $h1->{$k}) {
            $rh->{$k} = $h2->{$k}
        }
    }

    print "return: ".dump($rh)."\n";

    return $rh;
}


1;
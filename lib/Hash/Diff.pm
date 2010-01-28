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
    
    foreach my $k (keys %{$h1}) {
        if (ref $h1->{$k} eq 'HASH') {
            if (ref $h2->{$k} eq 'HASH') {
                $rh->{$k} = left_diff($h1->{$k}, $h2->{$k});
            }
            else {
                $rh->{$k} = $h1->{$k}                
            }
        }
        elsif ((!defined $h2->{$k})||($h1->{$k} ne $h2->{$k})) {
            $rh->{$k} = $h1->{$k}
        }
    }
    
    return $rh;

}

sub diff {
    my ($h1, $h2) = @_;

    return Hash::Merge::merge(left_diff($h1,$h2),left_diff($h2,$h1));
}


1;
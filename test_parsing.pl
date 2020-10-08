use strict;
use warnings;

use Time::Piece;
use Data::Dumper;
use Time::Local;

use feature 'say';

my %data = (
  '1342' => [
			  {
				'Severity' => 'MEDIUM',
				'Node' => 'Node002',
				'State' => 'ACTIVE_UNACKNOWLEDGED',
				'Updated' => '2020-10-01T12:00:00',
				'eventId' => '1342'
			  },
			  {
				'Severity' => 'HIGH',
				'Node' => 'Node002',
				'Updated' => '2020-10-01T12:05:00',
				'eventId' => '1342',
				'State' => 'ACTIVE_UNACKNOWLEDGED'
			  },
			  {
				'Severity' => 'CLEARED',
				'Node' => 'Node002',
				'Updated' => '2020-10-01T12:10:00',
				'eventId' => '1342',
				'State' => 'ACTIVE_UNACKNOWLEDGED'
			  }
			],
  '1341' => [
			  {
				'State' => 'ACTIVE_UNACKNOWLEDGED',
				'eventId' => '1341',
				'Updated' => '2020-10-01T12:10:00',
				'Node' => 'Node001',
				'Severity' => 'HIGH'
			  },
			  {
				'State' => 'ACTIVE_UNACKNOWLEDGED',
				'Updated' => '2020-10-01T12:15:00',
				'eventId' => '1341',
				'Severity' => 'HIGH',
				'Node' => 'Node001'
			  },
			  {
				'State' => 'CLEARED_ACKNOWLEDGED',
				'Updated' => '2020-10-01T12:15:00',
				'eventId' => '1341',
				'Severity' => 'CLEARED',
				'Node' => 'Node001'
			  }
			]
);

foreach my $ev (sort keys %data) { 
	my $ra = $data{$ev}; 

    # Initialize "best" time and its hashref
    my $hr = $ra->[0]; 
	
    my $dt = time_ts( $hr->{Updated} );

	foreach my $idx (1..$#$ra) { 
        my $dt_curr = time_ts( $ra->[$idx]{Updated} );
		
        if ($dt_curr > $dt) {
            $dt = $dt_curr;
            $hr = $ra->[$idx];
        }
        elsif ($dt_curr == $dt) { 
            if ($ra->[$idx]{Severity} eq 'CLEARED') { 
                $dt = $dt_curr;
                $hr = $ra->[$idx];
			}
			
		}
	}   
	say "Event: $hr->{eventId}";
    say "\t", join ',', grep { $_ ne $hr->{eventId} } values %{$hr};
}

sub time_ts {
	
	my $date = shift; 
	
    my ($yyyy, $mm, $dd, $hr, $min, $sec) = ($date =~ /(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)/);
  
    my $epoch_seconds = timelocal($sec, $min, $hr, $dd, $mm, $yyyy);
    return $epoch_seconds;
}

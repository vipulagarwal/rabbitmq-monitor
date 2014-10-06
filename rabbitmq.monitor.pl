#!/usr/bin/perl

# RabbitMQ queue value monitor script - Version 1.0
# This script can be used in mon service level monitoring
# Author: Vipul Agarwal
#
# For latest update, please check the github repository
# available at https://github.com/toxboi/rabbitmq-monitor
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

use IO::Socket::INET; 

my $host = $ARGV[0];
my $port = 4949;

# Change the following values as per requirements
my $qType = "Moreover"; # Queue prefix/keyword 
my $qThresholdValue = 0; # Queue alert threshold value

my $sock = new IO::Socket::INET (
								PeerAddr => $host,
								PeerPort => $port,
								Proto => 'tcp',
								);
die "Could not connect to host $!\n" unless $sock;

print $sock "fetch rabbitmq_messages\n";
my $line;
while ($line = <$sock>) {
	if (index($line, $qType) > -1 ){
		push(@queue, $line);
	}	
}

close($sock);

my $trigger;
foreach (@queue) {
	chomp;	
	my ($qName, $qLength) = split(/ /);
	if($qLength > $qThresholdValue)
	{
		$trigger = 1;
		print "$qName: $qLength\n";
	}
}

if($trigger) {	
	exit 1;
}

exit 0;

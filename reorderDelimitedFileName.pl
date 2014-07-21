#!/usr/bin/perl -w

#Copyright (c) 2014, Stargazy Studios
#All Rights Reserved

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#reorderDelimitedFileName takes a file name, prepended with an optional directory, and 
#a comma separated list of numbers.
#the script breaks up the file name using the "_" delimiter, or an override, and reorders
# the matched components as per the comma separated list of numbers. N.B. the directory 
#path is excluded.
#the file is renamed using the reordered components.

use strict;
use Getopt::Long;
use File::Basename;
use File::Copy 'move';
use Data::Dumper;

my $file = '';
my $order = '';
my $test = '';
my $delimeter = '_';

GetOptions(	'file=s' => \$file,
			'order=s' => \$order,
			'test' => \$test);
			
if(-e $file){
	if($order =~ /([0-9]+,)*[0-9]+/){
		my ($filename,$directory,$suffix) = fileparse($file, qr/\.[^.]*/);
		my @reorder = split(",",$order);
		my @filenameComponents = split($delimeter,$filename);
		
		#DEBUG
		#print Dumper(@reorder);
		#print Dumper(@filenameComponents);
		
		my $newFilename = '';
		for my $i (0 .. $#reorder){
			if($filenameComponents[$reorder[$i]]){
				$newFilename .= $filenameComponents[$reorder[$i]];
			}
		}
		
		my $newFile = $directory.$newFilename.$suffix;
		
		if($test){
			print STDOUT "TEST: $newFile\n";
		}
		else{
			move($file, $newFile);
		}
	}
	else{
		print STDERR "ERROR: \"order\" parameter is not in a comma separated format. EXIT\n";
		exit 1;
	}
}
else{
	print STDERR "ERROR: file $file does not exist. EXIT\n";
	exit 1;
}
	
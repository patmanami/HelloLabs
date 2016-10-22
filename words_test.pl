#!/usr/bin/perl

use strict;
use warnings;
use Encode qw(encode_utf8); # assuming mysql built with utf8
# use Data::Dumper;
use Benchmark; # calculate program time

=pod

=head1 SEQUENCE AND WORD PARSER

Word/pattern/sequence matcher written by Patrick Boggs

=head1 DESCRIPTION

From a dictionary file passed in with a list of words, determine a list of 4 letter sequences that only appear in exactly one word. If the pattern appears twice, that word is not printed. Files are run through a cleaning routine to standardize the file, and outputs are in UTF8.

=head2 USAGE

Program runs on command line as:

perl words_test.pl [optional_dictionary_file.txt]

The program will run as is with a smaller dictionary file, but can take another
dictionary file on the command line

=cut

# Global vars

my $letter_count_min = 4;
my %words            = ();
my %final_patterns   = ();
my $start_time       = Benchmark->new;
my $print_benchmark  = 0;

# Allow for dynamic dictionary file, else default. Clean up the 
# input just in case.

my $input_file = shift;

if($input_file) {
  # Remove any leading or trailing whitespace
  $input_file =~ s/^\s//;
  $input_file =~ s/\s$//;
}

my $dictionary_file           = ($input_file) ? $input_file : 'small.txt';
my $base_dictionary_directory = './dictionary/';
my $full_dictionary_path      = $base_dictionary_directory . $dictionary_file;

# TEST CASE 1
# Confirm there is a valid input file to be used - even if it
# the default file
# if(-e $full_dictionary_path) 

# Read in the dictionary file - die if can't be found
open(FH, "<", $full_dictionary_path) || 
  die "Could not open dictionary file:" . $!;

# Loop through each dictionary word
while(<FH>) {

  chomp; # remove newline

  # skip if blank line
  if (/^$/) {
    # print "blank line found\n";
    next;
  }

  my $word = $_; 

  # Put word through cleaning cycle sub
  $word = &cleanup_word($word);

  # Skip the dictionary word if duplicated 
  # next if ( exists($words{$words} ); # short non-print version
  if( exists($words{$word}) ) {
    next;
  }

  # Check to see if there are at least 4 letters in the word
  # and test against the global minimum
  my $letter_count = length($word);

  # Only let word get used if it is greater than the global minimum
  unless( $letter_count >= $letter_count_min ) {
    next;
  }

  # Store all viable input words; also for duplicate testing
  $words{$word}++;

}

close FH;

#################################################################
# Pattern search
#
# Now that we have a full list of clean words
# go through and find the desired pattern. 
# Multiples are tabulated for exclusions later.
#################################################################

foreach my $testword (keys %words) {
  
   my $length   = length($testword);
   my $loops    = $length - $letter_count_min;

   my @patterns = map{ substr( $testword, $_, 4 ) } 0 .. $loops;
   
   foreach my $pattern (@patterns) {
     $final_patterns{$pattern}{count}++;
     $final_patterns{$pattern}{word} = $testword;
   }

}

#############################
# Produce output for report
#############################

printf("%-15s %-15s\n", '\'sequences\'', '\'words\'');
print "\n";

foreach my $pat (sort keys %final_patterns) {

  # Only print out patterns that had one match 
  # in alphabetical order by the pattern name
  if($final_patterns{$pat}{count} == 1 ) { 
    printf("%-15s %-15s\n", $pat, $final_patterns{$pat}{word});
  }

}

# Benchmark - print if desired
my $end_time   = Benchmark->new;
my $total_time = timediff($end_time, $start_time);

if($print_benchmark) {
  print "\nPARSING TOOK=", timestr($total_time) ,"\n";
}


####################################
# Word manipulation/clean up routine
####################################

=pod

=head1 cleanup_word function

Standardize words before running through parser

What this routine does:

  - standardize case 
  - remove leading and trailing spaces
  - remove punctuation (unknown rule/currently commented out); 
    things like apostrophes unsure to remove or include in test
  - encode as UTF8

=cut

sub cleanup_word {

  my $unclean_word = shift;

  # - standardize case 
  # - remove punctuation (unknown rule); things like apostrophes 
  #   unsure to remove or include in test
  # - remove leading and trailing spaces

  $unclean_word   = lc($unclean_word);
  $unclean_word  =~ s/^\s+//; # remove leading spaces
  $unclean_word  =~ s/\s+$//; # remove trailing spaces

  # promote to clean
  my $clean_word = encode_utf8($unclean_word);

  return $clean_word;

}



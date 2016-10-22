#!/usr/bin/perl

use strict;
use warnings;
use WordRip qw(cleanup_word);

use Test::Simple tests => 2;

# So simple test to check if a word is returned
ok cleanup_word('testword') eq 'testword', 'word returned test'; 

# Check to see if file is lowercased and leading
# & trailing spaces are removed
ok cleanup_word(' TESTWORD ') eq 'testword', 'cleanup working test';

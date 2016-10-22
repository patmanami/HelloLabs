WORDS_TEST(1)            User Contributed Perl Documentation           WORDS_TEST(1)



SEQUENCE AND WORD PARSER
       Word/pattern/sequence matcher written by Patrick Boggs

DESCRIPTION
       From a dictionary file passed in with a list of words, determine a list of 4
       letter sequences that only appear in exactly one word. If the pattern appears
       twice, that word is not printed. Files are run through a cleaning routine to
       standardize the file, and outputs are in UTF8.

   USAGE
       Program runs on command line as:

       perl words_test.pl [optional_dictionary_file.txt]

       The program will run as is with a smaller dictionary file, but can take
       another dictionary file on the command line

cleanup_word function
       Standardize words before running through parser

       What this routine does:

         - standardize case
         - remove leading and trailing spaces
         - remove punctuation (unknown rule/currently commented out);
           things like apostrophes unsure to remove or include in test
         - encode as UTF8



perl v5.14.2                         2016-10-22                        WORDS_TEST(1)

#!/usr/bin/perl -w

## ########################################################################## ##
## Get clipboard content
##
## ########################################################################## ##
## note:
## $0, __FILE__ contains the script name
## module File::Basename contains 'dirname', 'basename' function
## module Cwd 'realpath' function returns the full path

## import modules
use strict;
use warnings;
use Data::Dumper;
use File::Basename;
use Cwd 'realpath';

## constants
#use constant DEBUG => 1;    # ON
use constant DEBUG => 0;    # OFF

## prototypes
#sub say;
#sub dbg;

## globals

## variables

## -------------------------------------------------------------------------- ##
## MAIN
## -------------------------------------------------------------------------- ##
my $num_args = $#ARGV + 1;
if ($num_args != 3) {
  print "\nUsage: $0 [logfile].log [resultlogfile]\n";
  exit;
}

## variables
my $logfile = $ARGV[0];
my $infofile = $ARGV[1];
my $searchpattern = $ARGV[2];
#say ("logfile: $logfile");
#say ("infofile: $infofile");
my @lines;
my @output;

## -------------------------------------------------------------------------- ##
## Read log file
## -------------------------------------------------------------------------- ##
open(FH, "< $logfile") || die "$logfile not found\n";
while(<FH>){ push(@lines,$_);}
close(FH);

## -------------------------------------------------------------------------- ##
## Process log file content
## -------------------------------------------------------------------------- ##
#print "Number of lines:", scalar(@lines), "\n";
my $idx = 0;
my $package;
my $line_to_save="## found package:";
foreach (@lines)
{
  $idx++;
  if ($_ =~ /^$line_to_save/) { $package = $_; }

  if ( $_ =~ m/$searchpattern/ )
  {
    #if ( $1 == "0" ) { next; }
    if ( defined $package && $package ne "") { push( @output, $package); }
    push( @output, "Line $idx: $_");
  }
}

## -------------------------------------------------------------------------- ##
## Write info file
## -------------------------------------------------------------------------- ##
my $separator=
"***************************************************************************\n";

if (scalar(@output))
{
#  print $separator;
#  say ("logfile: $logfile");
#  print @output;

  open (FH, '>>', $infofile);
#  print FH "\n";
#  print FH $separator;
  print FH "## [$logfile]($logfile) \n";
  print FH "```\n";
  print FH @output;
  print FH "```\n";
  close FH;
}

## -------------------------------------------------------------------------- ##
## FUNCTIONS:
## -------------------------------------------------------------------------- ##
sub say { print @_, "\n" }

sub dbg {
  if (DEBUG) {
    my @array =();
    foreach my $string (@_) { push(@array, $string) }

    say "--- DEBUG: ---";
    foreach my $element (@array) {
      say ("Element: $element");
      say (Dumper(eval $element));
    }
    say "--------------";
  }
}

## ########################################################################## ##
exit 0;

__END__

#!/usr/bin/perl -w
=pod
/*PGR-GNU*****************************************************************
File: doc_queries_generator.pl

Copyright (c) 2013-2026 pgRouting developers
Mail: project@pgrouting.org

Function contributors:
  	Celia Virginia Vergara Castillo
  	Stephen Woodbridge
  	Vadim Zhukov
	Nagase Ko

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/
=cut


eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
if 0; #$running_under_some_shell

use strict;
use lib './';
use File::Find ();
use File::Basename;
use Data::Dumper;
use Time::HiRes qw(gettimeofday tv_interval);
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(no_bundling);
Getopt::Long::Configure qw(no_auto_abbrev);

$Data::Dumper::Sortkeys = 1;

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

# TODO automatically get min requirement from CMakeLists.txt
my $PROJECT='pgrouting';
my $POSGRESQL_MIN_VERSION = '13';
my $DOCUMENTATION = 0;
my $DATA = 0;
my $VERBOSE = 0;
my $LEVEL = "NOTICE";
my $FORCE = 0;

my $DBNAME = "___".$PROJECT."_generator___";
my $DBUSER = "";
my $DBHOST = "";
my $DBPORT = "";
my $POSGRES_VER = "";
my $alg = '';
my $psql = '';

sub HelpMessage {
    die "Usage: doc_queries_generator.pl (options)" .
    " --alg 'dir'           - directory to select which algorithm subdirs to test\n" .
    " --pgver version       - postgresql version\n" .
    " [-d|--dbname] name    - database name (default '$DBNAME')\n" .
    " [-h|--host] host      - postgresql host or socket directory to use\n" .
    " [-p|--port] port      - postgresql port to use\n" .
    " [-U|--username] name  - postgresql user role to use\n" .
    " --psql /path/to/psql  - optional path to psql\n" .
    " [-v|--verbose]        - verbose messages of the execution\n" .
    " --data                - only install the sampledata.\n" .
    " [-l|--level] NOTICE   - client_min_messages value. Defaults to $LEVEL. other values can be WARNING, DEBUG3, etc\n" .
    " [-c|--clean]          - dropdb before running.\n" .
    " --documentation|--doc - Generate documentation examples. LEVEL is set to NOTICE\n" .
    " --help                - Show this help\n";
}

print "RUNNING: doc_queries_generator.pl " . join(" ", @ARGV) . "\n";

my @testpath = ("docqueries/");
my @test_directory = ();
my $CLEAN = '';
my $ignore;

my $opts = GetOptions(
    'dbname=s' => \$DBNAME,
    'host|h=s' => \$DBHOST,
    'port|p=i' => \$DBPORT,
    'username|U=s' => \$DBUSER,
    'pgver=s' => \$POSGRES_VER,
    'psql=s' => \$psql,
    'level=s' => \$LEVEL,

    'alg=s' => \$alg,

    'verbose|v' => \$VERBOSE,
    'data' => \$DATA,
    'clean' => \$CLEAN,
    'force' => \$FORCE,
    'help' => sub { HelpMessage() },
    'documentation|doc' => \$DOCUMENTATION,
);

die "An option is wrong" unless $opts;

$alg =~ s/docqueries//;
@testpath = ("docqueries/$alg");
if ($psql ne '') {
    die "'$psql' is not executable!\n" unless -x $psql;
};

# documentation gets NOTICE
$LEVEL = "NOTICE" if $DOCUMENTATION;

my $connopts = "";
$connopts .= " -U $DBUSER" if $DBUSER;
$connopts .= " -h $DBHOST" if $DBHOST;
$connopts .= " -p $DBPORT" if $DBPORT;
print "connection options '$connopts'\n" if $VERBOSE;

%main::tests = ();
my @cfgs = ();
my %stats = (z_pass=>0, z_fail=>0, z_crash=>0, RunTimeTotal=>0);
my $TMP = "/tmp/other-commands-$$";
my $TMP2 = "/tmp/compare-result-$$";

if (! $psql) {
    $psql = findPsql() || die "ERROR: can not find psql, specify it on the command line.\n";
}

my $OS = "$^O";
if (length($psql)) {
    if ($OS =~ /msys/
        || $OS =~ /MSWin/) {
        $psql = "\"$psql\"";
    }
}
print "Operative system found: $OS\n";


createTestDB($DBNAME);

# Load the sample data & any other relevant data files
mysystem("$psql $connopts -A -t -q -f tools/testers/sampledata.sql $DBNAME >> $TMP2 2>\&1 ");

if ($DATA) {exit 0;};

# Find the desired queries files
File::Find::find({wanted => \&want_tests}, @testpath);

die "Error: no queries files found. Run this command from the top path of pgRouting repository!\n" unless @cfgs;


# cfgs = SET of configuration file names
# c  one file in cfgs
print join("\n",@cfgs),"\n" if $VERBOSE;
for my $c (@cfgs) {
    my $found = 0;

    print "test.conf = $c\n" if $VERBOSE;

    # load the config file for the tests
    require $c;

    print Data::Dumper->Dump([\%main::tests],['test']) if $VERBOSE;

    run_test($c, $main::tests{any});
    $found++;

    if (! $found) {
        $stats{$c} = "No files found for '$c'!";
    }
}

print Data::Dumper->Dump([\%stats], ['stats']);

unlink $TMP;
unlink $TMP2;

if ($stats{z_crash} > 0 || $stats{z_fail} > 0) {
    exit 1;  # signal we had failures
}

# SUCCESS: comparison passed or generated results completed
exit 0;


# file  one file in cfgs
# t  contents of array that has keys: comment, data and test
sub run_test {
    my $confFile = shift;
    my $t = shift;

    my $dir = dirname($confFile);

    # There is data to load relative to the directory
    for my $datafile (@{$t->{data}}) {
        mysystem("$psql $connopts -A -t -q -f '$dir/$datafile' $DBNAME >> $TMP2 2>\&1 ");
    }

    for my $file (@{$t->{files}}) {
        process_single_test($file, $dir, $DBNAME);
    }

    # Just in case but its not used for operating system keys
    if ($OS =~/msys/ || $OS=~/MSW/ || $OS =~/cygwin/) {
        for my $x (@{$t->{windows}}) {
            process_single_test($x, $dir, $DBNAME)
        }
    } elsif ($OS=~/Mac/ ||  $OS=~/dar/) {
        for my $x (@{$t->{macos}}) {
            process_single_test($x, $dir, $DBNAME)
        }
    } else {
        for my $x (@{$t->{linux}}) {
            process_single_test($x, $dir, $DBNAME)
        }
    }
}

# file: file to be processed. Example: version.pg
# dir: path of the file. Example: docqueries/version/
# database: the database name: Example: "___$PROJECT_generator___"
# Each query will use clean data

sub process_single_test{
    my $file = shift;
    my $dir = shift;
    my $database = shift;

    (my $filename = $file) =~ s/((\.[^.\s]+)+)$//;
    my $inputFile = "$dir/$file";
    my $resultsFile = "$dir/$filename.result";

    print "Processing $inputFile";
    my $t0 = [gettimeofday];

    # Load the sample data & any other relevant data files
    mysystem("$psql $connopts -A -t -q -f tools/testers/sampledata.sql $DBNAME >> $TMP2 2>\&1 ");

    # QIN = queries input file
    open(QIN, "$inputFile") || do {
        print "\tFAILED: could not open '$inputFile \n";
        $stats{"$inputFile"} = "FAILED: could not open '$inputFile' : $!";
        $stats{z_fail}++;
        return;
    };


    # Processing is handled kinda like a file
    # Where the commands are stored on PSQL file
    # When the PSQL is closed is when everything gets executed

    # Connect to the database with PSQL
    if ($DOCUMENTATION) {
        # For rewriting the results files
        # Do the rewrite or store FAILURE
        open(PSQL, "|$psql $connopts --set='VERBOSITY terse' -e $database > $resultsFile 2>\&1 ") || do {
            $stats{"$inputFile"} = "FAILED: could not open connection to db : $!";
            $stats{z_fail}++;
            next;
        };
    } else {
        # For comparing the result
        # Create temp file with current results
        open(PSQL, "|$psql $connopts  --set='VERBOSITY terse' -e $database > $TMP 2>\&1 ") || do {
            $stats{"$inputFile"} = "FAILED: could not open connection to db : $!";
            $stats{z_fail}++;
            next;
        };
    }

    # Read the whole (input) file into the array @d
    my @queries = ();
    @queries = <QIN>;

    print PSQL "BEGIN;\n";
    print PSQL "SET client_min_messages TO $LEVEL;\n";

    # prints the whole file stored in @queries
    print PSQL @queries;
    print PSQL "\nROLLBACK;";

    # executes everything
    close(PSQL);

    # closes the input file
    close(QIN);

    my $runTime = tv_interval($t0, [gettimeofday]);
    print "\tRun time: $runTime";
    $stats{RunTimeTotal} += $runTime;

    if ($DOCUMENTATION) {
        # convert tabs to spaces
        print "\n";
        my $cmd = q(perl -pi -e 's/[ \t]+$//');
        $cmd .= " $resultsFile";
        mysystem( $cmd );
        return;
    }

    if (! -f "$resultsFile") {
        $stats{"$inputFile"} = "\nFAILED: '$resultsFile` file missing : $!";
        $stats{z_fail}++;
        next;
    }

    # diff ignore white spaces when comparing
    my $originalDiff = `diff -w '$resultsFile' '$TMP' `;

    #looks for removing leading blanks and trailing blanks
    $originalDiff =~ s/^\s*|\s*$//g;
    if ($originalDiff =~ /connection to server was lost/) {
        # when the server crashed
        $stats{"$inputFile"} = "CRASHED SERVER: $originalDiff";
        $stats{z_crash}++;
        # allow the server some time to recover from the crash
        warn "CRASHED SERVER: '$inputFile', sleeping 20 ...\n";
        sleep 20;
    } elsif (length($originalDiff)) {
        # Things changed print the diff
        $stats{"$inputFile"} = "FAILED: $originalDiff";
        $stats{z_fail}++ unless $LEVEL ne "NOTICE";
        print "\t FAIL\n";
    } else {
        $stats{z_pass}++;
        print "\t PASS\n";
    }
}

sub createTestDB {
    print "-> createTestDB\n" if $VERBOSE;

    dropTestDB() if $CLEAN && dbExists();

    my $template;
    my $dbver = getServerVersion();
    my $dbshare = getSharePath($dbver);

    print "-- DBVERSION: $dbver\n-- DBSHARE: $dbshare\n" if $VERBOSE;

    die "
    Unsupported postgreSQL version $dbver
    Minimum requierment is $POSGRESQL_MIN_VERSION version
    Use -force to force the tests\n"
    unless version_greater_eq($dbver, $POSGRESQL_MIN_VERSION) or ($FORCE);

    # Create a database
    mysystem("createdb $connopts $DBNAME") if not dbExists();
    die "ERROR: Failed to create database '$DBNAME'!\n" unless dbExists();

    my $encoding = '';
    if ($OS =~ /msys/ || $OS =~ /MSWin/) {
        $encoding = "SET client_encoding TO 'UTF8';";
    }

    mysystem("$psql $connopts -c \"DROP EXTENSION IF EXISTS $PROJECT\" $DBNAME ");

    print "Installing $PROJECT extension\n" if $VERBOSE;
    mysystem("$psql $connopts -c \"CREATE EXTENSION $PROJECT CASCADE\" $DBNAME");

    # Verify $PROJECT extension was installed

    my $pgrv = `$psql $connopts -c "SELECT pgr_version()" $DBNAME`;
    die "ERROR: failed to install $PROJECT into the database!\n" unless $pgrv;

    print `$psql $connopts -c "SELECT version();" $DBNAME `, "\n";
    print `$psql $connopts -c "SELECT pgr_full_version();" $DBNAME `, "\n";
}

sub dropTestDB {
    mysystem("dropdb $connopts $DBNAME");
}

sub version_greater_eq {
    my ($a, $b) = @_;

    return 0 if !$a || !$b;

    my @a = split(/\./, $a);
    my @b = split(/\./, $b);

    my $va = 0;
    my $vb = 0;

    while (@a || @b) {
        $a = shift @a || 0;
        $b = shift @b || 0;
        $va = $va*1000+$a;
        $vb = $vb*1000+$b;
    }

    return 0 if $va < $vb;
    return 1;
}


sub getServerVersion {
    print "-> getServerVersion\n" if $VERBOSE;

    my $v = `$psql $connopts -q -t -c "select version()" postgres`;
    print "$psql $connopts -q -t -c \"select version()\" postgres\n    # RETURNED: $v\n" if $VERBOSE;
    if ($v =~ m/PostgreSQL (\d+(\.\d+)?)/) {
        my $version = $1 + 0;
        print "    Got: $version\n" if $VERBOSE;
        $version = int($version) if $version >= 12;
        print "    Got: $version\n" if $VERBOSE;
        return $version;
    }
    return undef;
}

sub dbExists {
    my $isdb = `$psql $connopts -l | grep ' $DBNAME '`;
    $isdb =~ s/^\s*|\s*$//g;
    return length($isdb);
}

sub findPsql {
    my $psql = `which psql`;
    $psql =~ s/^\s*|\s*$//g;
    print "which psql = $psql\n" if $VERBOSE;
    return length($psql)?$psql:undef;
}

# getSharePath is complicated by the fact that on Debian we can have multiple
# versions installed in a cluster. So we get the DB version by connection,
# to the port for the server we want. Then we get the share path for the
# newest version od pg installed on the cluster. And finally we change the
# in the path to the version of the server.

sub getSharePath {
    my $pg = shift;

    my $share;
    my $isdebian = -e "/etc/debian_version";
    my $pg_config = `which pg_config`;
    $pg_config =~ s/^\s*|\s*$//g;
    print "which pg_config = $pg_config\n" if $VERBOSE;
    if (length($pg_config)) {
        $share = `"$pg_config" --sharedir`;
        $share =~ s/^\s*|\s*$//g;
        if ($isdebian) {
            $share =~ s/(\d+(\.\d+)?)$/$pg/;
            if (length($share) && -d $share) {
                return $share;
            }
        } else {
            return "$share"
        }
    }
    die "Could not determine the postgresql version" unless $pg;
    $pg =~ s/^(\d+(\.\d+)).*$/$1/;
    $share = "/usr/share/postgresql/$pg";
    return $share if -d $share;
    $share = "/usr/local/share/postgresql/$pg";
    return $share if -d $share;
    die "Could not determine the postgresql share dir for ($pg)!\n";
}

sub mysystem {
    my $cmd = shift;
    print "$cmd\n" if $VERBOSE;
    system($cmd);
}

sub want_tests {
    /^test\.conf\z/s && push @cfgs, $name;
}

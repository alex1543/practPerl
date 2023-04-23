#!perl

# в переменную окружения Path добавить, например: C:\Strawberry\perl\bin\
print "Content-type: text/html; charset=utf-8\n\n";
open FILE, "head.inc" or die $!;
print <FILE>;

use DBI;
my $host = "localhost";
my $port = "3306";
my $user = "root";
my $pass = "";
my $db = "test";
$dbh = DBI->connect("DBI:mysql:$db:$host:$port",$user,$pass);
$sth = $dbh->prepare("SET NAMES utf8");
$sth->execute;

# обработка параметров формы.
if($ENV{'REQUEST_METHOD'} eq 'GET') {
	$query=$ENV{'QUERY_STRING'};
} elsif($ENV{'REQUEST_METHOD'} eq 'POST') {
	sysread(STDIN,$query,$ENV{'CONTENT_LENGTH'});
}
@pairs = split(/&/, $query);
foreach $pair (@pairs) {
    ($name, $value) = split(/=/, $pair);
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex())/eg;
    $value =~ s/<!--(.| )*-->//g;
    $input{$name} = $value;
}
if ($input{'delid'} ne "") {
	$sth = $dbh->prepare("DELETE FROM files WHERE id_my = ".$input{'delid'});
	$sth->execute;
	$sth = $dbh->prepare("DELETE FROM myarttable WHERE id = ".$input{'delid'});
	$sth->execute;
}
if ($input{'textId'} ne "") {
	$sth = $dbh->prepare("UPDATE myarttable SET text='".$input{'textEd1'}."', description='".$input{'textEd2'}."', keywords='".$input{'textEd3'}."' WHERE id = ".$input{'textId'});
	$sth->execute;
}
# кон. обработки.


print "\n<table class='tView1'>\n";


$sth = $dbh->prepare("SELECT * FROM myarttable WHERE id>14 ORDER BY id DESC;");
$sth->execute;
while ($ref = $sth->fetchrow_arrayref) {
	print "<tr>\n";
	for (my $i=0; $i <= $#$ref; ++$i) {
		print "<td title='Edit'>\n<a href='#' class='js-open-modal' data-modal='1' id=\'id".$i."_".$$ref[0]."'>$$ref[$i]</a></td>\n";
	}
	print "<td class='cellDel' title='Delete'><a href='index.pl?delid=".$$ref[0]."'><img src='image/delete.png'></a></td>\n";

	print "</tr>\n";

}
$rc = $sth->finish;
$rc = $dbh->disconnect;

print "</table>";

open FILE, "foot.inc" or die $!;
print <FILE>;
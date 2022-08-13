#! C:/xampp/perl/bin/perl.exe

print " Enter Name : ";
chomp($name=<STDIN>);
print " Enter Age : ";
chomp($age=<STDIN>);

use DBI;

$dbh=DBI->connect('DBI:mysql:test');

$insert="insert into myarttable values ('$name',$age)";
$d=$dbh->prepare($insert);
$d->execute();

$s="select * from myarttable";
$s1=$dbh->prepare($s);
$s1->execute();

while(@v=$s1->fetchrow_array)
{
    print "$v[0] \t $v[1] \n";
}

$dbh->disconnect();
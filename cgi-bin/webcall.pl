#!/usr/bin/perl
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;
use warnings;
use MiddleLayer;

#----------------------------------------------
# parameterise URIs to allow local machine development

# -- production server 
my $cgiHome = "http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/gseed01";
my $webHome = "http://student.cryst.bbk.ac.uk/~gseed01/web";

# -- local test server
#my $cgiHome = "http://localhost/cgi-bin/hgeorg02";
#my $webHome = "http://localhost/chromo9";

my $cgi = new CGI;
my $cmd = $cgi->url_param('cmd');

if ($cmd eq "search") {
Search();
} elsif ($cmd eq "summary") {
Summary();
} elsif ($cmd eq "details") {
Details();
}

#-------------------------------
 
sub Details
{
my $id = $cgi->param('id');
my $nucleotides = RenderNucleotides($id);
my $results = GetListByID($id);
my $frequency = GetFrequency($id);

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>You successfully looked for gene $id</p>
	<p>The protein products are:
	<p>$results</p>
	<p>The nucleotide sequence is below, with exons indicated and translated, followed by codon frequency information below:</p>
</section>
<section>
	$nucleotides
</section>
</br>
<section>
	$frequency
</section>
</body>
</html>
EOF
}

sub Search
{
	my $searchString = $cgi->param('search');
	my $searchOption = $cgi->param('type');
	if ($searchOption eq "ID") {
		SearchID($searchString, $searchOption);
	} elsif ($searchOption eq "N") {
		SearchN($searchString, $searchOption);
	} elsif ($searchOption eq "ACC") {
		SearchACC($searchString, $searchOption);
	} elsif ($searchOption eq "LOC") {
		SearchLOC($searchString, $searchOption);
	}
}

sub SearchID
{
my $searchString = $_[0];
my $searchOption = $_[1];
my $results = GetListByID($searchString);

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<p>$results</p>
</section>
</body>
</html>
EOF
}

sub SearchN
{
my $searchString = $_[0];
my $searchOption = $_[1];
my $results = GetListByN($searchString);

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<p>$results</p>
</section>
</body>
</html>
EOF
}

sub SearchACC
{
my $searchString = $_[0];
my $searchOption = $_[1];
my $results = GetListByACC($searchString);

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<p>$results</p>
</section>
</body>
</html>
EOF
}

sub SearchLOC
{
my $searchString = $_[0];
my $searchOption = $_[1];
my $results = GetListByLOC($searchString);

print $cgi->header();
print <<EOF;
<html>
<head>
<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>Here is a list of genes generated using your search term ($searchString).</p>
	<p>This search looked through $searchOption.</p>
	<p>$results</p>
</section>
</body>
</html>
EOF
}

sub Summary
{
my $request = $cgi->url_param('cmd');
my $results = GeneList();

print $cgi->header();
print <<EOF;
<html>
<head>
	<link rel='stylesheet' type='text/css' href='$webHome/home2.css'/>
</head>
<body>
<container></container>
<header>
	<HeaderText>Chromosome Explorer</HeaderText>
</header>
<nav>
	<p><a href="$webHome/index.html">Return to home page?</a></p>
	<p><a href="#">Chromosome list.</a></p>
</nav>
<section>
	<p>The following is a summary of all the genes found in the Chromosome 9 genbank data dump.</p>
</section>

<section>
	$results
</section>
</body>
</html>
EOF
}

#---------------------------------------------

sub RenderTable
{
	my $genes = $_[0];
	my $html = "<table><th>Gene ID</th><th>Name</th><th>Accession Number</th><th>Location</th>";
	foreach my $row (@{$genes}) {
		my ($ID, $N, $ACC, $LOC) = @{$row};
	 	$html .= "<tr><td><a href='$cgiHome/webcall.pl?cmd=details&id=$ID'>$ID</a></td><td>$N</td><td>$ACC</td><td>$LOC</td></tr>";
	}
	$html .= "</table>";
	
}

sub GetNucleotides
{
	my $id = $_[0];
	my $dna = ReadNucleotides($id);
	foreach my $row (@{$dna}){
		my ($seq) = @{$row};
		return $seq;
	} 
}

sub GetExons
{
	my $id = $_[0];
	my $exons = ReadExons($id);
	@$exons = sort {$b->[1] <=> $a->[1] || $b->[2] <=> $a->[2] } @$exons;
	return $exons;
}

sub RenderNucleotides
{
	my $id = $_[0];
	my $dna = GetNucleotides($id);
	my $ruler = Ruler($dna);
	my $len = length($dna);
	my $exons = ExtractExons($dna,GetExons($id));
	my $translated = TranslateExons($exons);
	# $exons =~ tr/ACGT./....E/;
	my $html = "<table class='DNA'>";
	$html .= "<tr><td><pre>Ruler</pre></td></tr><tr><td><pre>Nucleotide Sequence</pre></td></tr><tr><td><pre>Coding Regions</pre></td></tr><tr><td><pre>Amino Acid Sequence</pre></td></tr>";
	for (my $i=0; $i<$len; $i+=100) {
		$html .= "<tr><td><pre></pre></td></tr>";
		my $str = substr($ruler,$i,100);
		$html .= "<tr><td><pre>$str</pre></td></tr>";
		$str = substr($dna,$i,100);
		$html .= "<tr><td><pre>$str</pre></td></tr>";
		$str = substr($exons,$i,100);
		$html .= "<tr><td><pre>$str</pre></td></tr>";
		$str = substr($translated,$i,100);
		$html .= "<tr><td><pre>$str</pre></td></tr>";
	}
	$html .= "</table>";
	return $html;	
}

sub Percent
{
	my ($value, $total) = @_;
	return (sprintf("%5.2f\%", $total == 0 ? 0 : 100.0*$value/$total)); 
}

sub GetFrequency
{
	my $id = $_[0];
	my $dna = GetNucleotides($id);
	my $exons = ExtractExons($dna,GetExons($id));
	my $freq = CodonFrequencies($exons);
	my @keys = sort { $freq->{$b} <=> $freq->{$a} || AminoAcid($a) cmp AminoAcid($b) || $a cmp $b } keys(%$freq);
	my $total = 0;
	my %totals;
	($total+=$_) for (values(%$freq));
	($totals{AminoAcid($_)}=0) for (keys(%$freq));
	($totals{AminoAcid($_)}+=$freq->{$_}) for (keys(%$freq));
	
	
	my $frequency = "<table class='DNA'><tr><td>Codon</td><td>AA</td><td>Freq</td><td>Ratio</td></tr>";
	my $i = 0;
	$frequency .= "<tr>";
	for my $k1 (("A","C","G","T")) {
		for my $k2 (("A","C","G","T")) {
			for my $k3 (("A","C","G","T")) {
				my $key = $k1.$k2.$k3;
				my $val= $freq->{$key};
				my $aa = AminoAcid($key);
				my $aaTotal = $totals{$aa};
				my $pct = Percent($val, $total);
				my $ratio = Percent($val, $totals{$aa});
				
				$frequency .= "<td>$key</td><td>$aa</td><td>$pct</td><td>$ratio</td>";
				$i++;
				if (($i%4)== 0) {
					$frequency .= "</tr><tr>";
				}
			}
		}
	}
#	foreach my $key (@keys){
#		my $val= $freq->{$key};
#		my $aa = AminoAcid($key);
#		my $aaTotal = $totals{$aa};
#		my $pct = Percent($val, $total);
#		my $ratio = Percent($val, $totals{$aa});
#		
#		$frequency .= "<td>$key = $aa</td><td>$pct%</td><td>$ratio%</td>";
#		$i++;
#		if (($i%4)== 0) {
#			$frequency .= "</tr><tr>";
#		}
#	}
	$frequency .= "</tr>";
	$frequency .= "</table>";
	return $frequency;
}

sub GeneList
{
	my $genes = ReadGenes();
	my $html = RenderTable($genes);
	return $html;	
}

sub GetListByID
{
	my $searchID = $_[0];
	my $genes = ReadListByID($searchID);
	my $html = RenderTable($genes);
	return $html;	
}

sub GetListByN
{
	my $searchN = $_[0];
	my $genes = ReadListByN($searchN);
	my $html = RenderTable($genes);
	return $html;	
}

sub GetListByACC
{
	my $searchACC = $_[0];
	my $genes = ReadListByACC($searchACC);
	my $html = RenderTable($genes);
	return $html;	
}

sub GetListByLOC
{
	my $searchLOC = $_[0];
	my $genes = ReadListByLOC($searchLOC);
	my $html = RenderTable($genes);
	return $html;	
}


#!/usr/bin/perl
use strict;
use Data::Dumper;
sub gcc{
my ($gc,$i,$seq_gc);
my $c=0;
my $length_of_seq=length(@_[0]);
while ($i < $length_of_seq) {
	 $seq_gc=substr(@_[0],$i,1);
	 $i++;
	 if ($seq_gc eq "G" or $seq_gc eq "C"){
	 $c++;
	}
}
$gc=sprintf("%.2f",($c/$length_of_seq));
}
(@ARGV == 3) || die "Usage: perl $0 <mipred_result.txt> <mfe_to_filter> <out_dir>\n";
my ($mipred,$mfe_to_filter,$out_dir)=@ARGV;
`mkdir -p $out_dir\n`;
open (OUT1,">$out_dir/selected_mipred.xls") || die $!;
open (OUT2,">$out_dir/selected_mipred.fa") || die $!; 
print OUT1 "Sequence_Name\tSequence_Content\tLength\tThe_Secondary_Structure\tMFE\tPrediction confidence\tp-value\tgc-content\n";
open (MIPR,$mipred) || die $!;
my ($seq_nm,$seq_anno,$seq_ct,$lth,$pre_like,$sec_str,$mfe,$pre_result,$p_value,$p_confidence);
$/="Sequence Name";
<MIPR>;
while (<MIPR>){
	chomp;
	my @arr=split /\n/;
	$mfe=(split /\s+/,$arr[5])[-1];
	if($arr[3]=~/Yes/ && $mfe<$mfe_to_filter){
		$seq_nm=(split /\s+/,$arr[0])[-1];
		$seq_ct=(split /\s+/,$arr[1])[-1];
    $lth=(split /\s+/,$arr[2])[-1];
    $pre_like=(split /\s+/,$arr[3])[-1];            
    $sec_str=(split /\s+/,$arr[4])[-1];                                        
    $p_value=(split /\s+/,$arr[6])[-1];
    $pre_result=(split /\s+/,$arr[7])[-1];
    $p_confidence=(split /:/,$arr[8])[-1];
		print OUT1 join("\t",$seq_nm,$seq_ct,$lth,$sec_str,$mfe,$p_confidence,$p_value,gcc($seq_ct)),"\n";
		print OUT2 ">$seq_nm\n$seq_ct\n";
	}else{
		next;
		}
}     

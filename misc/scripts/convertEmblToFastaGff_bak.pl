#! /usr/bin/perl 

use Bio::Seq;
use Bio::SeqIO;

$seqin = Bio::SeqIO->new( -format => 'EMBL' , -file => 'test.embl.reordered');
$seqout= Bio::SeqIO->new( -format => 'Fasta', -file => '>test.embl.reordered.fa');
#$CDSseqout= Bio::SeqIO->new( -format => 'Fasta', -file => '>TE_CDS.fa');
#$LTRseqout= Bio::SeqIO->new( -format => 'Fasta', -file => '>TE_LTR.fa');

while(my $seqobj = $seqin->next_seq()) { 
	
	#$name = $seqobj->display_id().".embl";
	#$EMBLout= Bio::SeqIO->new( -format => 'EMBL', -file => ">$name");
	#$EMBLout->write_seq($seqobj);

	print "Processing sequence ",$seqobj->display_id(),", start of seq ", substr($seqobj->seq,1,10),"\n";
	
	$seqout->write_seq($seqobj);
	print ">", $seqobj->display_id(), "\n";
	print $seqobj->seq()."\n";

	if( $seqobj->alphabet eq 'dna') {	
		#$whole_seq = $seqobj->seq();

		foreach $feat ($seqobj->get_SeqFeatures()) {	
		
			
			print $feat->primary_tag."\n";
			foreach $tag ( $feat->get_all_tags() ) {
						#print $feat->get_tag_values("db_xref"),"\n" if ($feat->has_tag("db_xref"));

                     #  print $feat->primary_tag." has tag ", $tag, " with values: ", join("\n ",$feat->get_tag_values($tag)), "\n";
                   }
			#$annseq->add_SeqFeature($feat);

			if( $feat->primary_tag eq 'CDS' ) 
			{
				$id  = $seqobj->display_id();
				$id = $id."_".$feat->primary_tag;

				$feat_seq = Bio::Seq->new( -seq => substr($seqobj->seq, $feat->start-1, ($feat->end-($feat->start-1))));

				$feat_seq->display_id($id);

				$CDSseqout->write_seq($feat_seq);
			}
			
			if ($feat->has_tag("db_xref") ) {
			
			#elsif(  ($feat->get_tag_values("db_xref") =~ /five_prime_LTR/) ) 

			#if( ($feat->primary_tag eq 'repeat_unit') && ($feat->get_tag_values("db_xref") =~ /five_prime_LTR/) ) 
			
			@test=$feat->get_tag_values("db_xref");
			foreach $tag (@test)  { 
				if ($tag =~ /three_prime_LTR/){
				
				$id  = $seqobj->display_id();
				$id = $id."_".$feat->primary_tag."_".($feat->end-$feat->start+1);

				#$feat_seq = Bio::Seq->new( -seq => substr($seqobj->seq, ($feat->start - 1), ($feat->end-($feat->start-1))));
				$feat_seq = Bio::Seq->new( -seq => substr($seqobj->seq, 1, ($feat->start - 1)));
				$feat_seq->display_id($id);
				
				$LTRseqout->write_seq($feat_seq);
				}
			}
			
			#  repeat_unit has tag db_xref with values: SO:0000425; five_prime_LTR

			
		
		}
	}
	}
}


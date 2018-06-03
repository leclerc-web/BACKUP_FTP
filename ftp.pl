# INSTALLATION MODULE --> cpan "module name"
# EXEMPLE --> cpan Array::Diff


use warnings;
use strict;
# MODULE FTP
use Net::FTP::File;
# MODULE COMPARAISON ARRAY
use Array::Diff;
use Array::Compare;
# EQUIVALENT VAR_DUMP()
use Data::Dumper;

my ($directory) = $ARGV[0];
my ($host) = $ARGV[1];
my ($user) = $ARGV[2];
my ($pass) = $ARGV[3];


# CONNEXION
my $ftp = Net::FTP->new($host, Debug => 1, Timeout => 20)
or die "Impossible de se connecter à l'hôte : $@";
  
$ftp->login($user, $pass)
or die "Impossible de s'identifier : ".$ftp->message;
	  
	  

 
if (not defined $directory) {

	die "ERROR";
  
}else{

	my @ls = $ftp->ls($directory)
	  or warn $ftp->message; 

	my @ls_maj = $ftp->ls($directory.'WP_MAJ')
	  or warn $ftp->message; 
	  
	  
	# ###################################################################### AFFICHAGE
	# foreach my $elt (@ls) {
		# print $elt."\n";
	# }

	# print "\n";
	# print "*"x40;
	# print "\n";

	# foreach my $elt_maj (@ls_maj) {
		# print $elt_maj."\n";
	# }


	# ON COMPARE LES DEUX LISTES POUR SAVOIR SI IL Y A DES DIFFERENCE
	# my $diff = Array::Compare->new;

	# if($diff->compare(\@ls, \@ls_maj)){
		# print "Arrays identiques\n";	
	# }else{
		# print "Arrays différents\n";
	# }
	# ###################################################################### FIN TEST



	# COMPARAISON DES DEUX LISTES  
	# HACH
	my %temp;

	# HACH DE LA LISTE ls_maj# ON LISTE LES VALEURS "NOM FICHIER" DE WP_MAJ
	# 0.. ON PART DE 0 DONC PREMIERE CLE, CONCATENATION AVEC "." PUIS ON UTILISE L'OPERATEUR "." QUI PERMET DE METTRE DEUX CHAINES BOUT A BOUT.
	# $#ls_maj reprend la clé la plus grand de la liste
	@temp{@ls_maj} = 0..$#ls_maj;

	# QUEL FICHIERS EST PRESENT OU NON DANS LE DOSSIER CIBLE
	# ON LISTE LES VALEURS DU REPERTOIRE RACINE
	for my $val(@ls) {

		# SI LES FICHIERS DE WP_MAJ EXISTENT A LA RACINE
		if( exists $temp{$val} ) {
		
			#print "$val est present dans WP_MAJ a la position $temp{$val}.\n";
			
			$ftp->cwd($directory) or die "Cannot go : ".$ftp->message;
			
			# MIGRATION FICHIERS IDENTIQUES RACINE VERS DOSSIER ANCIEN
			print $ftp->rename($val, "ANCIEN/$val"). "$val Est deplace dans ANCIEN.\n";
			
			# MIGRATION DES FICHIERS NEUF VERS LA RACINE
			print $ftp->rename("WP_MAJ/$val", $directory."$val"). "$val Est deplace a la racine.\n";
			print "\nLa mise a jour est terminee ! \n\n";
			
		}else{
		
		  print "*"x10 ."le fichier $val ne sera pas deplace.\n";
		  
		}
		
	}

}

########################################################################## RESET
  
print "Est-ce que tout c est bien passe ? (o/n) : ";

# PREND EN COMPTE LA FRAPPE AU CLAVIER ET NON @ARGV
my $terminer = <STDIN>; 
chomp $terminer;


if (defined $directory) {

	my @ls = $ftp->ls($directory)
	  or warn $ftp->message; 
	  
	my @ls_ancien = $ftp->ls($directory.'ANCIEN')
	  or warn $ftp->message; 
	  
	  
	if($terminer eq "o"){
		
		system("cls");
		print "Parfait !";
		system("pause");
		
	}elsif($terminer eq "n"){
		
		my %temp2;

		@temp2{@ls_ancien} = 0..$#ls_ancien;

		for my $val2(@ls) {
			
			if( exists $temp2{$val2} ) {

				$ftp->cwd($directory) or die "Cannot go : ".$ftp->message;
				
				# RENVOI DES FICHIERS RACINE VERS WP_MAJ
				print $ftp->rename($val2, "WP_MAJ/$val2"). "$val2 Est remis dans WP_MAJ.\n";
				
				# RENVOI DES FICHIERS ANCIEN VERS RACINE
				print $ftp->rename("ANCIEN/$val2", $directory."$val2"). "$val2 Est deplace de ANCIEN a la RACINE.\n";

				system("cls");
				
				print "Fichiers retablis \n";
				
			}
		}
	}

<>; 

system("cls");

}










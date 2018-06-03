@echo off

REM		INSTALL 7z.exe
REM		INSTALL wget.exe
REM		INSTALL wput.exe


@rem --------------- VOS PARAMETRES FTP ----------------
set /p ftp_name=Donnez un nom a votre dossier de reception :
set /p ftp_host=Adresse de votre serveur FTP :
set /p ftp_user=Nom d utilisateur FTP :
set /p ftp_pass=Mot de passe FTP :


echo.

echo 1 : BACKUP			
echo 2 : TRANSFERT

echo.

:debut

set /p choix= fais ton choix : 
( 
if not %choix%=='' set choix=%choix:~0,1% 
if %choix%==1 goto BACKUP
if %choix%==2 goto TRANSFERT
) 
goto debut 


REM ********************`************************************************************************

:BACKUP

set /p ftp_dir=Repertoire a sauvegarder (/*) :


set Annee=%DATE:~6,4%
set Mois=%DATE:~3,2%
set Jour=%DATE:~0,2%
set Heure=%TIME:~0,2%
set Minutes=%TIME:~3,2%
set Secondes=%TIME:~6,2%
if %Heure% LSS 10 set Heure=0%TIME:~1,1%


Set File_name_ftp=%ftp_name%%Annee%%Mois%%Jour%%Heure%%Minutes%%Secondes%.zip


REM RECUPERATION FICHIERS
wget -r ftp://%ftp_user%:%ftp_pass%@%ftp_host%%ftp_dir%

REM COMPRESSION DES FICHIERS
7z.exe a -tzip %File_name_ftp% -r %ftp_host%\*.*

REM SUPPRESSION DU DOSSIER QUI A ETE COMPRESSE.
rmdir /S /Q %ftp_host%

@echo Sauvegarde Termine !
goto end


REM ********************************************************************************************

:TRANSFERT

REM SELECTION DU FICHIER A DEZIPPER
set /p unzip=Veuillez faire glisser le fichier a decompresser ici :

REM ON DEZIP
7z.exe x "%unzip%" -o"C:\Users\Moi\Desktop\BACKUP_FTP"  -y

cd C:\Users\Moi\Desktop\BACKUP_FTP

REM ON RENOMME LE DOSSIER WORDPRESS
REN "wordpress" "WP_MAJ"

REM SUPPRESSION WP-CONTENT AINSI QUE FICHIERS ET SOUS DOSSIER
rmdir C:\Users\Moi\Desktop\BACKUP_FTP\WP_MAJ\wp-content /s /q
del C:\Users\Moi\Desktop\BACKUP_FTP\WP_MAJ\license.txt 
del C:\Users\Moi\Desktop\BACKUP_FTP\WP_MAJ\readme.html 

REM RECEPTION DES ANCIENS FICHIERS SERVEURS
MKDIR ANCIEN
cd ANCIEN
echo Ce fichier doit être supprimé >> A_SUPPRIMER.txt
cd ..

REM REPERTOIRE QUI RECEPTIONNE LES FICHIERS
set /p ftp_dir=Repertoire d envoi du fichier (/www/) :

REM RECUPERATION FICHIERS SENSIBLES
wget   ftp://%ftp_user%:%ftp_pass%@%ftp_host%%ftp_dir%/.htaccess
wget   ftp://%ftp_user%:%ftp_pass%@%ftp_host%%ftp_dir%/wp-config.php

REM DEPLACEMENT DES FICHIERS SENSIBLES
MOVE "C:\Users\Moi\Desktop\BACKUP_FTP\.htaccess" "C:\Users\Moi\Desktop\BACKUP_FTP\WP_MAJ"
MOVE "C:\Users\Moi\Desktop\BACKUP_FTP\wp-config.php" "C:\Users\Moi\Desktop\BACKUP_FTP\WP_MAJ"

REM ENVOI SUR LE FTP
wput WP_MAJ  ftp://%ftp_user%:%ftp_pass%@%ftp_host%%ftp_dir%
wput ANCIEN  ftp://%ftp_user%:%ftp_pass%@%ftp_host%%ftp_dir%

REM SUPPRESSION DOSSIERS ENVOYES
rmdir C:\Users\Moi\Desktop\BACKUP_FTP\ANCIEN /s /q
rmdir C:\Users\Moi\Desktop\BACKUP_FTP\WP_MAJ /s /q

REM LANCEMENT DU SCRIPT PERL AVEC ARGUMENT
perl ftp.pl %ftp_dir% %ftp_host% %ftp_user% %ftp_pass%

REM TERMINER
goto end

REM *******************************************************************************************


:end

echo Appuyer sur ENTREE pour revenir au menu
pause
cls
C:\Users\Moi\Desktop\BACKUP_FTP\backup.bat
pause >nul


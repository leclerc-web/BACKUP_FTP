@echo off

REM		INSTALL 7z.exe
REM		INSTALL wget.exe
REM		INSTALL wput.exe


REM CONNEXION INITIALISATION
set /p ftp_host=Adresse du serveur :
set /p ftp_user=ID du serveur :
set /p ftp_pass=Mot de passe serveur :

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


REM *****************************************************************************************************

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


@rem Récupération des fichiers
wget -r ftp://%ftp_user%:%ftp_pass%@%ftp_host%%ftp_dir%

@rem Compression des fichiers
7z.exe a -tzip %File_name_ftp% -r %ftp_host%\*.*

@rem Suppression du répertoire qui à été compresse.
rmdir /S /Q %ftp_host%

@echo Sauvegarde Termine !
goto end


REM *****************************************************************************************************

:TRANSFERT

set /p ftp_dir=Repertoire d envoi du fichier (/www/) :
set /p name_file=Nom du fichier a upload :

wput %name_file% ftp://%ftp_user%:%ftp_pass%@%ftp_host%%ftp_dir%
goto end

REM //////////////////////////////////////////////////////////////////////////
:end

echo Appuyer sur ENTREE pour revenir au menu
pause
cls
C:\Users\Moi\Desktop\BACKUP_FTP\backup.bat
pause >nul


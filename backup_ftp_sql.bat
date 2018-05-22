@rem ---------------------------------------------------------------
@rem ------ BACKUP EXEMPLE BY WAKDEV.COM -------
@rem ---------------------------------------------------------------
cls
@echo off

@rem ---- VOS PARAMETRES BASE DE DONNEES -----
set db_host=""
set db_user=""
set db_pass=""
set db_name=""

@rem --------------- VOS PARAMETRES FTP ----------------
set ftp_name=""
set ftp_host=""
set ftp_user=""
set ftp_pass=""
set ftp_dir=/*




set Annee=%DATE:~6,4%
set Mois=%DATE:~3,2%
set Jour=%DATE:~0,2%
set Heure=%TIME:~0,2%
set Minutes=%TIME:~3,2%
set Secondes=%TIME:~6,2%
if %Heure% LSS 10 set Heure=0%TIME:~1,1%

Set File_name_db=%db_name%%Annee%%Mois%%Jour%%Heure%%Minutes%%Secondes%.sql
Set File_name_ftp=%ftp_name%%Annee%%Mois%%Jour%%Heure%%Minutes%%Secondes%.zip

@rem Récupération de la base de donnée
mysqldump.exe -h %db_host% -u %db_user% -p%db_pass% --complete-insert --create-options --add-drop-table %db_name% > %File_name_db%

@rem Récupération des fichiers
wget -r ftp://%ftp_user%:%ftp_pass%@%ftp_host%%ftp_dir%

@rem Compression des fichiers
7z.exe a -tzip %File_name_ftp% -r %ftp_host%\*.*

@rem Suppression du répertoire qui à été compresser 
rmdir /S /Q %ftp_host%

@echo Sauvegarde Terminer !
pause


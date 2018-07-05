set PERL_PATH=d:\software\strawberry-perl
set FIREFOX_PATH=d:\software\FirefoxPortable
set UID=1111111

set PATH=%PERL_PATH%\perl\site\bin;%PERL_PATH%\perl\bin;%PERL_PATH%\c\bin;%PATH%
set TERM=
set PERL_JSON_BACKEND=
set PERL_YAML_BACKEND=
set PERL5LIB=
set PERL5OPT=
set PERL_MM_OPT=
set PERL_MB_OPT=

perl weibo_backup_windows.pl %UID% %FIREFOX_PATH%

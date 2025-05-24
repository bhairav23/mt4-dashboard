@echo off
setlocal
set "source=C:\mt4-dashboard\WriteAccountDataToFile.ex4"

echo Source file: %source%
if not exist "%source%" (
    echo ERROR: Source file does not exist!
    pause
    exit /b
)

:: List of target directories
for %%D in (
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\5D49F47D1EA1ECFC0DDC965B6D100AC5\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\6D8ED79B81D9D70041DDDF6786110ECE\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\704444BB97FFEAFF0FAD48FB79A73215\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\76F5A6AB6C9C072B94A014923F71D84B\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\349660BDC5434569AF7F02E030543070\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E12F3A14E347150B250E1402A9152A0F\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\3180B5E116E0F562B6C7D5D65BE86282\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\177D69421667C0D054D717B4BA1179DF\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\8FC18F4CDCD4D41BB8774202824CB7B8\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\5C4FC43F43DE4E49F5AB4ECD5B2988AC\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\7E3397ECF4F42954AC1976AD5CF50931\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\11D0BEBBEAA63FB82CB4040F79DEE8B3\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\55C1A8D08858E57EA6A080170A23C6D1\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\B686031306FA71A7EDC549C88C8E2CE7\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\BCDF3193997AF4A518724582ACF4E5D3\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\967EEDCA58CB61A2CE8359388E4C4EFB\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\3445BE35A936A2EBEFE763C98ACCD25B\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\A9819A759F3A19AA674A4E0383D4E24D\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\6A2F409B1AE6CC37A50A53CBBD33ED97\MQL4\Experts"
    "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\A26EE4CBF3F654FE4025023D7A5FE743\MQL4\Experts"
) do (
    echo Copying to: %%D
    if not exist "%%D" (
        echo Folder does not exist, creating: %%D
        mkdir "%%D"
    )
    copy /Y "%source%" "%%D\"
)

echo All copies completed.
pause


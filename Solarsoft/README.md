# Solarsoft

- https://en.wikipedia.org/wiki/Solarsoft
- https://www.lmsal.com/solarsoft/
- https://hesperia.gsfc.nasa.gov/ssw/hessi/doc/faq/faq_ssw.htm

After installing and setting up SSW, start SSW IDL by:

- Windows: Run the batch file usually called $SSW/site/setup/sswidl.bat (or a shortcut to it on your desktop)
- Unix: Type sswidl

```
bash$ which idl
/usr/local/bin/idl

sudo apt install tcsh
tcsh> setenv IDL_DIR /usr/local
tcsh> setenv SSW ~/ssw
tcsh> source $SSW/gen/setup/setup.ssw
tcsh> sswidl
```

## External IDL Libraries

https://github.com/afteriwoof/CORIMP

## Issue

If you run the vso_search() function in Windows environment and IDL is turned off without any message, first open the dmp file in %HOMEPATH%\AppData\Local\CrashDumps with WinDbg and run !analyze -v to find the cause.

In my case, the problem was libcurl.dll, so I downloaded the curl for Windows zip file from https://curl.se/windows/ and moved the libcurl-x64.dll file under the bin folder to C:\Program Files\Harris\IDL86\bin\bin.x86_64\libcurl.dll, and it worked.
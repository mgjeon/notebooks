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
#!/usr/bin/env python

import html2text
import os
import sys

import os

## /Users/lbermudez/Documents/Dropbox/github/ets-wms130/src/main/site
folderwithhtml='/Users/lbermudez/Documents/Dropbox/github/ets-wms130/src/main/site/'
## folderwithhtml=sys.argv[1]
folderout=folderwithhtml+'markdown/'



def createFile(template,new):
   
   # read the file
   fin = open(template, "r")
   str2 = fin.read()
   fin.close()

   str3 = html2text.html2text(str2)

   # write changed text back out
   fout = open(new, "w")
   fout.write(str3)
   fout.close()

for file in os.listdir(folderwithhtml):
   print 'file '+ file
   base=os.path.basename(folderwithhtml+file)
   if (base.endswith('.html')):
      filename=os.path.splitext(base)[0]
      mdfile=folderout+filename+'.md'
      createFile(folderwithhtml+file,mdfile)
      print 'file mc created:'+ mdfile

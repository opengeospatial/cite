#!/usr/bin/env python

import html2text
import os
import sys

from fileinput import input
import shutil
import re

from Tkinter import Tk

def addToClipBoard(text):
   r = Tk()
   r.withdraw()
   r.clipboard_clear()
   r.clipboard_append(text)
   r.destroy()


##folderwithhtml='/Users/lbermudez/Documents/Dropbox/github/ets-wms130/src/main/site/'
folderwithhtml=sys.argv[1]
if not(folderwithhtml.endswith("/")):
   folderwithhtml=folderwithhtml+"/"
   
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


#### clean up

word_dic2 = {
'"https': 'https',
'services/\n': 'services/',
'//porta\n':'//porta',
'")':')',
"r'issue_id=([0-9])\n":"r'issue_id=\1",
"\n\n":"\n",
"\n\n\n":"\n",
"\n\n\n\n":"\n",
"\n\n\n\n\n":"\n",
'_"':'_',
'"\n':'',
'_Opened':'\n\n_Opened',
'Last Updated: 0000-00-00 00:00:00':''

}

word_dic = {
"\n\n":"\n",
"\n\n\n":"\n",
"\n\n\n\n":"\n",
"\n\n\n\n\n":"\n"

}



def replace_words(text, word_dic):
    """
    take a text and replace words that match a key in a dictionary with
    the associated value, return the changed text
    """
    rc = re.compile('|'.join(map(re.escape, word_dic)))
    def translate(match):
        return word_dic[match.group(0)]
    return rc.sub(translate, text)


def cleanFile(template,new):
   # read the file
   fin = open(template, "r")
   str2 = fin.read()
   fin.close()

   str3 = replace_words(str2, word_dic)

   # write changed text back out
   fout = open(new, "w")
   fout.write(str3)
   fout.close()

def writetoClipboard(file):
   fin = open(file, "r")
   str = fin.read()
   addToClipBoard(str)
   fin.close()
   

for file in os.listdir(folderwithhtml):
   print 'file '+ file
   base=os.path.basename(folderwithhtml+file)
   if (base.endswith('.html')):
      filename=os.path.splitext(base)[0]
      mdfile=folderout+filename+'.md'
      createFile(folderwithhtml+file,mdfile)
      cleanFile(mdfile,mdfile)
      writetoClipboard(mdfile)
      print 'file mc created:'+ mdfile





#!/usr/bin/env python
#usage: python thisscript.py token file file2 file3
import sys
from fileinput import input
import shutil
import re

file=sys.argv[1]

word_dic = {
'}': '\r\r',
'[': '',
']': '',
',': '',
'"': '',
'{':'\r',
"name:":'* aa *',
'description:':'**\r -',
'url:':'\r -'

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


def createFile(template,new):
   # read the file
   fin = open(template, "r")
   str2 = fin.read()
   fin.close()

   str3 = replace_words(str2, word_dic)

   # write changed text back out
   fout = open(new, "w")
   fout.write(str3)
   fout.close()



createFile(file,file+"-simple")



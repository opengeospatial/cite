#!/usr/bin/env python
#usage: python thisscript.py token file file2 file3
import sys
from fileinput import input
import shutil
import re

print (sys.argv[1:]);

print 'replaceing tokens'
folder_ets=sys.argv[1]
print "folder_ets is " +folder_ets
artifactId=sys.argv[2]
print "artifactId is " +artifactId
longversion=sys.argv[3]
print "longversion is " +longversion
name =sys.argv[4]
print "name is " +name
ets=sys.argv[5]
print "ets is " +ets
ver=sys.argv[6]
print "ver is " +ver
javaname=artifactId.replace('ets-','').replace("-","")
print "javaname is " +javaname
xmlmain=sys.argv[7]
# folder
# artifactId='ets-wms130'
# version='1.0.0-r4-SNAPSHOT'
# name ='Web Map Service (WMS)  1.3.0'
# ets='wms'
# ver='1.3.0'

print ('processing '+folder_ets)

word_dic = {
'$artifactId': artifactId,
'$longversion': longversion,
'$name': name.replace("__"," "),
'$ets': ets,
'$ver': ver,
'$javaname':javaname,
'$xmlmain':xmlmain,
'src</source>':'ctl</source>'
}



# shutil.copy2('ets-template/pom.xml', 'ets-template/pom1.xml')
# file='./ets-template/pom1.xml'

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



createFile('./ets-template/VerifyTestSuite.java',folder_ets+'/src/test/java/org/opengis/cite/'+javaname+"/"+'VerifyTestSuite.jav')
createFile('./ets-template/pom.xml',folder_ets+'/pom.xml')
createFile('./ets-template/README.md',folder_ets+'/README.md')
createFile('./ets-template/site.xml',folder_ets+'/src/site/site.xml')
createFile('./ets-template/dist.xml',folder_ets+'/src/assembly/dist.xml')
createFile('./ets-template/index.md',folder_ets+'/src/site/markdown/index.md')
createFile('./ets-template/build.sh',folder_ets+'/build.sh')
# replaces any token in the configxml
configxml=folder_ets+'/src/main/config/config.xml'
createFile(configxml,configxml)



#!/usr/bin/env python

from xml.etree.ElementTree import fromstring, ElementTree, Element
import xml.etree.cElementTree as ET
import os
import sys

# update WFS 20

config='/Users/lbermudez/Documents/Dropbox/software/te_build/catalina_base/TE_BASE/scripts/wfs20/2.0.0/config.xml'

conf = ET.parse(config)
status=conf.find('..//status')
status.text=

TE_BASE=sys.argv[1]
if not TE_BASE.endswith("/"):
   TE_BASE=TE_BASE+"/"
print ('TE_BASE (argument one is)',TE_BASE)
scripts_dir=TE_BASE+"/scripts/"
#sys.exit(0)

# create main-config.xml
root = ET.Element("config")
scripts = ET.SubElement(root, "scripts")
organization = ET.SubElement(scripts, "organization")
name = ET.SubElement(organization, "name")
name.text="OGC"

tree = ET.ElementTree(root)
tree.write("config-all.xml")


def processStandardVersion(tree2,node2):
   print ('node2',node2.text)
   node1Sta=root.find('.//standard')
   added=False
   if node1Sta is None:
      parent=tree2.find('.//standard') 
      organization.append(parent)
      added=True
   # a standard element allready exists
   if not added:
      for node1Sta in root.findall('.//standard'):
         node1Name=node1Sta.find('name')
         if node1Name.text==node2.text:
            version2=tree2.find('.//version')
            node1Sta.append(version2)
            added=True
            break
      if not added:
         parent=tree2.find('.//standard') 
         organization.append(parent)

      
def processFile(file):
   print ('Processing '+file)
   tree2 = ET.parse(file)
   node =tree2.find('standard/name[1]')
   processStandardVersion(tree2, node)



for dirpath, dirs, files in os.walk(scripts_dir):
   for file in files:
      if file=='config.xml':
         processFile (os.path.join(dirpath, file))
      

tree.write("config-all.xml")     
tree.write(TE_BASE+"config.xml")
   
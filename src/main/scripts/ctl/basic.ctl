<?xml version="1.0" encoding="UTF-8"?>
<ctl:package
 xmlns:ctl="http://www.occamlab.com/ctl"
 xmlns:ctlp="http://www.occamlab.com/te/parsers"
 xmlns:fn="http://www.w3.org/2005/xpath-functions"
 xmlns:wms="http://www.opengis.net/wms"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:basic="urn:wms_client_test_suite/basic_elements">

  <ctl:test name="basic:mandatory-params">
    <ctl:param name="request"/>
    <ctl:param name="params"/>
    <ctl:assertion>Each of the mandatory parameters is present.</ctl:assertion>
    <ctl:code>
      <xsl:for-each select="$params/param">
        <xsl:variable name="param" select="."/>
        <xsl:if test="not($request/ctl:param[fn:upper-case(@name)=$param])">
          <ctl:message>No <xsl:value-of select="$param"/> parameter</ctl:message>
          <ctl:fail/>
        </xsl:if>
      </xsl:for-each>
    </ctl:code>
  </ctl:test>

  <ctl:test name="basic:version">
    <ctl:param name="request"/>
    <ctl:assertion>The value of the VERSION parameter is "1.3.0".</ctl:assertion>
    <ctl:code>
      <xsl:if test="$request/ctl:param[fn:upper-case(@name)='VERSION'] != '1.3.0'">
        <ctl:message>VERSION=<xsl:value-of select="$request/ctl:param[fn:upper-case(@name)='VERSION']"/></ctl:message>
        <ctl:fail/>
      </xsl:if>
    </ctl:code>
  </ctl:test>

  <ctl:test name="basic:request">
    <ctl:param name="request"/>
    <ctl:param name="expected-value"/>
    <ctl:assertion>The value of the REQUEST parameter is "{$expected-value}".</ctl:assertion>
    <ctl:code>
      <xsl:if test="$request/ctl:param[fn:upper-case(@name)='REQUEST'] != $expected-value">
        <ctl:message>REQUEST=<xsl:value-of select="$request/ctl:param[fn:upper-case(@name)='REQUEST']"/></ctl:message>
        <ctl:fail/>
      </xsl:if>
    </ctl:code>
  </ctl:test>
</ctl:package>
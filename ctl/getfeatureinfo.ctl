<?xml version="1.0" encoding="UTF-8"?>
<ctl:package
 xmlns:ctl="http://www.occamlab.com/ctl"
 xmlns:ctlp="http://www.occamlab.com/te/parsers"
 xmlns:fn="http://www.w3.org/2005/xpath-functions"
 xmlns:wms="http://www.opengis.net/wms"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:main="urn:wms_client_test_suite/main"
 xmlns:basic="urn:wms_client_test_suite/basic_elements"
 xmlns:gm="urn:wms_client_test_suite/GetMap"
 xmlns:gfi="urn:wms_client_test_suite/GetFeatureInfo"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema">

  <ctl:test name="gfi:check-GetFeatureInfo-request">
    <ctl:param name="request"/>
    <ctl:param name="response"/>
    <ctl:param name="capabilities"/>
    <ctl:assertion>The client GetFeatureInfo request is valid.</ctl:assertion>
    <ctl:code>
      <ctl:call-test name="basic:mandatory-params">
        <ctl:with-param name="request" select="$request"/>
        <ctl:with-param name="params">
          <params>
            <param>VERSION</param>
            <param>REQUEST</param>
            <param>LAYERS</param>
            <param>STYLES</param>
            <param>CRS</param>
            <param>BBOX</param>
            <param>WIDTH</param>
            <param>HEIGHT</param>
            <param>FORMAT</param>
            <param>QUERY_LAYERS</param>
            <param>INFO_FORMAT</param>
            <param>I</param>
            <param>J</param>
          </params>
        </ctl:with-param>
      </ctl:call-test>

      <xsl:if test="$request/ctl:param[fn:upper-case(@name)='VERSION']">
        <ctl:call-test name="basic:version">
          <ctl:with-param name="request" select="$request"/>
        </ctl:call-test>
      </xsl:if>

      <xsl:if test="$request/ctl:param[fn:upper-case(@name)='REQUEST']">
        <ctl:call-test name="basic:request">
          <ctl:with-param name="request" select="$request"/>
          <ctl:with-param name="expected-value">GetFeatureInfo</ctl:with-param>
        </ctl:call-test>
      </xsl:if>

      <ctl:call-test name="gm:core-map-request">
        <ctl:with-param name="request" select="$request"/>
        <ctl:with-param name="capabilities" select="$capabilities"/>
      </ctl:call-test>

      <xsl:if test="$request/ctl:param[fn:upper-case(@name)='QUERY_LAYERS']">
        <ctl:call-test name="gfi:query_layers-count">
          <ctl:with-param name="request" select="$request"/>
        </ctl:call-test>
        <ctl:call-test name="gfi:query_layers-values">
          <ctl:with-param name="request" select="$request"/>
        </ctl:call-test>
        <ctl:call-test name="gfi:query_layers-queryable">
          <ctl:with-param name="request" select="$request"/>
          <ctl:with-param name="capabilities" select="$capabilities"/>
        </ctl:call-test>
      </xsl:if>

      <xsl:if test="$request/ctl:param[fn:upper-case(@name)='INFO_FORMAT']">
        <ctl:call-test name="gfi:info_format">
          <ctl:with-param name="request" select="$request"/>
          <ctl:with-param name="getfeatureinfo-element" select="$capabilities/wms:Capability/wms:Request/wms:GetFeatureInfo"/>
        </ctl:call-test>
      </xsl:if>

      <xsl:if test="$request/ctl:param[fn:upper-case(@name)='I']">
        <ctl:call-test name="gfi:i">
          <ctl:with-param name="request" select="$request"/>
        </ctl:call-test>
      </xsl:if>

      <xsl:if test="$request/ctl:param[fn:upper-case(@name)='J']">
        <ctl:call-test name="gfi:j">
          <ctl:with-param name="request" select="$request"/>
        </ctl:call-test>
      </xsl:if>
    </ctl:code>
  </ctl:test>

  <ctl:test name="gfi:query_layers-count">
    <ctl:param name="request"/>
    <ctl:assertion>The QUERY_LAYERS parameter contains at least one layer name.</ctl:assertion>
    <ctl:code>
      <xsl:if test="normalize-space($request/ctl:param[fn:upper-case(@name)='QUERY_LAYERS'])=''">
        <ctl:fail/>
      </xsl:if>
    </ctl:code>
  </ctl:test>

  <ctl:test name="gfi:query_layers-values">
    <ctl:param name="request"/>
    <ctl:assertion>Each of the values in the QUERY_LAYERS parameter is a layer from the original GetMap request.</ctl:assertion>
    <ctl:code>
      <xsl:variable name="layers">
        <ctl:call-function name="main:parse-list">
          <ctl:with-param name="list" select="$request/ctl:param[fn:upper-case(@name)='LAYERS']"/>
        </ctl:call-function>
      </xsl:variable>
      <xsl:variable name="query-layers">
        <ctl:call-function name="main:parse-list">
          <ctl:with-param name="list" select="$request/ctl:param[fn:upper-case(@name)='QUERY_LAYERS']"/>
        </ctl:call-function>
      </xsl:variable>
      <xsl:for-each select="$query-layers/value">
        <xsl:variable name="value" select="string(.)"/>
        <xsl:if test="not($layers/value[.=$value])">
          <ctl:message>Invalid query layer name "<xsl:value-of select="$value"/>"</ctl:message>
          <ctl:fail/>
        </xsl:if>
      </xsl:for-each>
    </ctl:code>
  </ctl:test>

  <ctl:test name="gfi:query_layers-queryable">
    <ctl:param name="request"/>
    <ctl:param name="capabilities"/>
    <ctl:assertion>
    Each of the values in the QUERY_LAYERS parameter must be a queryable layer.
    That is, the layer attribute "queryable" must evaluate to true (xsd:boolean); 
    it may be inherited.
    </ctl:assertion>
    <ctl:comment>See ISO 19128:2005, cl. 7.2.4.7.2: Queryable layers</ctl:comment>
    <ctl:comment>See ISO 19128:2005, cl. 7.4.1: General</ctl:comment>
    <ctl:code>
      <xsl:variable name="queryable-layers" 
        select="$capabilities//wms:Layer[ancestor-or-self::*[xsd:boolean(@queryable)]]/wms:Name" />
      <xsl:for-each select="tokenize($request/ctl:param[upper-case(@name)='QUERY_LAYERS'], ',')">
        <xsl:variable name="layer" select="string(.)"/>
        <xsl:if test="empty(index-of($queryable-layers, $layer))">
          <ctl:message>[FAILURE] Name in QUERY_LAYERS is not a queryable layer: <xsl:value-of select="$layer"/></ctl:message>
          <ctl:fail/>
        </xsl:if>
      </xsl:for-each>
    </ctl:code>
  </ctl:test>

  <ctl:test name="gfi:info_format">
    <ctl:param name="request"/>
    <ctl:param name="getfeatureinfo-element"/>
    <ctl:assertion>The value of the INFO_FORMAT parameter is one of the formats listed in the service metadata.</ctl:assertion>
    <ctl:code>
      <xsl:variable name="value" select="string($request/ctl:param[fn:upper-case(@name)='INFO_FORMAT'])"/>
      <!-- Too simplistic.  Need to do full MIME checking -->
      <xsl:if test="not($getfeatureinfo-element/wms:Format[.=$value])">
        <ctl:message><xsl:value-of select="$value"/> is not a valid INFO_FORMAT value.</ctl:message>
        <ctl:fail/>
      </xsl:if>
    </ctl:code>
  </ctl:test>

  <ctl:test name="gfi:i">
    <ctl:param name="request"/>
    <ctl:assertion>The value of the I parameter is an integer between 0 and the maximum value of the i axis (WIDTH-1).</ctl:assertion>
    <ctl:code>
      <xsl:variable name="i" select="number($request/ctl:param[fn:upper-case(@name)='I'])"/>
      <xsl:variable name="width" select="number($request/ctl:param[fn:upper-case(@name)='WIDTH'])"/>
      <xsl:choose>
        <xsl:when test="string($i) = 'NaN'">
          <ctl:fail/>
        </xsl:when>
        <xsl:when test="contains(string($i), '.')">
          <ctl:fail/>
        </xsl:when>
        <xsl:when test="not($i gt 0 and $i lt $width)">
          <ctl:fail/>
        </xsl:when>
      </xsl:choose>
    </ctl:code>
  </ctl:test>

  <ctl:test name="gfi:j">
    <ctl:param name="request"/>
    <ctl:assertion>The value of the J parameter is an integer between 0 and the maximum value of the i axis (HEIGHT-1).</ctl:assertion>
    <ctl:code>
      <xsl:variable name="j" select="number($request/ctl:param[fn:upper-case(@name)='J'])"/>
      <xsl:variable name="height" select="number($request/ctl:param[fn:upper-case(@name)='HEIGHT'])"/>
      <xsl:choose>
        <xsl:when test="string($j) = 'NaN'">
          <ctl:fail/>
        </xsl:when>
        <xsl:when test="contains(string($j), '.')">
          <ctl:fail/>
        </xsl:when>
        <xsl:when test="not($j gt 0 and $j lt $height)">
          <ctl:fail/>
        </xsl:when>
      </xsl:choose>
    </ctl:code>
  </ctl:test>
</ctl:package>
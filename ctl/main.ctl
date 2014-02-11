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
  xmlns:gc="urn:wms_client_test_suite/GetCapabilities"
  xmlns:gm="urn:wms_client_test_suite/GetMap"
  xmlns:gfi="urn:wms_client_test_suite/GetFeatureInfo"
  xmlns:saxon="http://saxon.sf.net/">

  <ctl:suite name="main:ets-wms-client">
    <ctl:title>WMS Client Test Suite</ctl:title>
    <ctl:description>Validates WMS Client Requests.</ctl:description>
    <ctl:link title="Test suite overview">about/wms-client/1.3.0/</ctl:link>
    <ctl:starting-test>main:wms-client</ctl:starting-test>
  </ctl:suite>

  <ctl:test name="main:wms-client">
    <ctl:assertion>The WMS client constructs valid requests.</ctl:assertion>
    <ctl:code> 
      <xsl:variable name="capabilities">
        <ctl:request>
          <ctl:url>
            <xsl:value-of 
         select="'http://cite.lat-lon.de/deegree-webservices-3.3.6-2/services/wms?service=WMS&amp;version=1.3.0&amp;request=GetCapabilities'"/>
          </ctl:url>
          <ctl:method>GET</ctl:method>
        </ctl:request>
      </xsl:variable>

      <xsl:variable name="monitor-urls">
        <xsl:for-each select="$capabilities/wms:WMS_Capabilities/wms:Capability/wms:Request">
          <xsl:for-each select="wms:GetCapabilities|wms:GetMap|wms:GetFeatureInfo">
            <xsl:copy>
              <ctl:allocate-monitor-url>
                <xsl:value-of select="wms:DCPType/wms:HTTP/wms:Get/wms:OnlineResource/@xlink:href"/>
              </ctl:allocate-monitor-url>
            </xsl:copy>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:variable>

      <xsl:if test="string-length($monitor-urls/wms:GetCapabilities) gt 0">
        <ctl:create-monitor>
          <ctl:url>
            <xsl:value-of select="$monitor-urls/wms:GetCapabilities"/>
          </ctl:url>
          <ctl:triggers-test name="gc:check-GetCapabilities-request">
            <ctl:with-param name="capabilities" select="$capabilities/wms:WMS_Capabilities"/>
          </ctl:triggers-test>
          <ctl:with-parser modifies-response="true">
            <ctlp:XSLTransformationParser resource="rewrite-capabilities.xsl">
              <ctlp:with-param name="GetCapabilities-proxy">
                <xsl:value-of select="$monitor-urls/wms:GetCapabilities"/>
              </ctlp:with-param>
              <ctlp:with-param name="GetMap-proxy">
                <xsl:value-of select="$monitor-urls/wms:GetMap"/>
              </ctlp:with-param>
              <ctlp:with-param name="GetFeatureInfo-proxy">
                <xsl:value-of select="$monitor-urls/wms:GetFeatureInfo"/>
              </ctlp:with-param>
            </ctlp:XSLTransformationParser>
          </ctl:with-parser>
        </ctl:create-monitor>
      </xsl:if>

      <xsl:if test="string-length($monitor-urls/wms:GetMap) gt 0">
        <ctl:create-monitor>
          <ctl:url>
            <xsl:value-of select="$monitor-urls/wms:GetMap"/>
          </ctl:url>
          <ctl:triggers-test name="gm:check-GetMap-request">
            <ctl:with-param name="capabilities" select="$capabilities/wms:WMS_Capabilities"/>
          </ctl:triggers-test>
          <ctl:with-parser>
            <ctlp:NullParser/>
          </ctl:with-parser>
        </ctl:create-monitor>
      </xsl:if>

      <xsl:if test="string-length($monitor-urls/wms:GetFeatureInfo) gt 0">
        <ctl:create-monitor>
          <ctl:url>
            <xsl:value-of select="$monitor-urls/wms:GetFeatureInfo"/>
          </ctl:url>
          <ctl:triggers-test name="gfi:check-GetFeatureInfo-request">
            <ctl:with-param name="capabilities" select="$capabilities/wms:WMS_Capabilities"/>
          </ctl:triggers-test>
          <ctl:with-parser>
            <ctlp:NullParser/>
          </ctl:with-parser>
        </ctl:create-monitor>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="not($capabilities/wms:WMS_Capabilities)">
          <ctl:message>FAILURE: Did not receive a WMS_Capabilities document! Skipping remaining tests.</ctl:message>	
          <ctl:fail/>
        </xsl:when>
        <xsl:when test="string-length($monitor-urls/wms:GetCapabilities) gt 0 and string-length($monitor-urls/wms:GetMap) gt 0">
          <ctl:form>
          
           <h2>WMS 1.3 Client Test Suite</h2>
           <p>This test verifies that a WMS 1.3 client executes valid requests to a WMS 1.3 server. Each of the GetCapabilities, GetMap, and GetFeatureInfo requests that the client submits are validated.</p>
           
        	<p>The details of all the requests that are required to be executed by the client are documented <a href="../web/" target="_blank">here</a>.</p>
           
           <p>The test creates a proxy service that interacts with the <a href="http://ri.opengeospatial.org:8680/degree-wms-130/services">WMS 1.3 Reference Implementation</a> available at the OGC Server.</p>
           
          
            <xsl:text>To start testing, configure the client to use the following endpoint URL, which is a proxy to the WMS 1.3 Server Reference Implementation.</xsl:text>
            <xhtml:br/>
            <xsl:value-of select="$monitor-urls/wms:GetCapabilities"/>
            <xhtml:br/>
            <xhtml:br/>
            <xsl:text>Leave this form open while you use the client.</xsl:text>
            <xhtml:br/>
            <xsl:text>Press the 'Stop testing' button when you are finished.</xsl:text>
            <xhtml:br/>
             <xhtml:br/>
              <xhtml:br/>
            <xhtml:input type="submit" value="Stop testing"/>
          </ctl:form>
        </xsl:when>
        <xsl:otherwise>
          <ctl:message>FAILURE: Unable to create proxy endpoint.</ctl:message>
          <ctl:fail/>
        </xsl:otherwise>
      </xsl:choose>
      
      <ctl:call-test name="main:check-coverage">
        <ctl:with-param name="coverage-report-uri" select="concat(ctl:getSessionDir(),'/coverage.xml')" />
      </ctl:call-test>
    </ctl:code>
  </ctl:test>

  <ctl:test name="main:check-coverage">
    <?ctl-msg name="coverage" ?>
    <ctl:param name="coverage-report-uri"/>
    <ctl:assertion>Service capabilities were fully covered.</ctl:assertion>
    <ctl:code>
      <ctl:message>Coverage report located at <xsl:value-of select="$coverage-report-uri"/></ctl:message>
      <xsl:variable name="coverage-report" select="doc($coverage-report-uri)" />
      <xsl:if test="count($coverage-report//param) > 0">
        <ctl:message>[FAILURE] Some service capabilities were not exercised.</ctl:message>
        <ctl:message>
          <xsl:value-of select="saxon:serialize($coverage-report, 'coverage')" />
        </ctl:message>
        <ctl:fail/>
      </xsl:if>
    </ctl:code>
  </ctl:test>

  <ctl:function name="main:parse-list">
    <ctl:param name="list"/>
    <ctl:code>
      <xsl:choose>
        <xsl:when test="contains($list, ',')">
          <value>
            <xsl:value-of select="substring-before($list, ',')"/>
          </value>
          <ctl:call-function name="main:parse-list">
            <ctl:with-param name="list" select="substring-after($list, ',')"/>
          </ctl:call-function>
        </xsl:when>
        <xsl:otherwise>
          <value>
            <xsl:value-of select="$list"/>
          </value>
        </xsl:otherwise>
      </xsl:choose>
    </ctl:code>
  </ctl:function>
</ctl:package>

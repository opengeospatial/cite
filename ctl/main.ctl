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
  xmlns:tec="java:com.occamlab.te.TECore"
  xmlns:saxon="http://saxon.sf.net/">

  <ctl:suite name="main:ets-wms-client">
    <ctl:title>WMS Client Test Suite</ctl:title>
    <ctl:description>Validates WMS Client Requests.</ctl:description>
    <ctl:link title="Test suite overview">about/wms-client/1.3.0/</ctl:link>
    <ctl:starting-test>main:wms-client</ctl:starting-test>
  </ctl:suite>

  <ctl:test name="main:wms-client">
    <ctl:assertion>The WMS client submits valid requests.</ctl:assertion>
    <ctl:code>
      <xsl:variable name="wms-url" 
      select="'http://cite.demo.opengeo.org:8080/geoserver_wms13/ows?service=WMS&amp;version=1.3.0&amp;request=GetCapabilities'" />
      <xsl:variable name="capabilities">
        <ctl:request>
          <ctl:url><xsl:value-of select="$wms-url" /></ctl:url>
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
          <ctl:form method="POST" width="800" height="600" xmlns="http://www.w3.org/1999/xhtml">
           <h2>WMS 1.3 Client Test Suite</h2>
           <p>This test suite verifies that a WMS 1.3 client submits valid requests to a WMS 1.3 server. Each of the requests that 
           the client submits will be inspected and validated. The details of all the requests that are required to be executed by 
           the client are documented in the <a href="../web/" target="_blank">test suite summary</a>.</p>

           <p>An intercepting proxy is created to access the WMS 1.3 reference implementation. The client 
           is expected to fully exercise the WMS implementation, including all implemented options as 
           indicated in the 
           <xsl:element name="a">
             <xsl:attribute name="target">_blank</xsl:attribute>
             <xsl:attribute name="href"><xsl:value-of select="$wms-url"/></xsl:attribute>
             <xsl:text>service capabilities document</xsl:text> 
           </xsl:element>
           </p>

           <p>To start testing, configure the client application to use the following proxy endpoint:</p>
           <div style="background-color:#F0F8FF">
           <p><xsl:value-of select="$monitor-urls/wms:GetCapabilities"/></p>
           </div>
           <p>Leave this form open while you use the client. Press the 'Stop testing' button when you are finished.</p>
           <br/>
           <input type="submit" value="Stop testing"/>
          </ctl:form>
        </xsl:when>
        <xsl:otherwise>
          <ctl:message>[FAIL]: Unable to create proxy endpoints.</ctl:message>
          <ctl:fail/>
        </xsl:otherwise>
      </xsl:choose>
    </ctl:code>
  </ctl:test>

  <ctl:profile name="main:client-coverage">
    <ctl:title>WMS Client Coverage</ctl:title>
    <ctl:description>Checks that a WMS client exercises all capabilities of the WMS service.</ctl:description>
    <ctl:defaultResult>Pass</ctl:defaultResult>
    <ctl:base>main:ets-wms-client</ctl:base>
    <ctl:starting-test>main:check-coverage</ctl:starting-test>
  </ctl:profile>

  <ctl:test name="main:check-coverage">
    <!-- See com.occamlab.te.web.CoverageMonitor -->
    <?ctl-msg name="coverage" ?>
    <ctl:assertion>Service capabilities were fully covered by the client.</ctl:assertion>
    <ctl:code>
      <xsl:variable name="session-dir" select="ctl:getSessionDir()" />
      <xsl:variable name="coverage-results">
        <service-requests>
          <xsl:for-each select="collection(concat($session-dir,'?select=WMS-*.xml'))">
            <xsl:copy-of select="doc(document-uri(.))"/>
          </xsl:for-each>
        </service-requests>
      </xsl:variable>
      <xsl:if test="count($coverage-results//param) > 0">
        <ctl:message>[FAIL]: Some service capabilities were not exercised by the client. All &lt;request&gt; 
elements shown below should be empty--if not, some supported options were not requested by the client.</ctl:message>
        <ctl:message>
          <xsl:value-of select="saxon:serialize($coverage-results, 'coverage')" />
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

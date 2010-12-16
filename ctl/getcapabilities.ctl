<ctl:package
 xmlns:ctl="http://www.occamlab.com/ctl"
 xmlns:ctlp="http://www.occamlab.com/te/parsers"
 xmlns:fn="http://www.w3.org/2005/xpath-functions"
 xmlns:wms="http://www.opengis.net/wms"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:basic="urn:wms_client_test_suite/basic_elements"
 xmlns:gc="urn:wms_client_test_suite/GetCapabilities"
>
    <ctl:test name="gc:check-GetCapabilities-request">
        <ctl:param name="request"/>
        <ctl:param name="response"/>
        <ctl:param name="capabilities"/>
        <ctl:assertion>The client GetCapabilities request is valid.</ctl:assertion>
        <ctl:code>
            <ctl:call-test name="basic:mandatory-params">
                <ctl:with-param name="request" select="$request"/>
                <ctl:with-param name="params">
                    <params>
                        <param>SERVICE</param>
                        <param>REQUEST</param>
                    </params>
                </ctl:with-param>
            </ctl:call-test>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='SERVICE']">
                <ctl:call-test name="gc:service">
                    <ctl:with-param name="request" select="$request"/>
                </ctl:call-test>
            </xsl:if>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='REQUEST']">
                <ctl:call-test name="basic:request">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="expected-value">GetCapabilities</ctl:with-param>
                </ctl:call-test>
            </xsl:if>
        </ctl:code>
    </ctl:test>

    <ctl:test name="gc:service">
        <ctl:param name="request"/>
        <ctl:assertion>The value of the SERVICE parameter is "WMS".</ctl:assertion>
        <ctl:code>
            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='SERVICE'] != 'WMS'">
                <ctl:message>SERVICE=<xsl:value-of select="$request/ctl:param[fn:upper-case(@name)='SERVICE']"/></ctl:message>
                <ctl:fail/>
            </xsl:if>
        </ctl:code>
    </ctl:test>
</ctl:package>
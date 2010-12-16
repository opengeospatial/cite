<ctl:package
 xmlns:ctl="http://www.occamlab.com/ctl"
 xmlns:ctlp="http://www.occamlab.com/te/parsers"
 xmlns:fn="http://www.w3.org/2005/xpath-functions"
 xmlns:wms="http://www.opengis.net/wms"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:main="urn:wms_client_test_suite/main"
 xmlns:basic="urn:wms_client_test_suite/basic_elements"
 xmlns:gm="urn:wms_client_test_suite/GetMap"
>
    <ctl:test name="gm:check-GetMap-request">
        <ctl:param name="request"/>
        <ctl:param name="response"/>
        <ctl:param name="capabilities"/>
        <ctl:assertion>The client GetMap request is valid.</ctl:assertion>
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
                    <ctl:with-param name="expected-value">GetMap</ctl:with-param>
                </ctl:call-test>
            </xsl:if>

            <ctl:call-test name="gm:core-map-request">
                <ctl:with-param name="request" select="$request"/>
                <ctl:with-param name="capabilities" select="$capabilities"/>
            </ctl:call-test>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='EXCEPTIONS']">
                <ctl:call-test name="gm:exceptions">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="exception-element" select="$capabilities/wms:Capability/wms:Exception"/>
                </ctl:call-test>
            </xsl:if>
        </ctl:code>
    </ctl:test>

    <ctl:test name="gm:core-map-request">
        <ctl:param name="request"/>
        <ctl:param name="capabilities"/>
        <ctl:assertion>The core parameters for a GetMap request are valid.</ctl:assertion>
        <ctl:code>
            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='LAYERS']">
                <ctl:call-test name="gm:layers-count">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="layer-limit" select="$capabilities/wms:Service/wms:LayerLimit"/>
                </ctl:call-test>
                <ctl:call-test name="gm:layers-names">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="root-layer" select="$capabilities/wms:Capability/wms:Layer"/>
                </ctl:call-test>
            </xsl:if>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='STYLES']">
                <ctl:call-test name="gm:styles-count">
                    <ctl:with-param name="request" select="$request"/>
                </ctl:call-test>
                <ctl:call-test name="gm:styles-names">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="root-layer" select="$capabilities/wms:Capability/wms:Layer"/>
                </ctl:call-test>
            </xsl:if>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='CRS']">
                <ctl:call-test name="gm:crs">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="root-layer" select="$capabilities/wms:Capability/wms:Layer"/>
                </ctl:call-test>
            </xsl:if>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='BBOX']">
                <ctl:call-test name="gm:bbox-format">
                    <ctl:with-param name="request" select="$request"/>
                </ctl:call-test>
                <ctl:call-test name="gm:bbox-non-subsettable-layers">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="root-layer" select="$capabilities/wms:Capability/wms:Layer"/>
                </ctl:call-test>
            </xsl:if>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='FORMAT']">
                <ctl:call-test name="gm:format">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="getmap-element" select="$capabilities/wms:Capability/wms:Request/wms:GetMap"/>
                </ctl:call-test>
            </xsl:if>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='WIDTH']">
                <ctl:call-test name="gm:width-height">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="param">Width</ctl:with-param>
                    <ctl:with-param name="limit" select="$capabilities/wms:Service/wms:MaxWidth"/>
                </ctl:call-test>
            </xsl:if>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='HEIGHT']">
                <ctl:call-test name="gm:width-height">
                    <ctl:with-param name="request" select="$request"/>
                    <ctl:with-param name="param">Height</ctl:with-param>
                    <ctl:with-param name="limit" select="$capabilities/wms:Service/wms:MaxHeight"/>
                </ctl:call-test>
            </xsl:if>

            <xsl:if test="$request/ctl:param[fn:upper-case(@name)='TRANSPARENT']">
                <ctl:call-test name="gm:transparent">
                    <ctl:with-param name="request" select="$request"/>
                </ctl:call-test>
            </xsl:if>
        </ctl:code>
    </ctl:test>

    <ctl:test name="gm:layers-count">
        <ctl:param name="request"/>
        <ctl:param name="layer-limit"/>
        <ctl:assertion>The number of the LAYERS requested does not exceed the layer limit.</ctl:assertion>
        <ctl:code>
            <xsl:if test="$layer-limit != ''">
                <xsl:variable name="layer-values">
                    <ctl:call-function name="main:parse-list">
                        <ctl:with-param name="list" select="$request/ctl:param[fn:upper-case(@name)='LAYERS']"/>
                    </ctl:call-function>
                </xsl:variable>
                <xsl:if test="count($layer-values/value) gt number($layer-limit)">
                    <ctl:fail/>
                </xsl:if>
            </xsl:if>
        </ctl:code>
    </ctl:test>
    
    <ctl:test name="gm:layers-names">
        <ctl:param name="request"/>
        <ctl:param name="root-layer"/>
        <ctl:assertion>Each of the values in the LAYERS parameter is a valid layer name.</ctl:assertion>
        <ctl:code>
            <xsl:variable name="layer-values">
                <ctl:call-function name="main:parse-list">
                    <ctl:with-param name="list" select="$request/ctl:param[fn:upper-case(@name)='LAYERS']"/>
                </ctl:call-function>
            </xsl:variable>
            <xsl:for-each select="$layer-values/value">
                <xsl:variable name="value" select="string(.)"/>
                <xsl:if test="not($root-layer/descendant-or-self::wms:Layer[wms:Name=$value])">
                    <ctl:message>Invalid layer name "<xsl:value-of select="$value"/>"</ctl:message>
                    <ctl:fail/>
                </xsl:if>
            </xsl:for-each>
        </ctl:code>
    </ctl:test>
    
    <ctl:test name="gm:styles-count">
        <ctl:param name="request"/>
        <ctl:assertion>The number of styles requested matches the number of layers requested.</ctl:assertion>
        <ctl:code>
            <xsl:variable name="styles" select="$request/ctl:param[fn:upper-case(@name)='STYLES']"/>
            <xsl:if test="$styles != ''">
                <xsl:variable name="layer-values">
                    <ctl:call-function name="main:parse-list">
                        <ctl:with-param name="list" select="$request/ctl:param[fn:upper-case(@name)='LAYERS']"/>
                    </ctl:call-function>
                </xsl:variable>
                <xsl:variable name="style-values">
                    <ctl:call-function name="main:parse-list">
                        <ctl:with-param name="list" select="$styles"/>
                    </ctl:call-function>
                </xsl:variable>
                <xsl:if test="count($layer-values/value) ne count($style-values/value)">
                    <ctl:message><xsl:value-of select="count($style-values/value)"/> styles, <xsl:value-of select="count($layer-values/value)"/> layers</ctl:message>
                    <ctl:fail/>
                </xsl:if>
            </xsl:if>
        </ctl:code>
    </ctl:test>
    
    <ctl:test name="gm:styles-names">
        <ctl:param name="request"/>
        <ctl:param name="root-layer"/>
        <ctl:assertion>Each of the values in the STYLES parameter is a valid style for its matching layer.</ctl:assertion>
        <ctl:code>
            <xsl:variable name="layer-values">
                <ctl:call-function name="main:parse-list">
                    <ctl:with-param name="list" select="$request/ctl:param[fn:upper-case(@name)='LAYERS']"/>
                </ctl:call-function>
            </xsl:variable>
            <xsl:variable name="style-values">
                <ctl:call-function name="main:parse-list">
                    <ctl:with-param name="list" select="$request/ctl:param[fn:upper-case(@name)='STYLES']"/>
                </ctl:call-function>
            </xsl:variable>
            <xsl:for-each select="$layer-values/value">
                <xsl:variable name="pos" select="position()"/>
                <xsl:variable name="style" select="string($style-values/value[position()=$pos])"/>
                <xsl:if test="$style != ''">
                    <xsl:variable name="layer" select="string(.)"/>
                    <xsl:if test="not($root-layer/descendant-or-self::wms:Layer[wms:Name=$layer]/ancestor-or-self::wms:Layer[wms:Style/wms:Name=$style])">
                        <ctl:message>Invalid style name "<xsl:value-of select="$style"/>"</ctl:message>
                        <ctl:fail/>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </ctl:code>
    </ctl:test>
    
    <ctl:test name="gm:crs">
        <ctl:param name="request"/>
        <ctl:param name="root-layer"/>
        <ctl:assertion>The CRS is valid style for each requested layer.</ctl:assertion>
        <ctl:code>
            <xsl:variable name="crs" select="string($request/ctl:param[fn:upper-case(@name)='CRS'])"/>
            <xsl:variable name="layer-values">
                <ctl:call-function name="main:parse-list">
                    <ctl:with-param name="list" select="string($request/ctl:param[fn:upper-case(@name)='LAYERS'])"/>
                </ctl:call-function>
            </xsl:variable>
            <xsl:for-each select="$layer-values/value">
                <xsl:variable name="layer" select="string(.)"/>
                <xsl:if test="not($root-layer/descendant-or-self::wms:Layer[wms:Name=$layer]/ancestor-or-self::wms:Layer[wms:CRS=$crs])">
                    <ctl:message>CRS <xsl:value-of select="$crs"/> is not valid for layer "<xsl:value-of select="$layer"/>"</ctl:message>
                    <ctl:fail/>
                </xsl:if>
            </xsl:for-each>
        </ctl:code>
    </ctl:test>
    
    <ctl:test name="gm:bbox-format">
        <ctl:param name="request"/>
        <ctl:assertion>The BBOX is a list of comma-separated real numbers in the form "minx,miny,maxx,maxy".</ctl:assertion>
        <ctl:code>
            <xsl:variable name="bbox-values">
                <ctl:call-function name="main:parse-list">
                    <ctl:with-param name="list" select="string($request/ctl:param[fn:upper-case(@name)='BBOX'])"/>
                </ctl:call-function>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="count($bbox-values/value) = 4">
                    <xsl:for-each select="$bbox-values/value">
                        <xsl:if test="string(number(.)) = 'NaN'">
                            <ctl:message>BBOX component <xsl:value-of select="."/> is not a number.</ctl:message>
                            <ctl:fail/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>   
                <xsl:otherwise>
                    <ctl:fail/>
                </xsl:otherwise>
            </xsl:choose>
        </ctl:code>
    </ctl:test>
    
    <ctl:test name="gm:bbox-non-subsettable-layers">
        <ctl:param name="request"/>
        <ctl:param name="root-layer"/>
        <ctl:assertion>For layers that are not subsettable, the BBOX parameter must match the bounding box declared for the layer.</ctl:assertion>
        <ctl:code>
            <xsl:choose>
                <xsl:when test="$root-layer/descendant-or-self::wms:Layer[@noSubsets=1 or @noSubsets='true']">
                    <xsl:variable name="crs" select="string($request/ctl:param[fn:upper-case(@name)='CRS'])"/>
                    <xsl:variable name="bbox" select="string($request/ctl:param[fn:upper-case(@name)='BBOX'])"/>
                    <xsl:variable name="bbox-values">
                        <ctl:call-function name="main:parse-list">
                            <ctl:with-param name="list" select="string($request/ctl:param[fn:upper-case(@name)='BBOX'])"/>
                        </ctl:call-function>
                    </xsl:variable>
                    <xsl:variable name="layer-values">
                        <ctl:call-function name="main:parse-list">
                            <ctl:with-param name="list" select="string($request/ctl:param[fn:upper-case(@name)='LAYERS'])"/>
                        </ctl:call-function>
                    </xsl:variable>
                    <xsl:for-each select="$layer-values/value">
                        <xsl:variable name="layer" select="string(.)"/>
                        <xsl:for-each select="$root-layer/descendant-or-self::wms:Layer[wms:Name=$layer]">
                            <xsl:if test="@noSubsets=1 or @noSubsets='true'">
                                <xsl:if test="not(ancestor-or-self::wms:Layer/wms:BoundingBox[@CRS=$crs and number($bbox-values[1]) = number(@minx)
                                                                                                        and number($bbox-values[2]) = number(@miny)
                                                                                                        and number($bbox-values[3]) = number(@maxx)
                                                                                                        and number($bbox-values[4]) = number(@maxy)])">
                                    <ctl:message>BBOX <xsl:value-of select="$bbox"/> is not valid for layer "<xsl:value-of select="$layer"/>"</ctl:message>
                                    <ctl:fail/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:when>   
                <xsl:otherwise>
                    <ctl:message>All layers are subsettable.</ctl:message>
                </xsl:otherwise>
            </xsl:choose>
        </ctl:code>
    </ctl:test>

    <ctl:test name="gm:format">
        <ctl:param name="request"/>
        <ctl:param name="getmap-element"/>
        <ctl:assertion>The value of the FORMAT parameter is one of the formats listed in the service metadata.</ctl:assertion>
        <ctl:code>
            <xsl:variable name="value" select="string($request/ctl:param[fn:upper-case(@name)='FORMAT'])"/>
            <!-- Too simplistic.  Need to do full MIME checking -->
            <xsl:if test="not($getmap-element/wms:Format[.=$value])">
                <ctl:message><xsl:value-of select="$value"/> is not a valid FORMAT value.</ctl:message>
                <ctl:fail/>
            </xsl:if>
        </ctl:code>
    </ctl:test>

    <ctl:test name="gm:width-height">
        <ctl:param name="request"/>
        <ctl:param name="param"/>
        <ctl:param name="limit"/>
        <ctl:assertion>{$param} is a positive integer value that does not exceed the declared Max{$param}.</ctl:assertion>
        <ctl:code>
            <xsl:variable name="value" select="string($request/ctl:param[fn:upper-case(@name)=fn:upper-case($param)])"/>
            <xsl:if test="contains($value, '.') or string(number($value)) = 'NaN' or number($value) le 0">
                <ctl:message><xsl:value-of select="$value"/> is not a positive integer.</ctl:message>
                <ctl:fail/>
            </xsl:if>
            <xsl:if test="$limit != ''">
                <xsl:if test="number($value) gt number($limit)">
                    <ctl:message><xsl:value-of select="$value"/> exceeds the declared Max<xsl:value-of select="$param"/> value of <xsl:value-of select="$limit"/>.</ctl:message>
                    <ctl:fail/>
                </xsl:if>
            </xsl:if>
        </ctl:code>
    </ctl:test>

    <ctl:test name="gm:transparent">
        <ctl:param name="request"/>
        <ctl:assertion>The value of the TRANSPARENT parameter is 'TRUE' or 'FALSE'.</ctl:assertion>
        <ctl:code>
            <xsl:variable name="value" select="string($request/ctl:param[fn:upper-case(@name)='TRANSPARENT'])"/>
            <xsl:if test="$value != 'TRUE' and $value != 'FALSE'">
                <ctl:message><xsl:value-of select="$value"/> is an invalid value for TRANSPARENT.</ctl:message>
                <ctl:fail/>
            </xsl:if>
        </ctl:code>
    </ctl:test>

    <ctl:test name="gm:exceptions">
        <ctl:param name="request"/>
        <ctl:param name="exception-element"/>
        <ctl:assertion>The value of the EXCEPTIONS parameter is one of the formats listed in the service metadata.</ctl:assertion>
        <ctl:code>
            <xsl:variable name="value" select="string($request/ctl:param[fn:upper-case(@name)='EXCEPTIONS'])"/>
            <xsl:if test="not($exception-element/wms:Format[.=$value])">
                <ctl:message><xsl:value-of select="$value"/> is not a valid EXCEPTIONS value.</ctl:message>
                <ctl:fail/>
            </xsl:if>
        </ctl:code>
    </ctl:test>
</ctl:package>
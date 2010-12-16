<xsl:transform
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:wms="http://www.opengis.net/wms"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 version="2.0">
	<xsl:output indent="yes"/>

    <xsl:param name="GetCapabilities-proxy"/>
    <xsl:param name="GetMap-proxy"/>
    <xsl:param name="GetFeatureInfo-proxy"/>
    
    <xsl:template match="@xlink:href[parent::wms:OnlineResource/parent::wms:Get/parent::wms:HTTP/parent::wms:DCPType]">
        <xsl:variable name="value" select="string(.)"/>
        <xsl:attribute name="xlink:href">
            <xsl:for-each select="parent::wms:OnlineResource/parent::wms:Get/parent::wms:HTTP/parent::wms:DCPType/parent::*">
                <xsl:choose>
                    <xsl:when test="self::wms:GetCapabilities">
                        <xsl:value-of select="$GetCapabilities-proxy"/>
                        <xsl:text>?</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::wms:GetMap">
                        <xsl:value-of select="$GetMap-proxy"/>
                        <xsl:text>?</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::wms:GetFeatureInfo">
                        <xsl:value-of select="$GetFeatureInfo-proxy"/>
                        <xsl:text>?</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$value"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="WMT_MS_Capabilities">
    	<error/>
    </xsl:template>
<!--
    <xsl:template match="wms:Post"/>
    
    <xsl:template match="sld:GetLegendGraphic" xmlns:sld="http://www.opengis.net/sld"/>
 
    <xsl:template match="@xlink:href[parent::wms:OnlineResource/parent::wms:Service]">
        <xsl:attribute name="xlink:href">Clients That Use This For Requests Should Fail</xsl:attribute>
    </xsl:template>
    
    <xsl:template match="wms:LegendURL"/>
-->
 	<xsl:template match="@*|text()">
		<xsl:copy-of select="."/>
	</xsl:template>

 	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
</xsl:transform>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="pHttpPort" />
  <xsl:param name="pAjpPort" />

  <!-- Identity transform -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Service[@name='Catalina']">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <!-- Insert HTTP Connector, if missing -->
      <xsl:if test="$pHttpPort and not(Connector[@protocol='HTTP/1.1'])">
        <xsl:text>&#10;</xsl:text>
        <Connector port="7990" protocol="HTTP/1.1"
                  connectionTimeout="20000"
                  useBodyEncodingForURI="true"
                  redirectPort="8443"
                  compression="on"
                  compressableMimeType="text/html,text/xml,text/plain,text/css,application/json,application/javascript,application/x-javascript">
          <xsl:attribute name="port">
            <xsl:value-of select="$pHttpPort"/>
          </xsl:attribute>
        </Connector>
      </xsl:if>
      <!-- Insert AJP Connector, if missing -->
      <xsl:if test="$pAjpPort and not(Connector[@protocol='AJP/1.3'])">
        <xsl:text>&#10;</xsl:text>
        <Connector port="8009" enableLookups="false" protocol="AJP/1.3" URIEncoding="UTF-8">
          <xsl:attribute name="port">
            <xsl:value-of select="$pAjpPort"/>
          </xsl:attribute>
        </Connector>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Change HTTP Port / Remove HTTP Connector -->
  <xsl:template match="Connector[@protocol='HTTP/1.1']">
    <xsl:if test="$pHttpPort">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:attribute name="port">
          <xsl:value-of select="$pHttpPort"/>
        </xsl:attribute>
        <xsl:apply-templates select="node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <!-- Change AJP Port / Remove AJP Connector -->
  <xsl:template match="Connector[@protocol='AJP/1.3']">
    <xsl:if test="$pAjpPort">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
          <xsl:attribute name="port">
            <xsl:value-of select="$pAjpPort"/>
          </xsl:attribute>
        <xsl:apply-templates select="node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

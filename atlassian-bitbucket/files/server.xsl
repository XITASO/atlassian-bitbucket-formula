<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="pHttpPort" select="'{{ config.get('http_port') }}'" />
  <xsl:param name="pAjpPort" select="'{{ config.get('ajp_port') }}'" />

  <!-- Identity transform -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

{% if config.get('http_port') %}
  <!-- Insert HTTP Connector, if missing -->
  <xsl:template match="Service[@name='Catalina' and not(Connector[@protocol='HTTP/1.1'])]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
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
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Change HTTP Port -->
  <xsl:template match="Connector[@protocol='HTTP/1.1']/@port">
    <xsl:attribute name="port">
      <xsl:value-of select="$pHttpPort"/>
    </xsl:attribute>
  </xsl:template>
{% else %}
  <!-- Remove HTTP Connector -->
  <xsl:template match="Connector[@protocol='HTTP/1.1']"/>
{% endif %}

{% if config.get('ajp_port') %}
  <!-- Insert AJP Connector, if missing -->
  <xsl:template match="Service[@name='Catalina' and not(Connector[@protocol='AJP/1.3'])]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <Connector port="8009" enableLookups="false" protocol="AJP/1.3" URIEncoding="UTF-8">
        <xsl:attribute name="port">
          <xsl:value-of select="$pAjpPort"/>
        </xsl:attribute>
      </Connector>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Change AJP Port -->
  <xsl:template match="Connector[@protocol='AJP/1.3']/@port">
    <xsl:attribute name="port">
      <xsl:value-of select="$pAjpPort"/>
    </xsl:attribute>
  </xsl:template>
{% else %}
  <!-- Remove AJP Connector -->
  <xsl:template match="Connector[@protocol='AJP/1.3']"/>
{% endif %}
</xsl:stylesheet>

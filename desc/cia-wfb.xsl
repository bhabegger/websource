<?xml version="1.0" encoding="iso-8859-1" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" indent="yes" />
  <xsl:template match="/">
    <country-description>
      <name><xsl:value-of select="substring-after(/html:html/html:head/html:title,'-- ')" /></name>
      <coordinates>
        <xsl:value-of select="normalize-space(//html:tr[contains(html:td/html:div[@class='category'],'Geographic coordinates')]/following::html:tr/html:td/html:div[@class='category_data'])" />
      </coordinates>
      <population>
      </population>
    </country-description>
  </xsl:template>
</xsl:stylesheet>

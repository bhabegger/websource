<?xml version="1.0" encoding="iso-8859-1" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" />
  <xsl:template match="/">
    <country-description>
      <name><xsl:value-of select="normalize-space(/html/body/table[1]//tr[3]/td[2])" /></name>
      <coordinates>
	<xsl:value-of select="normalize-space(//table//tr/td[contains(.,'Geographic coordinates')]/following-sibling::td[1])" />  
      </coordinates>
      <population>
	<xsl:value-of
	  select="substring-before(normalize-space(//table//tr/td[contains(.,'Population')]/following-sibling::td[1]),' ')" />  
      </population>
    </country-description>
  </xsl:template>
</xsl:stylesheet>

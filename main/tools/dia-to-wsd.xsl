<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dia="http://www.lysator.liu.se/~alla/dia/"
  xmlns:ws="http://wwwsource.free.fr/ns/websource">
  <xsl:output method="xml" indent="yes" />
  
  <xsl:template match="dia:diagram" >
    <ws:source>
      <xsl:apply-templates select="dia:layer/dia:object[@type='UML - Class']" />
    </ws:source>
  </xsl:template>

  <xsl:template match="dia:object[@type='UML - Class']">
    <xsl:variable name="type"
      select="substring-before(substring-after(dia:attribute[@name='name'],'#'),'#')" />
    <xsl:variable name="id" select="@id" />
    <xsl:variable name="name">
      <xsl:apply-templates mode="name-of" select="descendant::dia:composite" />
    </xsl:variable>
    <xsl:variable name="forward">
      <xsl:for-each select='//dia:connections[dia:connection[@handle="0" and @to=$id]]/dia:connection[@handle="1"]/@to' >
        <xsl:if test="position() > 1">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:variable name="nid" select="." />
        <xsl:apply-templates mode="name-of" 
            select="//dia:object[@id=$nid]/descendant::dia:composite" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$type = 'ws:query'">
	<ws:query name="{$name}" forward-to="{$forward}">
	  
	</ws:query>
      </xsl:when>
      <xsl:when test="$type = 'ws:fetch'">
	<ws:fetch name="{$name}" forward-to="{$forward}" >
	  
	</ws:fetch>
      </xsl:when>
      <xsl:when test="$type = 'ws:filter'">
	<ws:filter name="{$name}" forward-to="{$forward}" >
	  
	</ws:filter>
      </xsl:when>
      <xsl:when test="$type = 'ws:extract'">
	<ws:extract name="{$name}" forward-to="{$forward}" >
	  
	</ws:extract>
      </xsl:when>
      <xsl:otherwise>
	<ws:dummy name="{$name}"  forward-to="{$forward}" unknown-type="{$type}" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dia:composite" mode="name-of">
    <xsl:variable name="aname"
        select="substring-before(substring-after(dia:attribute[@name='name']/dia:string,'#'),'#')" />
    <xsl:if test="$aname='name'">
      <xsl:value-of select="substring-before(substring-after(dia:attribute[@name='value']/dia:string,'#'),'#')" />
    </xsl:if>
  </xsl:template>
</xsl:stylesheet> 




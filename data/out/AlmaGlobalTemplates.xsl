<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat(substring($date,1,4),substring($date,6,2),substring($date,9,2))"/>
	</xsl:template>

	<xsl:template name="deleteLeadingZeros">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="starts-with($value,0)">
				<xsl:call-template name="deleteLeadingZeros">
					<xsl:with-param name="value">
						<xsl:value-of select="substring($value,2,string-length($value) - 1)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addLeadingZeros">
		<xsl:param name="value"/>
		<xsl:param name="length"/>
		<xsl:choose>
			<xsl:when test="number($value) &gt; 0 and string-length($value) &lt; $length">
				<xsl:call-template name="addLeadingZeros">
					<xsl:with-param name="value">
						<xsl:value-of select="concat('0',$value)"/>
					</xsl:with-param>
					<xsl:with-param name="length" select="$length"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="findCharacterFromEnd">
		<xsl:param name="field"/>
		<xsl:param name="character"/>
		<xsl:param name="position"/>
		<xsl:choose>
			<xsl:when test="substring($field,$position,1) = $character">
				<xsl:value-of select="$position"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="findCharacterFromEnd">
					<xsl:with-param name="field" select="$field"/>
					<xsl:with-param name="character" select="$character"/>
					<xsl:with-param name="position" select="$position - 1"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getName">
		<xsl:param name="name"/>
		<xsl:param name="name2"/>
		<xsl:choose>
			<xsl:when test="string-length($name) &gt; 40">
				<xsl:variable name="space">
					<xsl:call-template name="findCharacterFromEnd">
						<xsl:with-param name="field" select="$name"/>
						<xsl:with-param name="character" select="' '"/>
						<xsl:with-param name="position" select="40"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$space &gt; 30">
						<Name1>
							<xsl:value-of select="substring($name,1,$space)"/>
						</Name1>
						<Name2>
							<xsl:value-of select="substring($name,$space + 1)"/>
						</Name2>
					</xsl:when>
					<xsl:otherwise>
						<Name1>
							<xsl:value-of select="substring($name,1,40)"/>
						</Name1>
						<Name2>
							<xsl:value-of select="substring($name,41)"/>
						</Name2>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<Name1>
					<xsl:value-of select="$name"/>
				</Name1>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$name2 != ''">
			<xsl:choose>
				<xsl:when test="string-length($name2) &gt; 40">
					<xsl:variable name="space2">
						<xsl:call-template name="findCharacterFromEnd">
							<xsl:with-param name="field" select="$name2"/>
							<xsl:with-param name="character" select="' '"/>
							<xsl:with-param name="position" select="40"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$space2 &gt; 30">
							<Name3>
								<xsl:value-of select="substring($name2,1,$space2)"/>
							</Name3>
							<Name4>
								<xsl:value-of select="substring($name2,$space2 + 1)"/>
							</Name4>
						</xsl:when>
						<xsl:otherwise>
							<Name3>
								<xsl:value-of select="substring($name2,1,40)"/>
							</Name3>
							<Name4>
								<xsl:value-of select="substring($name2,41)"/>
							</Name4>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<Name3>
						<xsl:value-of select="$name2"/>
					</Name3>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>		
	</xsl:template>

</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2008. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios/>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->
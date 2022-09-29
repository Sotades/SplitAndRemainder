<?xml version="1.0"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<!--Rename 'root' node to 'GMT_Alma_Global_Accounting' and add namespace-->
	<xsl:template match="root">
		<GMT_Alma_Global_Accounting xmlns="urn:alma:fi:Global">
			<xsl:apply-templates select="@* | node()"/>
		</GMT_Alma_Global_Accounting>
	</xsl:template>

	<!--Rename 'AccountingDocument' node to 'Accounting'-->
	<xsl:template match="AccountingDocument">
		<Accounting>
			<xsl:apply-templates select="@* | node()"/>
		</Accounting>
	</xsl:template>

	<!--Remove 'GeneralLedgerAccountItems' node-->
	<xsl:template match="GeneralLedgerAccountItems">
		<xsl:apply-templates/>
	</xsl:template>

	<!--Convert 'DocumentDate' format from ddmmyyyy to yyyymmdd-->
	<xsl:template match="DocumentDate">
		<DocumentDate>
			<xsl:value-of select="concat(substring(.,5,4), substring(.,3,2), substring(.,1,2))"/>
		</DocumentDate>
	</xsl:template>

	<!--Convert 'PostingDate' format from ddmmyyyy to yyyymmdd-->
	<xsl:template match="PostingDate">
		<PostingDate>
			<xsl:value-of select="concat(substring(.,5,4), substring(.,3,2), substring(.,1,2))"/>
		</PostingDate>
	</xsl:template>

	<!--Convert DocumentValue subnodes from nodes to attributes-->
	<xsl:template match="DocumentValue">
		<DocumentValue>
			<xsl:attribute name="Currency" select="Currency/text()"/>
			<xsl:attribute name="Sign" select="sign/text()"/>
			<xsl:value-of select="Value"/>
		</DocumentValue>
	</xsl:template>


</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Convert New XML Format to Old XML Format" userelativepaths="yes" externalpreview="no" url="..\XML\ATCPI-190 HTTP Version Before Mapping.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes"
		          profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""
		          validateoutput="no" validator="internal" customvalidator="">
			<advancedProp name="bSchemaAware" value="true"/>
			<advancedProp name="xsltVersion" value="2.0"/>
			<advancedProp name="schemaCache" value="||"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bGenerateByteCode" value="true"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="sInitialMode" value=""/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
--><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="ATCPI-190 Converted New Format with Issue AGMy0dsOa90TiDF1_tymKSYtBk86.xml" userelativepaths="yes" externalpreview="no" url="ATCPI-190 Converted New Format with Issue AGMy0dsOa90TiDF1_tymKSYtBk86.xml" htmlbaseurl=""
		          outputurl="ATCPI-190 Converted Old Format with Issue AGMy0dsOa90TiDF1_tymKSYtBk86.xml" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath=""
		          additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="">
			<advancedProp name="bSchemaAware" value="true"/>
			<advancedProp name="xsltVersion" value="2.0"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bGenerateByteCode" value="true"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="sInitialMode" value=""/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->
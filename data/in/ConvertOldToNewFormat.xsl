<?xml version='1.0'?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<!--Rename 'GMT_Alma_Global_Accounting' node to 'root' and remove namespace-->
	<xsl:template match="/*[local-name()='GMT_Alma_Global_Accounting' and namespace-uri()='urn:alma:fi:Global']">
		<root>
			<AccountingDocument>
				<xsl:for-each select="/*[local-name()='GMT_Alma_Global_Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='AccountingHeader' and namespace-uri()='urn:alma:fi:Global']">
					<xsl:copy>
							<xsl:apply-templates select="@* | node()"/>
					</xsl:copy>
				</xsl:for-each>
				<xsl:for-each select="/*[local-name()='GMT_Alma_Global_Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='GeneralLedgerAccountItem' and namespace-uri()='urn:alma:fi:Global']">
					<xsl:copy>
						<xsl:apply-templates select="@* | node()"/>
					</xsl:copy>
				</xsl:for-each>
			</AccountingDocument>
		</root>
	</xsl:template>

	<!--Convert DocumentValue subnodes from attributes to nodes-->
	<xsl:template match="/*[local-name()='GMT_Alma_Global_Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='GeneralLedgerAccountItem' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='DocumentValue' and namespace-uri()='urn:alma:fi:Global']">
		<DocumentValue>
			<Value>
				<xsl:value-of select="./text()"/>
			</Value>
			<Currency>
				<xsl:value-of select="./@Currency"/>
			</Currency>
			<sign>
				<xsl:value-of select="./@Sign"/>
			</sign>
		</DocumentValue>
	</xsl:template>

	<!--Convert dates from yyyymmdd to ddmmyyyy-->
	<xsl:template match="/*[local-name()='GMT_Alma_Global_Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='AccountingHeader' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='DocumentDate' and namespace-uri()='urn:alma:fi:Global']">
		<DocumentDate>
			<xsl:value-of select="concat(substring(.,7,2), substring(.,5,2), substring(.,1,4))"/>
		</DocumentDate>
	</xsl:template>

	<xsl:template match="/*[local-name()='GMT_Alma_Global_Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='Accounting' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='AccountingHeader' and namespace-uri()='urn:alma:fi:Global']/*[local-name()='PostingDate' and namespace-uri()='urn:alma:fi:Global']">
		<PostingDate>
			<xsl:value-of select="concat(substring(.,7,2), substring(.,5,2), substring(.,1,4))"/>
		</PostingDate>
	</xsl:template>









</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Convert Old XML Format to New XML Format" userelativepaths="yes" externalpreview="no" url="..\XML\ATCPI-190 Converted New to Old XML Format.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes"
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
		<scenario default="yes" name="ATCPI-190 Converted to Old Format with Issue AGMy0dsOa90TiDF1_tymKSYtBk86.xml" userelativepaths="yes" externalpreview="no" url="..\out\ATCPI-190 Converted to Old Format with Issue AGMy0dsOa90TiDF1_tymKSYtBk86.xml"
		          htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none"
		          postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="">
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
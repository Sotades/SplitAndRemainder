<?xml version="1.0"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="AlmaGlobalTemplates.xsl"/>
	<xsl:param name="receiverName"/>
	<xsl:param name="receiverType"/>
	<xsl:param name="receiverPort"/>
	<xsl:param name="senderName"/>
	<xsl:param name="senderType"/>
	<xsl:param name="senderPort"/>
	<xsl:template match="/">
		<ACC_DOCUMENT04>
			<xsl:for-each select="root/AccountingDocument">
				<IDOC BEGIN="1">
					<EDI_DC40 SEGMENT="1">
						<TABNAM>EDI_DC40</TABNAM>
						<DIRECT>2</DIRECT>
						<IDOCTYP>ACC_DOCUMENT04</IDOCTYP>
						<MESTYP>ACC_DOCUMENT</MESTYP>
						<MESCOD/>
						<SNDPOR>
							<xsl:value-of select="$senderPort"/>
						</SNDPOR>
						<SNDPRT>
							<xsl:value-of select="$senderType"/>
						</SNDPRT>
						<SNDPRN>
							<xsl:text>ZI_MUISTIO</xsl:text>
						</SNDPRN>
						<RCVPOR>
							<xsl:value-of select="$receiverPort"/>
						</RCVPOR>
						<RCVPRT>
							<xsl:value-of select="$receiverType"/>
						</RCVPRT>
						<RCVPRN>
							<xsl:value-of select="$receiverName"/>
						</RCVPRN>
					</EDI_DC40>
					<E1BPACHE09 SEGMENT="1">
						<USERNAME>
							<xsl:choose>
								<xsl:when test="normalize-space(AccountingHeader/UserID) != ''">
									<xsl:value-of select="AccountingHeader/UserID"/>
								</xsl:when>
								<xsl:otherwise>RFC_CPI</xsl:otherwise>
							</xsl:choose>
						</USERNAME>
						<HEADER_TXT>
							<xsl:value-of select="AccountingHeader/HeaderText"/>
						</HEADER_TXT>
						<COMP_CODE>
							<xsl:value-of select="AccountingHeader/Company"/>
						</COMP_CODE>
						<xsl:variable name="DocumentDate">
							<xsl:value-of select="concat(substring(AccountingHeader/DocumentDate, 5,4), substring(AccountingHeader/DocumentDate,3,2), substring(AccountingHeader/DocumentDate, 1,2))"/>
						</xsl:variable>
						<DOC_DATE>
							<xsl:value-of select="$DocumentDate"/>
						</DOC_DATE>
						<xsl:variable name="PostingDate">
							<xsl:value-of select="concat(substring(AccountingHeader/PostingDate, 5,4), substring(AccountingHeader/PostingDate,3,2), substring(AccountingHeader/PostingDate, 1,2))"/>
						</xsl:variable>
						<PSTNG_DATE>
							<xsl:value-of select="$PostingDate"/>
						</PSTNG_DATE>
						<FISC_YEAR>
							<xsl:value-of select="AccountingHeader/FiscalYear"/>
						</FISC_YEAR>
						<FIS_PERIOD>
							<xsl:value-of select="AccountingHeader/FiscalPeriod"/>
						</FIS_PERIOD>
						<DOC_TYPE>
							<xsl:value-of select="AccountingHeader/DocumentType"/>
						</DOC_TYPE>
						<REF_DOC_NO>
							<xsl:value-of select="AccountingHeader/ReferenceDocument"/>
						</REF_DOC_NO>
					</E1BPACHE09>
					<xsl:for-each select="GeneralLedgerAccountItems/GeneralLedgerAccountItem">
						<E1BPACGL09 SEGMENT="1">
							<ITEMNO_ACC>
								<xsl:call-template name="addLeadingZeros">
									<xsl:with-param name="length" select="10"/>
									<xsl:with-param name="value" select="ItemNo"/>
								</xsl:call-template>
							</ITEMNO_ACC>
							<GL_ACCOUNT>
								<xsl:call-template name="addLeadingZeros">
									<xsl:with-param name="length" select="10"/>
									<xsl:with-param name="value" select="Account"/>
								</xsl:call-template>
							</GL_ACCOUNT>
							<ITEM_TEXT>
								<xsl:value-of select="ItemText"/>
							</ITEM_TEXT>
							<REF_KEY_1>
								<xsl:value-of select="Customer"/>
							</REF_KEY_1>
							<REF_KEY_2>
								<xsl:value-of select="Vendor"/>
							</REF_KEY_2>
							<COMP_CODE>
								<xsl:value-of select="CrossCompanyID"/>
							</COMP_CODE>
							<FUNC_AREA>
								<xsl:value-of select="FunctionalArea"/>
							</FUNC_AREA>
							<PLANT>
								<xsl:value-of select="Plant"/>
							</PLANT>
							<ALLOC_NMBR>
								<xsl:value-of select="AssignmentNumber"/>
							</ALLOC_NMBR>
							<TAX_CODE>
								<xsl:value-of select="TaxCode"/>
							</TAX_CODE>
							<COSTCENTER>
								<xsl:call-template name="addLeadingZeros">
									<xsl:with-param name="length" select="10"/>
									<xsl:with-param name="value" select="CostCenter"/>
								</xsl:call-template>
							</COSTCENTER>
							<PROFIT_CTR>
								<xsl:value-of select="ProfitCenter"/>
							</PROFIT_CTR>
							<PART_PRCTR>
								<xsl:value-of select="PartnerProfitCenter"/>
							</PART_PRCTR>
							<ORDERID>
								<xsl:call-template name="addLeadingZeros">
									<xsl:with-param name="length" select="12"/>
									<xsl:with-param name="value" select="InternalOrder"/>
								</xsl:call-template>
							</ORDERID>
							<MATERIAL>
								<xsl:call-template name="addLeadingZeros">
									<xsl:with-param name="length" select="18"/>
									<xsl:with-param name="value" select="Material"/>
								</xsl:call-template>
							</MATERIAL>
							<TRADE_ID>
								<xsl:value-of select="PartnerCode"/>
							</TRADE_ID>
							<CS_TRANS_T>
								<xsl:value-of select="TransactionKey"/>
							</CS_TRANS_T>
						</E1BPACGL09>
					</xsl:for-each>

					<xsl:for-each select="GeneralLedgerAccountItems/GeneralLedgerAccountItem">
						<xsl:call-template name="valueLines"/>
					</xsl:for-each>
					<xsl:if test="normalize-space(AccountingHeader/ReversalDate) != ''">
						<xsl:variable name="ReversalDate">
							<xsl:value-of select="concat(substring(AccountingHeader/ReversalDate, 5,4), substring(AccountingHeader/ReversalDate,3,2), substring(AccountingHeader/ReversalDate, 1,2))"/>
						</xsl:variable>
						<E1BPPAREX SEGMENT="1">
							<STRUCTURE>
								<xsl:text>REVERSAL_DATE</xsl:text>
							</STRUCTURE>
							<VALUEPART1>
								<xsl:value-of select="$ReversalDate"/>
							</VALUEPART1>
						</E1BPPAREX>
					</xsl:if>
					<xsl:if test="normalize-space(AccountingHeader/ParkDocument) != ''">
						<E1BPPAREX SEGMENT="1">
							<STRUCTURE>
								<xsl:text>PARK_DOCUMENT</xsl:text>
							</STRUCTURE>
							<VALUEPART1>
								<xsl:value-of select="AccountingHeader/ParkDocument"/>
							</VALUEPART1>
						</E1BPPAREX>
					</xsl:if>
					<xsl:if test="normalize-space(AccountingHeader/ParkDocument) = ''">
						<E1BPPAREX SEGMENT="1">
							<STRUCTURE>CALCULATE_TAXES</STRUCTURE>
							<VALUEPART1>X</VALUEPART1>
						</E1BPPAREX>
					</xsl:if>
				</IDOC>
			</xsl:for-each>
		</ACC_DOCUMENT04>
	</xsl:template>
	<xsl:template name="valueLines">
		<E1BPACCR09 SEGMENT="1">
			<ITEMNO_ACC>
				<xsl:call-template name="addLeadingZeros">
					<xsl:with-param name="length" select="10"/>
					<xsl:with-param name="value" select="ItemNo"/>
				</xsl:call-template>
			</ITEMNO_ACC>
			<CURRENCY_ISO>
				<xsl:choose>
					<xsl:when test="normalize-space(DocumentValue/Currency) != ''">
						<xsl:value-of select="DocumentValue/Currency"/>
					</xsl:when>
					<xsl:otherwise>EUR</xsl:otherwise>
				</xsl:choose>
			</CURRENCY_ISO>
			<AMT_DOCCUR>
				<xsl:value-of select="concat(DocumentValue/Value,DocumentValue/sign)"/>
			</AMT_DOCCUR>
		</E1BPACCR09>
		<xsl:if test="LocalValue and normalize-space(LocalValue/Currency) != '' and normalize-space(DocumentValue/Currency) != '' and normalize-space(DocumentValue/Currency) != 'EUR'">
			<E1BPACCR09 SEGMENT="1">
				<ITEMNO_ACC>
				<xsl:call-template name="addLeadingZeros">
					<xsl:with-param name="length" select="10"/>
					<xsl:with-param name="value" select="ItemNo"/>
				</xsl:call-template>
				</ITEMNO_ACC>
				<CURR_TYPE>10</CURR_TYPE>
				<CURRENCY_ISO>
					<xsl:value-of select="LocalValue/Currency"/>
				</CURRENCY_ISO>
				<AMT_DOCCUR>
					<xsl:value-of select="concat(LocalValue/Value,LocalValue/Sign)"/>
				</AMT_DOCCUR>
			</E1BPACCR09>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="ATCPI-190 Converted back to new Format with Issue AGMy0dsOa90TiDF1_tymKSYtBk86.xml" userelativepaths="yes" externalpreview="no" url="ATCPI-190 Converted back to new Format with Issue AGMy0dsOa90TiDF1_tymKSYtBk86.xml"
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
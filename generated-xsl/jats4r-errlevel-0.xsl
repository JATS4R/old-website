<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:sch="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="2.0"
                mml:dummy-for-xmlns=""
                xsi:dummy-for-xmlns=""
                xlink:dummy-for-xmlns="">

<!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--KEYS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-FULL-PATH-->
<xsl:template match="*|@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>@*[local-name()='schema' and namespace-uri()='http://purl.oclc.org/dsdl/schematron']</xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:choose>
         <xsl:when test="count(. | ../namespace::*) = count(../namespace::*)">
            <xsl:value-of select="concat('.namespace::-',1+count(namespace::*),'-')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA METADATA-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:attribute name="phase">errors</xsl:attribute>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1998/Math/MathML" prefix="mml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">permissions-errors</xsl:attribute>
            <xsl:attribute name="name">permissions-errors</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">math-errors</xsl:attribute>
            <xsl:attribute name="name">math-errors</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


<!--PATTERN permissions-errors-->


	<!--RULE -->
<xsl:template match="license" priority="4000" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="license"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="normalize-space(@xlink:href)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(@xlink:href)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>ERROR: &lt;license&gt; must have an @xlink:href that refers to a publicly available license.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="@*|node()" mode="M6"/>
   </xsl:template>

   <!--PATTERN math-errors-->


	<!--RULE -->
<xsl:template match="mml:math | tex-math" priority="4000" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mml:math | tex-math"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="ancestor::disp-formula or ancestor::inline-formula"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::disp-formula or ancestor::inline-formula">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>ERROR: Math expressions must be in &lt;disp-formula&gt; or &lt;inline-formula&gt; elements. They should not appear directly in &lt;<xsl:text/>
                  <xsl:value-of select="name(parent::node())"/>
                  <xsl:text/>&gt;.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="disp-formula | inline-formula" priority="3999" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="disp-formula | inline-formula"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(child::graphic) + count(child::tex-math) + count(child::mml:math)&lt; 2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(child::graphic) + count(child::tex-math) + count(child::mml:math)&lt; 2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>ERROR: Formula element should contain only one expression. If these are alternate representations of the same expression, use &lt;alternatives&gt;. If they are different expressions, tag each in its own &lt;<xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>&gt;.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
<xsl:if test="(graphic or inline-graphic) and not(mml:math or tex-math)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(graphic or inline-graphic) and not(mml:math or tex-math)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>ERROR: All mathematical expressions should be provided in markup using either &lt;mml:math&gt; or &lt;tex-math&gt;. Do not supply math simply as graphics.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="@*|node()" mode="M9"/>
   </xsl:template>
</xsl:stylesheet>
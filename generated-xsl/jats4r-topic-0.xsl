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
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1998/Math/MathML" prefix="mml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">permissions-errors</xsl:attribute>
            <xsl:attribute name="name">permissions-errors</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M5"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">permissions-warnings</xsl:attribute>
            <xsl:attribute name="name">permissions-warnings</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">permissions-info</xsl:attribute>
            <xsl:attribute name="name">permissions-info</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">math-errors</xsl:attribute>
            <xsl:attribute name="name">math-errors</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">math-warnings</xsl:attribute>
            <xsl:attribute name="name">math-warnings</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">math-info</xsl:attribute>
            <xsl:attribute name="name">math-info</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


<!--PATTERN permissions-errors-->


	<!--RULE -->
<xsl:template match="license" priority="4000" mode="M5">
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

		    <!--REPORT -->
<xsl:if test="@license-type">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@license-type">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>ERROR: @license-type is not machine readable and therefore should not be used. License type information should be derived instead from the URI given in the @xlink:href attribute.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="copyright-holder" priority="3999" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="copyright-holder"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="preceding-sibling::copyright-year"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="preceding-sibling::copyright-year">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>ERROR: The &lt;copyright-year&gt; and &lt;copyright-holder&gt; elements are intended for machine-readability. Therefore, when there is a copyright (i.e. the article is not in the public domain) we recommend that both of these elements be used. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="copyright-year" priority="3998" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="copyright-year"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="following-sibling::copyright-holder"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="following-sibling::copyright-holder">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>ERROR: The &lt;copyright-year&gt; and &lt;copyright-holder&gt; elements are intended for machine-readability. Therefore, when there is a copyright (i.e. the article is not in the public domain) we recommend that both of these elements be used. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="copyright-year" priority="3997" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="copyright-year"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="number() and number() &gt; 999 and number() &lt; 10000"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="number() and number() &gt; 999 and number() &lt; 10000">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>ERROR: &lt;copyright-year&gt; must be a 4-digit year, not "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
<xsl:if test="normalize-space(string(.))!=string(.)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="normalize-space(string(.))!=string(.)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>ERROR: &lt;copyright-year&gt; should not contain whitespace.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="@*|node()" mode="M5"/>
   </xsl:template>

   <!--PATTERN permissions-warnings-->


	<!--RULE -->
<xsl:template match="copyright-statement" priority="4000" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="copyright-statement"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="following-sibling::copyright-holder"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="following-sibling::copyright-holder">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>WARNING: If a &lt;copyright-statement&gt; is provided,  &lt;copyright-holder&gt; should also be provided for machine-readability.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="@*|node()" mode="M6"/>
   </xsl:template>

   <!--PATTERN permissions-info-->


	<!--RULE -->
<xsl:template match="license" priority="4000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="license"/>

		    <!--REPORT -->
<xsl:if test="license-p[1]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="license-p[1]">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>INFO: The &lt;license-p&gt; element is intended to be human-readable documentation, and any content is allowed, including, for example, &lt;ext-link&gt; elements with URIs. Such URIs within the &lt;license-p&gt; element will be ignored. (It is the responsibility of the content producer to ensure that the human-readable version of the license statement matches the (machine-readable) license URI.)</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
<xsl:if test="p[1]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="p[1]">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>INFO: The &lt;p&gt; element in &lt;license&gt; is intended to be human-readable documentation, and any content is allowed, including, for example, &lt;ext-link&gt; elements with URIs. Such URIs within the &lt;license-p&gt; element will be ignored. (It is the responsibility of the content producer to ensure that the human-readable version of the license statement matches the (machine-readable) license URI.)</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="license/p | license/license-p" priority="3999" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="license/p | license/license-p"/>

		    <!--REPORT -->
<xsl:if test="ext-link">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ext-link">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>INFO: Any link in the text of a license should be to a human-readable license that does not contradict the machine-readable lincense referenced at license/@xlink:href.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="copyright-statement" priority="3998" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="copyright-statement"/>

		    <!--REPORT -->
<xsl:if test="self::node()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="self::node()">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>INFO: The content of the &lt;copyright-statement&gt; is intended for display; i.e. human consumption. Therefore, the contents of this element aren't addressed by these recommendations.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="copyright-holder" priority="3997" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="copyright-holder"/>

		    <!--REPORT -->
<xsl:if test="self::node()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="self::node()">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>INFO: The &lt;copyright-holder&gt; element should identify the person or institution that holds the copyright. As yet, we have no recommendations regarding the manner in which that person or institution is identified (i.e. no recommendations for using any particular authority).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="@*|node()" mode="M7"/>
   </xsl:template>

   <!--PATTERN math-errors-->


	<!--RULE -->
<xsl:template match="mml:math | tex-math" priority="4000" mode="M8">
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
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="disp-formula | inline-formula" priority="3999" mode="M8">
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
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="@*|node()" mode="M8"/>
   </xsl:template>

   <!--PATTERN math-warnings-->


	<!--RULE -->
<xsl:template match="disp-formula | inline-formula" priority="4000" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="disp-formula | inline-formula"/>

		    <!--REPORT -->
<xsl:if test="(graphic or inline-graphic) and not(mml:math or tex-math)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(graphic or inline-graphic) and not(mml:math or tex-math)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>WARNING: All mathematical expressions should be provided in markup using either &lt;mml:math&gt; or &lt;tex-math&gt;. The only instance in which the graphic representation of a mathematical expression should be used outside of &lt;alternatives&gt; and without the equivalent markup is where that expression is so complicated that it cannot be represented in markup at all.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="@*|node()" mode="M9"/>
   </xsl:template>

   <!--PATTERN math-info-->


	<!--RULE -->
<xsl:template match="disp-formula | inline-formula" priority="4000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="disp-formula | inline-formula"/>

		    <!--REPORT -->
<xsl:if test="alternatives">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="alternatives">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>INFO: &lt;alternatives&gt; may contain any combination of representations (&lt;graphic&gt;, &lt;mml:math&gt;, &lt;tex-math&gt;) but where it is used, each representation should be correct, complete and logically equivalent with every other representation present. There is no explicit or implied preferred representation within &lt;alternatives&gt;.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
<xsl:if test="tex-math">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="tex-math">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-get-full-path"/>
            </xsl:attribute>
            <svrl:text>INFO: The content of the &lt;tex-math&gt; element should be math-mode LaTeX, without the delimiters that are normally used to switch into / out of math mode (\\[...\\], \\(...\\), $$...$$, etc.). </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="@*|node()" mode="M10"/>
   </xsl:template>
</xsl:stylesheet>
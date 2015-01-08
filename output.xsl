<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    version="1.0" exclude-result-prefixes="svrl">

   <xsl:output method="html" omit-xml-declaration="yes" standalone="no" indent="yes"/>

   <xsl:template match="svrl:schematron-output">
       <xsl:result-document href="#results">
           <h2>Checks</h2>

           <ul>
               <xsl:apply-templates select="svrl:active-pattern"/>
           </ul>

           <xsl:choose>
               <xsl:when test="svrl:failed-assert">
                   <h2>Failed assertions</h2>

                   <table>
                       <thead>
                           <tr>
                               <th>Location</th>
                               <th>Error</th>
                           </tr>
                       </thead>

                       <tbody>
                           <xsl:apply-templates select="svrl:failed-assert"/>
                       </tbody>
                   </table>
               </xsl:when>
               <xsl:otherwise>
                   <p>No errors were detected.</p>
               </xsl:otherwise>
           </xsl:choose>
       </xsl:result-document>
   </xsl:template>

   <xsl:template match="svrl:active-pattern">
       <li>
           <xsl:value-of select="@name"/>
       </li>
   </xsl:template>

   <xsl:template match="svrl:failed-assert">
      <tr>
          <td>
              <xsl:value-of select="@location"/>
          </td>
          <td>
              <xsl:apply-templates select="svrl:text"/>
          </td>
      </tr>
   </xsl:template>
</xsl:stylesheet>

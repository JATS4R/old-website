---
layout: default
title: Permissions recommendations
---


## Status: Final

## Context 

\<permissions> and child elements \<copyright-statement>, \<copyright-year>, \<copyright-holder>, \<license>, \<license-p>, \<ali:free_to_read>, and \<ali:license_ref>


## Description

These recommendations contain best practices for indicating the permissions (copyright and licensing information) associated with an article as a whole, or with part of an article (such as a figure). For a list of document objects and the corresponding elements to which \<permissions> can apply, please see [this list](#where-permissions-may-be-applied-in-a-document). The permissions information associated with the whole document is contained within the article metadata.


## Remarks

1. <a id='rem1'></a> Per the JATS documentation, \<copyright-statement> and \<license-p> are intended for display purposes only, and are therefore not addressed by these recommendations because they are not intended to be mined for data. The \<license-p> element is the domain for editorial information and context. Links to licenses might appear within these human-readable sections, but those links should not assumed to be machine readable, and should be ignored by automated processes. *Validator result: info*{:.validator-result}

2. <a name='rem2' id='rem2'></a> In some cases, an article may contain document objects (such as figures or tables) that have licenses which are different from the license that applies to the article as a whole. For example, a CC-BY journal article might contain a figure reproduced from an article published under a non-CC-BY licence. That figure must then contain a separate \<permissions> element; every other article object will be considered to inherit the permissions as set out in \<article-meta>, which applies to the journal article as a whole. Multiple components of an article can have their own \<permissions> element and, if tagged as such, each of these components would not inherit the permission set in the \<article-meta>. The separate \<permissions> provided for the component must be complete, containing \<copyright-statement>, \<copyright-year>, \<copyright-holder>, and \<license>.

3. <a name='rem3' id='rem3'></a> Concerning @license-type on \<license> element: This attribute can be useful inside a closed system. However, in terms of reusing content, the values of this attribute have not been standardized (i.e., its values are not controlled and are therefore not usable by automated systems), so  it can’t be used to provide reliably useful information, and therefore a formal recommendation has not been made for this attribute here.  *Validator result: info*{:.validator-result}


## Recommendations

1. <a name='rec1' id='rec1'></a> **\<permissions> (permissions on the whole article).** This element must be present within \<article-meta>. *Validator result: Error*{:.validator-result}

2. <a name='rec2' id='rec2'></a> **\<permissions> (permissions on objects within an article).** If any object within the article (for example, a figure or a table) has different permissions from the article as a whole, \<permissions> must be included in that element to ensure the object does not inherit the permissions that apply to the document as a whole. (See [the complete list of article objects to which \<permissions> can apply](#where-permissions-may-be-applied-in-a-document)). *Validator result: Info*{:.validator-result}

3. <a name='rec3' id='rec3'></a> **\<copyright-year>.** When a work is protected by copyright (i.e., the work is not in the public domain), this element should be used and should contain a full four-digit year with no whitespace. *Validator result: Error*{:.validator-result}

4. <a name='rec4' id='rec4'></a> **\<copyright-holder>.** When a work is protected by copyright, this element should be used and should identify the person or institution that holds the copyright. *Validator result: Error*{:.validator-result}

5. <a name='rec5' id='rec5'></a> **@xlink:href on \<license> or \<ali:license_ref> (depending on the DTD version).** If a license is defined by a URI (for example, any of the Creative Commons licenses), this should be the sole place that a machine (or anyone) should need to look for the license URI.
    1. {:.lettered-list} For JATS version 1.1d3 and forward, the license URI should be contained within **\<ali:license_ref>**. *Validator result: Warning when \<ali:license_ref> does not contain the URL for the license*{:.validator-result}
    2. {:.lettered-list} For JATS version 1.1d2 and backward,  use the URI as the value of @xlink:href on \<license>. *Validator result: Warning when \<license> doesn’t have @xlink:href*{:.validator-result}

6. <a name='rec6' id='rec6'></a> **@start_date attribute on \<ali:license_ref>.** This attribute is only required if it differs from the publication date.

7. <a name='rec7' id='rec7'></a> **\<license-p>.** This element is not required, but is intended for human readable consumption so there are no guidelines for the content used within the tag. Not to be used for the machine-readable, canonical URI for the license. *Validator result: Info whenever \<license-p> or \<p> occurs inside \<license>*{:.validator-result}

8. <a name='rec8' id='rec8'></a> **\<ali:free_to_read>.** Content that is not behind access barriers, irrespective of any license specifications, should also contain this tag. It is used to indicate the content can be accessed by any user without payment or authentication.  If the content is only available for a certain period, then @start_date and @end_date attributes can be used to indicate this. *Validator result: Info*{:.validator-result}


## Example 1: Permissions that apply to an entire journal article


### Example 1a: JATS version 1.1d3 and forward

```markup
<article  xmlns:ali="http://www.niso.org/schemas/ali/1.0" ...>
  ...
  <permissions>
    <copyright-statement>© 2014 Surname et al.</copyright-statement>
    <copyright-year>2014</copyright-year>
    <copyright-holder>Surname et al.</copyright-holder>
    <ali:free_to_read/>
    <license>
      <ali:license_ref start_date="2014-02-03"
        >http://creativecommons.org/licenses/by/4.0/</ali:license_ref>
      <license-p>This is an open access article distributed under the terms of the 
        <ext-link ext-link-type="uri" 
          xlink:href="http://creativecommons.org/licenses/by/4.0/">Creative
          Commons Attribution License</ext-link>, which permits unrestricted use, 
        distribution, reproduction and adaptation in any medium and for any purpose 
        provided that it is properly attributed. For attribution, the original 
        author(s), title, publication source (PeerJ) and either DOI or URL of the 
        article must be cited.</license-p>
    </license>
  </permissions>
  ...
</article>
```


### Example 1b: JATS version 1.1d2 and backward

```markup
<permissions>
  <copyright-statement>© 2014 Surname et al.</copyright-statement>
  <copyright-year>2014</copyright-year>
  <copyright-holder>Surname et al.</copyright-holder>
  <license xlink:href="http://creativecommons.org/licenses/by/4.0/">
    <license-p>This is an open access article distributed under the terms of the 
      <ext-link ext-link-type="uri" 
        xlink:href="http://creativecommons.org/licenses/by/4.0/">Creative
        Commons Attribution License</ext-link>, which permits unrestricted use,
      distribution, reproduction and adaptation in any medium and for any purpose 
      provided that it is properly attributed. For attribution, the original
      author(s), title, publication source (PeerJ) and either DOI or URL of the
      article must be cited.</license-p>
  </license>
</permissions>
```

## Example 2: Permissions that apply to part of a work (e.g., a figure) 

```markup
<fig id="fig1">
  <label>Fig. 1</label>
  <caption>...</caption>
  <!--
    Here, this particular image is published under a copyright that is different 
    from the one that applies to the article a whole (and is, in fact, all rights 
    reserved).
  -->
  <permissions>
    <copyright-statement>The National Portrait Gallery, London. All rights
      reserved</copyright-statement>
    <copyright-year>2013</copyright-year>
    <!-- Note:  no license element here:  all rights reserved. -->
  </permissions>
  <graphic xlink:href="images/fig1"/>
</fig>
```


## Example 3: Multiple permissions on a single figure

The following examples illustrates a case where a single, composite figure is the subject of two separate copyrights. In this case, multiple \<permissions> elements are given for that figure. A machine attempting to parse this, to determine the re-usability of that figure, would have to pick the most restrictive of the licences (in this case, no licence, or “all rights reserved”).

```markup
<article>
  <front>
    ...
    <permissions>
      <copyright-statement>&#xa9; 2012, Alegado et al</copyright-statement>
      <copyright-year>2012</copyright-year>
      <copyright-holder>Alegado et al</copyright-holder>
      <license xlink:href="http://creativecommons.org/licenses/by/4.0/">
        <license-p>This article is distributed under the terms of the <ext-link
            ext-link-type="uri"
            xlink:href="http://creativecommons.org/licenses/by/4.0/">Creative
          Commons Attribution License</ext-link>, which permits unrestricted use
          and redistribution provided that the original author and source are
          credited.</license-p>
      </license>
    </permissions>
    ...
  </front>
  <body>
    ...
    <fig id="fig2" position="float">
      <label>Figure 2.</label>
      <caption> . . . </caption>
      <graphic xmlns:xlink="http://www.w3.org/1999/xlink" 
        xlink:href="elife00013f002"/>
      <permissions>
        <copyright-statement>© 1977 Thieme Medical Publishers. All Rights
          Reserved.</copyright-statement>
        <copyright-year>1977</copyright-year>
        <copyright-holder>Thieme Medical Publishers</copyright-holder>
        <license>
          <license-p>Figure 1, upper panel, is reproduced from
            <xref ref-type="bibr"  rid="bib45">Hughes and Sperandio, 2008</xref>
            with permission.</license-p>
        </license>
      </permissions>
      <permissions>
       <copyright-statement>&#xa9; 2012, Alegado et al</copyright-statement>
       <copyright-year>2012</copyright-year>
        <copyright-holder>Alegado et al</copyright-holder>
        <license xlink:href="http://creativecommons.org/licenses/by/4.0/">
          <license-p>Figure 1, lower panel, is distributed under ...</license-p>
        </license>
      </permissions>
    </fig>
    ...
  </body>
  ...
</article>
```


## Where \<permissions> may be applied in a document

Per the [JATS schema](http://jatspan.org/niso/publishing-1.0/#p=elem-permissions), the \<permissions> element is allowed within many other elements.

The following table specifies what content is covered by a \<permissions> element that appears in a given location.

<table>
  <tr>
    <th>Document object</th>
    <th>Element that may contain &lt;permissions></th>
    <th>What the permissions cover</th>
  </tr>
  <tr>
    <td>Array</td>
    <td>&lt;array></td>
    <td><em>Self</em></td>
  </tr>
  <tr>
    <td>Article as a whole</td>
    <td>&lt;article></td>
    <td><em>Closest parent article element</em></td>
  </tr>
  <tr>
    <td>Boxed text</td>
    <td>&lt;boxed-text></td>
    <td><em>Self</em></td>
  </tr>
  <tr>
    <td>Chemical structure</td>
    <td>&lt;chem-struct-wrap></td>
    <td><em>Self</em></td>
  </tr>
  <tr>
    <td>Displayed quotation</td>
    <td>&lt;disp-quote></td>
    <td><em>Self</em></td>
  </tr>
  <tr>
    <td>Figure</td>
    <td>&lt;fig></td>
    <td><em>The whole figure, and any associated files</em></td>
  </tr>
  <tr>
    <td>Response or sub-article metadata</td>
    <td>&lt;front-stub></td>
    <td><em>The closest response or sub-article parent</em></td>
  </tr>
  <tr>
    <td>Graphic</td>
    <td>&lt;graphic></td>
    <td><em>The image file (@xlink:href) and its description</em></td>
  </tr>
  <tr>
    <td>Media</td>
    <td>&lt;media></td>
    <td><em>The media file (@xlink:href) and its description</em></td>
  </tr>
  <tr>
    <td>Preformatted text</td>
    <td>&lt;preformat></td>
    <td><em>The contents of the element</em></td>
  </tr>
  <tr>
    <td>Section metadata</td>
    <td>&lt;sec></td>
    <td><em>Closest parent sec element</em></td>
  </tr>
  <tr>
    <td>Statement</td>
    <td>&lt;statement></td>
    <td><em>Self</em></td>
  </tr>
  <tr>
    <td>Supplementary material</td>
    <td>&lt;supplementary-material></td>
    <td><em>The supplemental file (@xlink:href) and its description</em></td>
  </tr>
  <tr>
    <td>Tables and their captions</td>
    <td>&lt;table-wrap></td>
    <td><em>The table, caption, etc.</em></td>
  </tr>
  <tr>
    <td>Tables, notes in the footer</td>
    <td>&lt;table-wrap></td>
    <td><em>Closest parent table-wrap element</em></td>
  </tr>
  <tr>
    <td>Verse group</td>
    <td>&lt;verse-group></td>
    <td><em>Self</em></td>
  </tr>
</table>


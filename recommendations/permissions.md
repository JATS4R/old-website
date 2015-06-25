---
layout: default
title: Permissions recommendations
---

## Status

The status of this page is: final recommendation.

## See also

* [Permissions tagged examples](https://github.com/JATS4R/elements/blob/master/permissions.md)
* [Issues - permissions label](https://github.com/JATS4R/elements/labels/permissions)

## Context

The \<permissions> element should be present within the \<article-meta> section of the \<front> matter. It is the container for all of the article's copyright and licensing information and can contain the following repeatable elements in this order:

* \<copyright-statement>
* \<copyright-year>
* \<copyright-holder>
* \<license>

Within \<license> is the \<license-p> element, which contains the human readable license statement.

## Recommendations

Per the JATS documentation, the content of the [\<copyright-statement>](http://jatspan.org/niso/publishing-1.1d1/#p=elem-copyright-statement) is intended for display; i.e. human consumption.  Therefore, the contents of this element aren't addressed by these recommendations.

The [\<copyright-year>]() and [\<copyright-holder>]() elements, on the other hand, are intended for machine-readability.  Therefore, when there is a copyright (i.e. the article is not in the public domain) we recommend that both of these elements be used.  The contents of the \<copyright-year> element should be the full four-digit year, with no whitespace.  The \<copyright-holder> element should identify the person or institution that holds the copyright. As yet, we have no recommendations regarding the manner in which that person or institution is identified (i.e. no recommendations for using any particular authority).

If a license is defined by a URI (as are Creative Commons licenses), this URI must be put in the @xlink:href attribute of the \<license> element within \<permissions>. This should be the sole place that a machine (or anyone) should need to look for the license URI.

If the license does not have a canonical, persistent, published URI that identifies it then the \<license> element *must not have* an @xlink:href attribute.  Links to human-readable license documents should *only* appear within the \<license-p> elements.

Currently, the only license URIs that meet these requirements are those published by Creative Commons.

The attribute @license-type for \<license> is not machine readable and therefore should not be used. License type information should be derived instead from the URI given in the @xlink:href attribute.

The \<license-p> element is intended to be human-readable documentation, and any content is allowed, including, for example, \<ext-link> elements with URIs.  Such URIs within the \<license-p> element will be ignored. (It is the responsibility of the content producer to ensure that the human-readable version of the license statement matches the (machine-readable) license URI.)



```markup
<permissions>
  <copyright-statement>© 2014 Surname et al.</copyright-statement>
  <copyright-year>2014</copyright-year>
  <copyright-holder>Surname et al.</copyright-holder>
  <license xlink:href="http://creativecommons.org/licenses/by/4.0/">
    <license-p>This is an open access article distributed under the terms of the <ext-link
        ext-link-type="uri" xlink:href="http://creativecommons.org/licenses/by/4.0/">Creative
        Commons Attribution License</ext-link>, which permits unrestricted use, distribution,
      reproduction and adaptation in any medium and for any purpose provided that it is properly
      attributed. For attribution, the original author(s), title, publication source (PeerJ) and
      either DOI or URL of the article must be cited.</license-p>
  </license>
</permissions>
```

### Multiple licenses for different components

[See for example the [Open Book Publisher's example](https://github.com/JATS4R/elements/blob/master/permissions.md#open-book-publishers)]

In some cases a document may consist of multiple components (such as a book split into chapters or an article containing figures and table), where one or more of the individual components is published under a license different from that applied to the rest of the article. So, for example, a CC-BY journal article might contain a figure reproduced from an article published under a non-CC-BY licence. That figure must then contain a separate \<permissions> element.

Every other component of the document will be considered to inherit the permissions as set out in the \<article-meta> (or equivalent section). The separate \<permissions> provided for the figure must be complete, containing \<copyright-statement>, \<copyright-year>, \<copyright-holder> and \<license>. This is illustrated for a book and a journal, respectively, in the following examples.

```markup
<book>
  <book-meta>
    ...
    <!--
      The top-level permissions apply to the book as a whole, and any of its
      parts, unless a part has its own permissions element.
    -->
    <permissions>
      <copyright-statement>Margaret Harper Mills and Warwick Gould, CC BY-NC-ND</copyright-statement>
      <copyright-year>2013</copyright-year>
      <license xlink:href="http://creativecommons.org/licenses/by-nc-nd/4.0/"/>
        <license-p>This volume is published under ...</license-p>
      </license>
    </permissions>
  </book-meta>
  <front-matter>...</front-matter>
  <book-body>
    <book-part id="ch1" book-part-type="chapter">
      <book-part-meta>
        ...
        <!--
          This book part is published under a different copyright, and so
          needs its own permissions element.
        -->
        <permissions>
          <copyright-statement>Warwick Gould, CC BY-NC-ND 4.0</copyright-statement>
          <copyright-year>2013</copyright-year>
          <!--
            Even though the license URI is the same as that for the book, it
            must be repeated,  otherwise this part would be considered to be
            "all rights reserved".
          -->
          <license xlink:href="http://creativecommons.org/licenses/by-nc-nd/4.0/"/>
            <license-p>This chapter is published under ...</license-p>
          </license>
        </permissions>
      </book-part-meta>

      <body>
        ...
        <fig id="fig1">
          <label>Fig. 1</label>
          <caption>...</caption>
          <!--
            This particular image is also published under a different copyright,
            and is, in fact, all rights reserved.
          -->
          <permissions>
            <copyright-statement>The National Portrait Gallery, London. All rights
              reserved</copyright-statement>
            <copyright-year>2013</copyright-year>
            <!-- Note:  no license element here:  all rights reserved. -->
          </permissions>
          <graphic xlink:href="images/fig1"/>
        </fig>
        ...
      </body>
    </book-part>
  </book-body>
  <book-back>...</book-back>
</book>
```

The following examples illustrates a case where a single, composite figure is the subject of two separate copyrights. In this case, multiple \<permissions> elements are given for that figure. A machine attempting to parse this, to determine the re-usability of that figure, would have to pick the most restrictive of the licences (in this case, no licence, or "all rights reserved").

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
      <graphic xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="elife00013f002"/>
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

## Applicability of permissions elements

Per the [JATS schema](http://jatspan.org/niso/publishing-1.0/#p=elem-permissions), the \<permissions> element is allowed within many other elements.

The following table specifies what content is covered by a \<permissions> element that appears in a given location.

| `permissions` container  | Element to which permissions apply | Notes |
|--------------------------|------------------------------------|-------|
| `array`                  | `array`                    | Self |
| `article-meta`           | `article`                  | Closest parent `article` element |
| `boxed-text`             | `boxed-text`               | Self |
| `chem-struct-wrap`       | `chem-struct-wrap`         | Self |
| `disp-quote`             | `disp-quote`               | Self |
| `fig`                    | `fig`                      | The whole figure, and any associated files |
| `front-stub`             | `response` or `sub-article` | The closest `response` or `sub-article` parent |
| `graphic`                | `graphic`                  | The image file (`@xlink:href`) - and its description |
| `media`                  | `media`                    | The media file (`@xlink:href`) - and its description |
| `preformat`              | `preformat`                | The contents of the element |
| `sec-meta`               | `sec`                      | Closest parent `sec` element |
| `statement`              | `statement`                | Self |
| `supplementary-material` | `supplementary-material`   | The supplemental file (@xlink:href) - and its description |
| `table-wrap`             | `table-wrap`               | The table, caption, etc. |
| `table-wrap-foot`        | `table-wrap`               | Closest parent `table-wrap` element |
| `verse-group`            | `verse-group`              | Self |
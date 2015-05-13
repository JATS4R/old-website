---
layout: default
title: Math recommendations
---

## Status

The status of this page is: final recommendation.

## See also

* [Math tagged examples](https://github.com/JATS4R/elements/blob/master/math.md)
* [Math related GitHub issues](https://github.com/JATS4R/elements/issues?q=is%3Aopen+is%3Aissue+label%3Amath)

## Basic recommendations

All mathematical expressions should be enclosed in an &lt;inline-formula> element (for expressions within the flow of text) or a &lt;disp-formula> element (for display equations).

For example, an inline fraction might be tagged as follows

```markup
The number of reservoir holes for this pattern is
<inline-formula id='M1'><tex-math>\frac{5}{4}</tex-math></inline-formula>.
```

The use of images to represent mathematical expressions is strongly discouraged. Math should be marked up within &lt;inline-formula&gt; and &lt;disp-formula&gt; using either &lt;tex-math&gt; or &lt;mml:math&gt;. If a graphical version of a mathematical expression is needed due to display requirements, &lt;alternatives&gt; should be used. This should be placed within &lt;inline-formula&gt; or &lt;disp-formula&gt; and should contain the graphical version within &lt;inline-graphic&gt; (for an &lt;inline-formula&gt;) or &lt;graphic&gt; (for a &lt;disp-formula&gt;) alongside the equivalent &lt;mml:math&gt; or &lt;tex-math&gt; mark-up.

&lt;alternatives&gt; may contain any combination of representations (&lt;graphic&gt;, &lt;mml:math&gt;, &lt;tex-math&gt;), but at most one of each. And, where used, each representation should be correct, complete and logically equivalent with every other representation present. There is no explicit or implied preferred representation within &lt;alternatives&gt;.

The only instance in which the graphic representation of a mathematical expression should be used outside of &lt;alternatives&gt; and without the equivalent mark-up is where that expression is so complicated that it cannot be represented in mark-up at all.

The following example illustrates how a single equation can be provided in three alternate, equivalent forms.

```markup
<p>This was calculated as follows:
  <inline-formula id="M1">
    <alternatives>
      <tex-math>a=b</tex-math>
      <mml:math>
        <mml:mi>a</mml:mi>
        <mml:mo>=</mml:mo>
        <mml:mi>b</mml:mi>
      <inline-graphic xlink:href="equation_M1.gif"/>
    </alternatives>
  </inline-formula> ....</p>
```

## TeX math

The content of the \<tex-math> element should be math-mode LaTeX, *without* the delimiters that are normally used to switch into and out of math mode (`\\[...\\]`, `\\(...\\)`, `$$...$$`, etc.). For example:

```markup
<disp-formula>
  <tex-math id='M1'>a = b</tex-math>
</disp-formula>
```

> ***Rationale:*** the TeX enclosed in the \<tex-math> element is only used within JATS articles to produce mathematics, so specifying that the content is in math-mode precludes ambiguities that could arise if more general-purpose TeX structures were included (such as, for example, commands to produce tables of contents).

The only exception to this is that a subset of the LaTeX environments can be used to wrap the entire contents. (These are normally not permitted in math-mode.) These are typically used to specify alignment for multi-line equations.  These are of the form `\begin{XXX} ... \end{XXX}`. Those environments that are permitted by MathJax are also allowed within the \<tex-math> element; see [MathJax TeX and LaTeX Support - Environments](http://docs.mathjax.org/en/latest/tex.html#environments) for a list. For example:

```markup
<disp-formula>
  <tex-math id='M1'>
    \begin{align*}
      x^2 + y^2 &amp; = 1\\
      x         &amp; = \sqrt{1-y^2}
    \end{align*}
  </tex-math>
</disp-formula>
```

Note that XML CDATA sections can be used to aid in embedding TeX markup within the XML of a JATS document.  This obviates the need to use escape sequences such as `&amp;` for an ampersand. Using a CDATA section, the previous example would appear as follows.

```markup
<disp-formula>
  <tex-math id='M1'><![CDATA[
    \begin{align*}
      x^2 + y^2 & = 1\\
      x         & = \sqrt{1-y^2}
    \end{align*}
  ]]></tex-math>
</disp-formula>
```

### TeX math macro definitions

TeX macros can be defined in a \<custom-meta> element, with the \<meta-name> element value set to "tex-math-definitions". For example:

```markup
<article-meta>
  ...
  <custom-meta>
    <meta-name>tex-math-definitions</meta-name>
    <meta-value>
      \def\rmi{\rm i}
      \def\rme{\rm e}
    </meta-value>
  </custom-meta>
</article-meta>
```

The macros defined within this element could then be used in any TeX equation within the article.

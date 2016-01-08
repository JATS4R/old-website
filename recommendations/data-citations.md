---
layout: default
title: Data citations recommendations
---


## Status: Final

## Context 

\<ref> and elements contained therein.


## Description

These recommendations contain best practices for tagging citations to data sets in a reference list.

1. These recommendations only apply to JATS 1.1d2 and forward, because the tags needed to make data citations machine readable are only available from 1.1d2 onwards.

2. The following recommendations are specifically about citations related to data and data sets. Recommendations for citations in general will be published at a later time.


## Additional reading

[Adapting JATS to support data citation](http://www.ncbi.nlm.nih.gov/books/NBK280240/)

[Force 11 Joint Declaration on Data Citation Principles](https://www.force11.org/group/joint-declaration-data-citation-principles-final)



## Recommendations

1. <a name='rec1' id='rec1'></a> **@publication-type="data" on \<mixed-citation> or \<element-citation>.** Use "data" as the value of @publication-type to indicate that the citation is to a data set, even if that data set is the entire data repository. *Validator result: error if @ not “data” and \<data-title> is present*{:.validator-result}

2. <a name='rec2' id='rec2'></a> **@person-group-type on \<person-group>.** As of version 1.1d2, the list of values for this attribute includes “[curator](http://jats.nlm.nih.gov/publishing/tag-library/1.1d2/attribute/person-group-type.html)”, specifically to support data citations. Use “curator” whenever appropriate. *Validator result: info*{:.validator-result}

3. <a name='rec3' id='rec3'></a> **\<data-title> / \<source>.** At least one of \<data-title> or \<source> must be present. \<data-title> should hold the title of the data set. \<source> should contain the name of the holding repository. Both should be present if applicable. *Validator result: error if one not present*{:.validator-result}

4. <a name='rec4' id='rec4'></a> **\<year>.** This should contain the 4-digit year the data was deposited. (Or in the case of data sets updated regularly, the year the data was used in the work in which it is being cited.) *Validator result: error if year is not 4 digits*{:.validator-result}

5. <a name='rec5' id='rec5'></a> **\<pub-id>.** This element should be used to hold both the repository ID for the data, in the element content, and, if applicable, the full URI to the data, in the @xlink:href attribute. The URI should be a DOI or similar persistent identifier. The @pub-id-type attribute must be used -- see the next recommendation for details. *Validator result: info*{:.validator-result}

6. <a name='rec6' id='rec6'></a> **@pub-id-type on \<pub-id>.** In contrast to what is stated in the Tag Library (“Type of publication identifier or the organization or system that defined the identifier”) this attribute should only be used to state the type of identifier, and not to specify the organisation or system that defined the identifier . To specify the latter, use @assigning-authority (see the next recommendation). For example, a DOI that is assigned by CrossRef should have “doi” as the @pub-id-type, and “crossref” as the @assigning-authority. 

    For many types of identifiers, there is only one assigning authority. For example, PubMed IDs are always assigned by the National Library of Medicine. In these cases, use @pub-id-type and not @assigning-authority.

    *Validator result: defer result pending the discussion of the attribute value registry*{:.validator-result}

7. <a name='rec7' id='rec7'></a> **@assigning-authority on \<pub-id> and \<ext-link>.** When the given type of identifier can be assigned by more than one organisation, and the organisation registering the identifier is known, include the @assigning-authority attribute on the \<pub-id> element. Values might be, for example, “crossref” or “figshare”. Values should be in lowercase. *Validator result: info for now; may change pending attribute value registry implementation*{:.validator-result}

8. <a name='rec8' id='rec8'></a> **@designator on \<version>.** (1.1d2+). Use this attribute to contain the machine-readable version number of the dataset. The element contents can be a more human-readable note (see the example). *Validator result: error if not present*{:.validator-result}


## Example

```markup
<ref id="d1">
  <element-citation publication-type="data">
    <person-group person-group-type="author">
      <collab>The Concerto Consortium</collab>
      <name>
        <surname>van Beethoven</surname>
        <given-names>Ludwig</given-names>
      </name>
      <name>
        <surname>Liszt</surname>
        <given-names>F</given-names>
      </name>
    </person-group>
    <person-group person-group-type="curator">
      <name>
        <surname>Bach</surname>
        <given-names>JS</given-names>
      </name>
    </person-group>
    <data-title>Title of data set</data-title>
    <year iso-8601-date="2014">2014</year> 
    <source>Repository Name</source>
    <pub-id pub-id-type="doi" assigning-authority="figshare"
        xlink:href="http://dx.doi.org/10.1234/1234321">10.1234/1234321</pub-id>
    <version designator="16.2">16th version, second release</version>
  </element-citation>
</ref>

```

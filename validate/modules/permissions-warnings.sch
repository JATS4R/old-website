
<pattern id="permissions-warnings" xmlns="http://purl.oclc.org/dsdl/schematron">

    <!-- <copyright-statement> should be followed by a <copyright-holder> -->
    <rule context="copyright-statement">
        <assert test="following-sibling::copyright-holder">
            WARNING: If a &lt;copyright-statement&gt;
            is provided, &lt;copyright-holder&gt; should also be provided for
            machine-readability.
        </assert>
    </rule>
</pattern>

 
    <!-- tests for permissions, JATS4R GitHub issues #2, #11, #13 -->
<pattern id="permissions-errors"  xmlns="http://purl.oclc.org/dsdl/schematron">
        <rule context="license">
            <assert test="normalize-space(@xlink:href)">ERROR: &lt;license&gt; must have an @xlink:href that refers to a publicly available license.</assert>
        </rule>
    </pattern>
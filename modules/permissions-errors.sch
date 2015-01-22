 
    <!-- tests for permissions, JATS4R GitHub issues #2, #11, #13 -->
<pattern id="permissions-errors"  xmlns="http://purl.oclc.org/dsdl/schematron">

		  <!-- <license> must have an @xlink:href to the license URI -->
        <rule context="license">
            <assert test="normalize-space(@xlink:href)">ERROR: &lt;license&gt; must have an @xlink:href that refers to a publicly available license.</assert>
        </rule>
		  
		  		  <!-- <copyright-statement> must be followed by a <copyright-year> -->
		  <rule context="copyright-statement">
		  		<assert test="following-sibling::copyright-year">ERROR: If a &lt;copyright-statement&gt; is provided,  &lt;copyright-year&gt; must also be provided for machine-readability.</assert>
		  </rule>
		  
		  <!-- <copyright-year> should be a 4-digit number -->
		  <rule context="copyright-year">
		  		<assert test="number() and number() &gt; 999 and number() &lt; 10000">ERROR: &lt;copyright-year&gt; must be a 4-digit year, not "<value-of select="."/>".</assert>
		  </rule>
		  
    </pattern>

 
    <!-- tests for permissions, JATS4R GitHub issues #2, #11, #13 -->
<pattern id="permissions-errors"  xmlns="http://purl.oclc.org/dsdl/schematron">

		  <!-- <license> must have an @xlink:href to the license URI -->
        <rule context="license">
            <assert test="normalize-space(@xlink:href)">ERROR: &lt;license&gt; must have an @xlink:href that refers to a publicly available license.</assert>
				<report test="@license-type">ERROR: @license-type is not machine readable and therefore should not be used. License type information should be derived instead from the URI given in the @xlink:href attribute.</report>
        </rule>
		  
		  		  <!-- <copyright-statement> must be followed by a <copyright-year> -->
		  <rule context="copyright-holder">
		  		<assert test="preceding-sibling::copyright-year">ERROR: The &lt;copyright-year> and &lt;copyright-holder> elements are intended for machine-readability. Therefore, when there is a copyright (i.e. the article is not in the public domain) we recommend that both of these elements be used. </assert>
		  </rule>
		  <rule context="copyright-year">
		  		<assert test="following-sibling::copyright-holder">ERROR: The &lt;copyright-year> and &lt;copyright-holder> elements are intended for machine-readability. Therefore, when there is a copyright (i.e. the article is not in the public domain) we recommend that both of these elements be used. </assert>
		  </rule>
		  
		  <!-- <copyright-year> should be a 4-digit number -->
		  <rule context="copyright-year">
		  		<assert test="number() and number() &gt; 999 and number() &lt; 10000">ERROR: &lt;copyright-year&gt; must be a 4-digit year, not "<value-of select="."/>".</assert>
				<report test="normalize-space(string(.))!=string(.)">ERROR: &lt;copyright-year&gt; should not contain whitespace.</report>
		  </rule>
		  
    </pattern>


<pattern id="permissions-warnings" xmlns="http://purl.oclc.org/dsdl/schematron">

		  <!-- <copyright-year> should be a 4-digit number -->
		  <rule context="copyright-statement">
		  		<assert test="following-sibling::copyright-year and following-sibling::copyright-holder">WARNING: If a &lt;copyright-statement&gt; is provided, &lt;copyright-year&gt; and &lt;copyright-holder&gt; should also be provided for machine-readability.</assert>
		  </rule>
	</pattern>


<!-- tests for math formulae -->
<pattern id="math-errors" xmlns="http://purl.oclc.org/dsdl/schematron">
  <rule context="mml:math | tex-math">
    <assert test="ancestor::disp-formula or ancestor::inline-formula">ERROR: Math expressions must be in &lt;disp-formula&gt; or &lt;inline-formula&gt; elements. They should not appear directly in &lt;<value-of select="name(parent::node())"/>&gt;.</assert>
  </rule>
  
  <rule context="disp-formula | inline-formula">
    <assert test="count(child::graphic) + count(child::tex-math) + count(child::mml:math)&lt; 2">ERROR: Formula element should contain only one expression. If these are alternate representations of the same expression, use &lt;alternatives&gt;. If they are different expressions, tag each in its own &lt;<value-of select="name()"/>&gt;.</assert>

   <report test="(graphic or inline-graphic) and not(mml:math or tex-math)">ERROR: All mathematical expressions should be provided in markup using either &lt;mml:math&gt; or &lt;tex-math&gt;. Do not supply math simply as graphics.</report>    
	</rule>
	
</pattern>

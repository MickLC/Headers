<head>
<title>Header Examination</title>
</head>
<html>
<cfform action="default.cfm" method="post">
	<p>Enter your headers in the first box:</p>
	<textarea rows="15" cols="80" name="var1"></textarea><br />
	<button type="submit">Submit</button>
</cfform>
<cfif structKeyExists(form,'var1')>
	<cfset result1 = listToArray("#form.var1#",chr(13),false,true)>
	<!---<cfoutput>
		<textarea rows="100" cols="80">#result1#</textarea>
	</cfoutput>--->
	<cfdump var=#result1#>
</cfif>
</html>



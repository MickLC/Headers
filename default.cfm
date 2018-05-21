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
    <cftry>
	<cfset form.var1 = xmlFormat(form.var1) />

	<!--- Working definition of a keyword:  text between a newline(or the beginning of the text) and the first colon(followed immediately by a space),
	but only if there is no space somewhere before the colon--->
	<cfset HeaderAry = ArrayNew(2)>
	<cfset i = 1> <!---Input line number--->
	<cfset j=0> <!---Array element number--->
	<cfset lastReturn = 0> 
	<cfset nextReturn = 0>
	<cfset nextColon = 1> <!--- Temporary non-zero value to enter loop--->
	<cfwhile nextColon is not 0 and nextReturn is not len(form.var1) and j LT 35>
		<cfset nextSpace = find(" ", form.var1, lastReturn)>
		<cfset nextColon = find(": ", form.var1, lastReturn+1)>
		<cfset nextReturn = find(chr(13), form.var1,lastreturn+1)>
		<cfif nextreturn is 0>
			<cfset nextReturn = len(form.var1)>
		</cfif>
		<cfif nextColon LT  nextSpace and nextColon LT nextReturn and nextReturn is not 0>
			<cfset j = j + 1>
			<cfset HeaderAry[j][1] = #mid(form.var1,lastReturn + 1, nextColon-lastReturn)#>
			<cfset HeaderAry[j][2] = #mid(form.var1, nextColon + 1, nextReturn-nextColon)#>
		<cfelseif nextReturn is not 0>
			<cfset HeaderAry[j][2] = HeaderAry[j][2] & mid(form.var1,lastReturn+1,nextReturn-lastReturn)>
		</cfif>
		<cfset lastReturn = nextReturn>
	</cfwhile> 

	<cfxml variable="headerxml">
		<header>
		<cfoutput>
			<cfloop from = "1" to = "#j#" index = "k">
				<headerLine name="#HeaderAry[k][1]#" content="#HeaderAry[k][2]#" />
			</cfloop>
		</cfoutput>
		</header>
	</cfxml>


    <cfcatch type="any">
	<cfdump var="#cfcatch#">
    </cfcatch>
</cftry>
</cfif>
</html>



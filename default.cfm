<head>
<title>Header Examination</title>
</head>
<html>
<cfform action="default.cfm" method="post">
	<p>Enter your headers in the box:</p>
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

	<cfxml variable="headerxml" caseSensitive="no">
		<header>
		<cfoutput>
			<cfloop from = "1" to = "#j#" index = "k">
				<cfif #trim(HeaderAry[k][1])# EQ "To:">
					<cfset emailTo="#trim(HeaderAry[k][2])#">
					<cfset emailStart=#refindNoCase("&lt;",emailTo,1)#>
                                        <cfset emailEnd=#refindNoCase("&gt;",emailTo,1)#>
                                        <cfif emailStart GT "0">
                                                <cfset email = #mid(emailTo,emailStart+4,emailEnd-emailStart-4)#>
					<cfelse>
						<cfset email = #emailTo#>
					</cfif>
                                        <cfset domainStart=#refindNoCase("@",email,1)#>
                                        <cfset domain=#mid(email,domainStart+1,-1)#>
                                        <To<cfif isDefined("email")> email="#email#" domain="#domain#"</cfif>>#emailTo#</To>
				<cfelseif #trim(HeaderAry[k][1])# EQ "From:">
					<cfset emailFrom="#trim(HeaderAry[k][2])#">
                                        <cfset emailStart=#refindNoCase("&lt;",emailFrom,1)#>
                                        <cfset emailEnd=#refindNoCase("&gt;",emailFrom,1)#>
                                        <cfif emailStart GT "0">
                                                <cfset email = #mid(emailFrom,emailStart+4,emailEnd-emailStart-4)#>
                                                <cfset domainStart=#refindNoCase("@",email,1)#>
                                                <cfset domain=#mid(email,domainStart+1,-1)#>    
                                        </cfif>
                                        <From<cfif isDefined("email")> email="#email#" domain="#domain#"</cfif>>#emailFrom#</From>
				<cfelseif #trim(HeaderAry[k][1])# EQ "Subject:">
                                        <Subject>#HeaderAry[k][2]#</Subject>
                                <cfelseif #trim(HeaderAry[k][1])# EQ "Delivered-To:">
					<Delivered-To>#HeaderAry[k][2]#</Delivered-To>
                                <cfelseif #trim(HeaderAry[k][1])# EQ "Received:">
					<!---<Received>#HeaderAry[k][2]#</Received>--->
					<cfset ipStart=#refindNoCase("\[",HeaderAry[k][2],1)#>
					<cfset ipEnd=#refindNoCase("\]",HeaderAry[k][2],1)#>
					<cfif ipStart GT "0">
						<cfset IP = #mid(HeaderAry[k][2],ipStart+1,ipEnd-ipStart-1)#>
					</cfif>
					<cfset receiverStart = #refindNoCase("by",HeaderAry[k][2],1)#>
					<cfset receiverEnd = #refindNoCase(" ",HeaderAry[k][2],receiverStart+3)#>
					<cfset Receiver = #mid(HeaderAry[k][2],receiverStart+3,receiverEnd-receiverStart-3)#>
					<cfset dateSetUp=#right(HeaderAry[k][2],40)#>
					<cfset dateStart=#findNoCase(" ",dateSetUp,1)#>
					<cfset Date=#mid(dateSetUp,dateStart,-1)#>
					<Received <cfif ipStart GT "0">IP = "#IP#"</cfif> Receiver = "#Receiver#" Date="#Date#">#HeaderAry[k][2]#</Received>
                                <cfelseif #trim(HeaderAry[k][1])# EQ "Return-Path:">
					<Return-Path>#HeaderAry[k][2]#</Return-Path>
                                <cfelseif #trim(HeaderAry[k][1])# EQ "Message-Id:">
					<Message-Id>#HeaderAry[k][2]#</Message-Id>
                                <cfelseif #left(trim(HeaderAry[k][1]),2)# EQ "X-">
					<cfset headerlineend = #findnocase(":",HeaderAry[k][1],1)#>
                                        <cfset headerline = #mid(HeaderAry[k][1],2,headerlineend-2)#>
                                        <#headerline# type="x-header">#HeaderAry[k][2]#</#headerline#>
                                <cfelseif #trim(HeaderAry[k][1])# EQ "Content-Type:">
					<Content-Type>#HeaderAry[k][2]#</Content-Type>
                                <cfelseif #trim(HeaderAry[k][1])# EQ "Date:">
					<Date>#HeaderAry[k][2]#</Date>
                                <cfelseif #trim(HeaderAry[k][1])# EQ "MIME-Version:">
					<MIME-Version>#HeaderAry[k][2]#</MIME-Version>		
				<cfelse>
					<cfset headerlineend = #findnocase(":",HeaderAry[k][1],1)#>
					<cfset headerline = #mid(HeaderAry[k][1],2,headerlineend-2)#>
					<#headerline#>#HeaderAry[k][2]#</#headerline#>
				</cfif>
			</cfloop>
		</cfoutput>
		</header>
	</cfxml>

<!---<cfdump var="#headerxml#">--->

<cfset headerDoc = xmlparse(headerxml)>
<!---<cfdump var="#headerDoc#">--->

<cfset toDomain=headerDoc.header.To.xmlattributes.domain>

<cfscript>
        cfexecute(
                variable="digOut",
                name="dig mx",
                arguments="#toDomain#",
                timeout=3
        );
</cfscript>

<cfoutput>
<cfset answerStart = #refind("ANSWER SECTION",digOut,1)#>
<cfset mxpreStart = #refind("(MX)",digOut,answerStart)#>
<cfset mxStart = #refind("( \w)",digOut,mxpreStart+4)#>
<cfset mxEnd = #refindnocase(chr(10),digOut,mxStart)#>
<cfset mx = #mid(digOut,mxStart,mxEnd-mxStart-1)#>
<cfset mxArray = #listtoarray(mx,".")#>
<!---<p>MX = #mx#</p>--->

<cfset ipa = headerDoc.header.Received>
<cfset ips = arraylen(ipa)>

<cfloop index="i" from="1" to="#ips#">
	<cfif isDefined("headerDoc.header.Received[i].xmlattributes.ip")>
	<cfset ip = #headerDoc.header.Received[i].xmlattributes.ip#>
	<cfif ip NEQ "127.0.0.1">
		<cfset retain = #i#>
		<cfset receiver = #headerDoc.header.Received[i].xmlattributes.Receiver#>
		<cfset receiverArray = #listtoarray(receiver,".")#>
		<!---<p>#i# Receiver = #Receiver#</p>
		<p>#i# IP = #IP#</p>--->
	</cfif>
	</cfif>
</cfloop>

<cfset mxArray.retainAll(receiverArray)>
<cfset whatSame = arraytolist(mxArray)>

<!---=<cfdump var="#receiver#">
<cfdump var="#headerDoc.header.Received[retain].xmlattributes.ip#">
<cfdump var="#whatSame#">--->

<cfif arrayLen(mxArray) GT "1">
<cfscript>
        cfexecute(
                variable="whoisOut",
                name="whois",
                arguments="#headerDoc.header.Received[retain].xmlattributes.ip#",
                timeout=3
        );
</cfscript>

	<cfset abuseFindStart = #refind("abuse@",whoisOut,1)#>
	<cfif abuseFindStart EQ '0'>
		<cfset abuseFindStart = #refind("Abuse contact",whoisOut,1)#>
		<cfset abuseFindStart = #refind("is",whoisOut,abuseFindStart)#>
		<cfset abuseFindStart = #refind(" ",whoisOut,abuseFindStart)#>
	</cfif>
	<cfif abuseFindStart EQ '0'>
		<cfset abuseFindStart = #refind("OrgAbuseEmail:",whoisOut,1)#>
		<cfset abuseFindStart = #refind(" ",whoisOut,abuseFindStart)#>
	</cfif>
	<cfset abuseFindEnd = #refindnocase(chr(10),whoisOut,abuseFindStart)#>
	<cfset abuseFind = #rereplace(mid(whoisOut,abuseFindStart,abuseFindEnd-abuseFindStart),"[^0-9A-Za-z@.]","","all")#>

	<!---<p>abuseFindStart = #abuseFindStart#</p>
	<p>abuseFindEnd = #abuseFindEnd#</p>--->
        <p>Relevant Received header: <strong>Received: #headerDoc.header.Received[retain].XmlText#</strong></p>
	<p>Abuse contact from WHOIS = #abuseFind#</p>

</cfif>

</cfoutput>
    <cfcatch type="any">
	<cfdump var="#cfcatch#">
    </cfcatch>
</cftry>
</cfif>
</html>



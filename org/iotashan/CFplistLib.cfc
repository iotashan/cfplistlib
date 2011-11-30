<cfcomponent>
	<cffunction name="encode">
		<cfargument name="baseObject" type="struct"/>
		
		<cfxml variable="ret" casesensitive="true"><cfoutput>#header()#
		<cfloop array="#structKeyArray(ARGUMENTS.baseObject)#" index="local.thisObj">
			#encodeObject(local.thisObj,ARGUMENTS.baseObject[local.thisObj])#
		</cfloop>
		#footer()#</cfoutput></cfxml>
		
		<cfreturn ret />
	</cffunction>
	
	<cffunction name="encodeObject">
		<cfargument name="objName" type="string"/>
		<cfargument name="obj" type="any"/>
		
		<!--- if this is a struct --->
		<cfif isStruct(ARGUMENTS.obj) OR isObject(ARGUMENTS.obj)>
			<cfreturn encodeStruct(ARGUMENTS.objName,ARGUMENTS.obj) />
		<!--- if this is an array --->
		<cfelseif isArray(ARGUMENTS.obj)>
			<cfreturn encodeArray(ARGUMENTS.objName,ARGUMENTS.obj) />
		<!--- if this is anything else, assume a simple name/value pair --->
		<cfelseif isSimpleValue(ARGUMENTS.obj)>
			<cfreturn encodeString(ARGUMENTS.objName,ARGUMENTS.obj) />
		</cfif>
	</cffunction>
	
	<cffunction name="encodeStruct">
		<cfargument name="objName" type="string"/>
		<cfargument name="stObj" type="struct"/>
		
		<cfsavecontent variable="ret"><cfoutput><cfif len(ARGUMENTS.objName)><key>#ARGUMENTS.objName#</key></cfif><dict>
		<cfloop array="#structKeyArray(ARGUMENTS.stObj)#" index="local.thisObj">
			#encodeObject(local.thisObj,ARGUMENTS.stObj[local.thisObj])#
		</cfloop>
		</dict></cfoutput></cfsavecontent>
		
		<cfreturn ret />
	</cffunction>
	
	<cffunction name="encodeArray">
		<cfargument name="objName" type="string"/>
		<cfargument name="arObj" type="array"/>
		
		<cfsavecontent variable="ret"><cfoutput><cfif len(ARGUMENTS.objName)><key>#ARGUMENTS.objName#</key></cfif><array>
		<cfloop array="#ARGUMENTS.arObj#" index="local.thisObj">
			#encodeObject("",local.thisObj)#
		</cfloop>
		</array></cfoutput></cfsavecontent>
		
		<cfreturn ret />
	</cffunction>
	
	<cffunction name="encodeString">
		<cfargument name="objName" type="string"/>
		<cfargument name="sObj" type="string"/>
		
		<cfsavecontent variable="ret"><cfoutput>
			<cfif len(ARGUMENTS.objName)><key>#ARGUMENTS.objName#</key></cfif>
			<string>#xmlFormat(ARGUMENTS.sObj)#</string>
		</cfoutput></cfsavecontent>
		
		<cfreturn ret />
	</cffunction>
	
	<cffunction name="header" hint="just the top of the XML">
		<cfsavecontent variable="ret"><cfoutput><?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict></cfoutput></cfsavecontent>
		
		<cfreturn ret />
	</cffunction>
	
	<cffunction name="footer" hint="just the bottom of the XML">
		<cfsavecontent variable="ret"><cfoutput></dict></plist></cfoutput></cfsavecontent>
		
		<cfreturn ret />
	</cffunction>
</cfcomponent>
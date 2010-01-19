<cfcomponent output="false" displayname="Simple Sorting for Coldfusion on Wheels" mixin="model">

	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfset this.version = "1.0,1.1" />
		<cfreturn this />
	</cffunction>
	
	
	<cffunction name="simpleSorting" returntype="void" access="public" output="false" mixin="model">
		<cfargument name="sortColumn" type="string" default="sortOrder">
		<cfargument name="scope" type="string" default="">
		<cfset variables.wheels.class.simpleSorting = Duplicate(arguments)>
		<cfset variables.wheels.class.simpleSorting.scope = ListChangeDelims(variables.wheels.class.simpleSorting.scope,",",",")>
		<cfset variables.previousSortOrder = 0>
		<cfset beforeCreate(methods="$setDefaultSortOrder")>
		<cfset beforeUpdate(methods="$setPreviousSortOrder")>
		<cfset afterSave(methods="$updateSortOrderAfterSave")>
		<cfset afterDelete(methods="$updateSortOrderAfterDelete")>
	</cffunction>
	
	
	<cffunction name="$getSortColumn" returntype="string" mixin="model">
		<cfreturn variables.wheels.class.simpleSorting.sortColumn> 
	</cffunction>


	<cffunction name="$getSortScope" returntype="string" mixin="model">
		<cfreturn variables.wheels.class.simpleSorting.scope>
	</cffunction>
	
	
	<cffunction name="$setDefaultSortOrder" returntype="boolean" mixin="model">
		<cfset var loc = {}>
		<cfset loc.where = "">
		<cfloop list="#$getSortScope()#" index="loc.scope">
			<cfif Len(loc.where) gt 0>
				<cfset loc.where = loc.where & " AND ">
			</cfif>
			<cfset loc.where = loc.where & "#loc.scope# = '#this[loc.scope]#'">
		</cfloop>
		<cfset variables.previousSortOrder = this.maximum(property=$getSortColumn(),where=loc.where,reload=true)>
		<cfif not IsNumeric(variables.previousSortOrder)>
			<cfset variables.previousSortOrder = 0>
		</cfif>
		<cfset variables.previousSortOrder = variables.previousSortOrder + 1>
		<cfif not StructKeyExists(this,$getSortColumn())>
			<cfset this[$getSortColumn()] = variables.previousSortOrder>
		</cfif>
		<cfreturn true>
	</cffunction>
	

	<cffunction name="$setPreviousSortOrder" returntype="boolean" mixin="model">
		<cfset variables.previousSortOrder = variables.$persistedProperties[$getSortColumn()]>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="$updateSortOrderAfterSave" returntype="boolean" mixin="model">
		<cfset var loc = {}>
		<cfif variables.previousSortOrder neq this[$getSortColumn()]>
			<cfquery name="loc.qry" datasource="#variables.wheels.class.connection.datasource#">
			UPDATE	#tableName()#
			<cfif variables.previousSortOrder gt this[$getSortColumn()]>
			SET		#$getSortColumn()# = #$getSortColumn()# + 1
			WHERE	#$getSortColumn()# >= <cfqueryparam cfsqltype="#variables.wheels.class.properties[$getSortColumn()].type#" value="#this[$getSortColumn()]#"> 
			AND		#$getSortColumn()# < <cfqueryparam cfsqltype="#variables.wheels.class.properties[$getSortColumn()].type#" value="#variables.previousSortOrder#"> 
			<cfelseif variables.previousSortOrder lt this[$getSortColumn()]>
			SET		#$getSortColumn()# = #$getSortColumn()# - 1
			WHERE	#$getSortColumn()# <= <cfqueryparam cfsqltype="#variables.wheels.class.properties[$getSortColumn()].type#" value="#this[$getSortColumn()]#"> 
			AND		#$getSortColumn()# > <cfqueryparam cfsqltype="#variables.wheels.class.properties[$getSortColumn()].type#" value="#variables.previousSortOrder#"> 
			</cfif>
			AND		#primaryKey()# <> <cfqueryparam cfsqltype="#variables.wheels.class.properties[primaryKey()].type#" value="#this[primaryKey()]#">
			<cfloop list="#$getSortScope()#" index="loc.scope">
			AND 	#loc.scope# = <cfqueryparam cfsqltype="#variables.wheels.class.properties[loc.scope].type#" value="#this[loc.scope]#"> 
			</cfloop>
			</cfquery>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="$updateSortOrderAfterDelete" returntype="boolean" mixin="model">
		<cfset var loc = {}>
		<cfquery name="loc.qry" datasource="#variables.wheels.class.connection.datasource#">
		UPDATE	#tableName()#
		SET		#$getSortColumn()# = #$getSortColumn()# - 1
		WHERE	#$getSortColumn()# > <cfqueryparam cfsqltype="#variables.wheels.class.properties[$getSortColumn()].type#" value="#this[$getSortColumn()]#"> 
		<cfloop list="#$getSortScope()#" index="loc.scope">
		AND 	#loc.scope# = <cfqueryparam cfsqltype="#variables.wheels.class.properties[loc.scope].type#" value="#this[loc.scope]#"> 
		</cfloop>
		</cfquery>
		<cfreturn true>
	</cffunction>


</cfcomponent>
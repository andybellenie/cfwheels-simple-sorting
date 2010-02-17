<cfcomponent output="false" displayname="Simple Sorting for Coldfusion on Wheels" mixin="model">

	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset this.version = "1.0,1.0.2" />
		<cfreturn this />
	</cffunction>
	
	
	<cffunction name="simpleSorting" returntype="void" access="public" mixin="model" output="false">
		<cfargument name="sortColumn" type="string" default="sortOrder">
		<cfargument name="scope" type="string" default="">
		<cfset variables.wheels.class.simpleSorting = Duplicate(arguments)>
		<cfset variables.wheels.class.simpleSorting.scope = ListChangeDelims(variables.wheels.class.simpleSorting.scope,",",",")>
		<cfset beforeCreate(methods="$setDefaultSortOrder")>
		<cfset beforeUpdate(methods="$checkSortOrderBeforeUpdate")>
		<cfset afterSave(methods="$updateTableAfterSave")>
		<cfset afterDelete(methods="$updateTableAfterDelete")>
	</cffunction>
	
	
	<cffunction name="$getSortColumn" returntype="string" mixin="model" output="false">
		<cfreturn variables.wheels.class.simpleSorting.sortColumn> 
	</cffunction>


	<cffunction name="$getSortScope" returntype="string" mixin="model" output="false">
		<cfreturn variables.wheels.class.simpleSorting.scope>
	</cffunction>
	
	
	<cffunction name="$setDefaultSortOrder" returntype="boolean" mixin="model" output="false">
		<cfset variables.previousSortOrder = $getMaxSortOrder() + 1>
		<cfif not StructKeyExists(this,$getSortColumn()) or not IsNumeric(this[$getSortColumn()]) or this[$getSortColumn()] eq 0 or this[$getSortColumn()] gt variables.previousSortOrder>
			<cfset this[$getSortColumn()] = variables.previousSortOrder>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="$getMaxSortOrder" returntype="numeric" mixin="model" output="false">
		<cfset var loc = {}>
		<cfset loc.result = 0>
		<cfset loc.where = "">
		<cfloop list="#$getSortScope()#" index="loc.scope">
			<cfif Len(loc.where) gt 0>
				<cfset loc.where = loc.where & " AND ">
			</cfif>
			<cfset loc.where = loc.where & "#loc.scope# = '#this[loc.scope]#'">
		</cfloop>
		<cfset loc.result = this.maximum(property=$getSortColumn(),where=loc.where,reload=true)>
		<cfif not IsNumeric(loc.result)>
			<cfset loc.result = 0>
		</cfif>
		<cfreturn loc.result>
	</cffunction>
	

	<cffunction name="$checkSortOrderBeforeUpdate" returntype="boolean" mixin="model" output="false">
		<cfset var nextAvailableSortOrder = 0>
		<cfset variables.previousSortOrder = variables.$persistedProperties[$getSortColumn()]>
		<cfif StructKeyExists(this,$getSortColumn()) and hasChanged($getSortColumn())>
			<cfset nextAvailableSortOrder = $getMaxSortOrder() + 1>
			<cfif this[$getSortColumn()] eq 0 or this[$getSortColumn()] gt nextAvailableSortOrder>
				<cfset this[$getSortColumn()] = nextAvailableSortOrder>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="$updateTableAfterSave" returntype="boolean" mixin="model" output="false">
		<cfset var loc = {}>
		<cfif variables.previousSortOrder neq this[$getSortColumn()]>
			<cfquery name="loc.qry" datasource="#variables.wheels.class.connection.datasource#">
			UPDATE	#tableName()#
			<cfif variables.previousSortOrder gt this[$getSortColumn()]>
			SET		#$getSortColumn()# = #$getSortColumn()# + 1
			WHERE	#$getSortColumn()# >= <cfqueryparam cfsqltype="#variables.wheels.class.properties[$getSortColumn()].type#" value="#this[$getSortColumn()]#"> 
			AND		#$getSortColumn()# < <cfqueryparam cfsqltype="#variables.wheels.class.properties[$getSortColumn()].type#" value="#variables.previousSortOrder#"> 
			<cfelse>
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
	
	
	<cffunction name="$updateTableAfterDelete" returntype="boolean" mixin="model" output="false">
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
<cfcomponent output="false" displayname="Simple Sorting for Coldfusion on Wheels" mixin="model">

	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset this.version = "1.1,1.1.1,1.1.2,1.1.3,1.1.4,1.1.5,1.1.6,1.1.7" />
		<cfreturn this />
	</cffunction>
	
	
	<cffunction name="simpleSorting" returntype="void" access="public" mixin="model" output="false">
		<cfargument name="sortColumn" type="string" default="sortOrder">
		<cfargument name="scope" type="string" default="">
		<cfset variables.wheels.class.simpleSorting = Duplicate(arguments)>
		<cfset variables.wheels.class.simpleSorting.scope = ListChangeDelims(variables.wheels.class.simpleSorting.scope, ",", ",")>
		<cfset beforeValidationOnCreate(methods="$simpleSortingSetDefaultSortOrder")>
		<cfset beforeUpdate(methods="$simpleSortingCheckSortOrderBeforeUpdate")>
		<cfset afterSave(methods="$simpleSortingUpdateTableAfterSave")>
		<cfset afterDelete(methods="$simpleSortingUpdateTableAfterDelete")>
	</cffunction>
	
	
	<cffunction name="$simpleSortingSetDefaultSortOrder" returntype="boolean" mixin="model" output="false">
		<cfset variables.previousSortOrder = $simpleSortingGetMaxSortOrder() + 1>
		<cfif not StructKeyExists(this,variables.wheels.class.simpleSorting.sortColumn) or not IsNumeric(this[variables.wheels.class.simpleSorting.sortColumn]) or this[variables.wheels.class.simpleSorting.sortColumn] eq 0 or this[variables.wheels.class.simpleSorting.sortColumn] gt variables.previousSortOrder>
			<cfset this[variables.wheels.class.simpleSorting.sortColumn] = variables.previousSortOrder>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="$simpleSortingGetMaxSortOrder" returntype="numeric" mixin="model" output="false">
		<cfset var loc = {}>
		<cfset loc.where = "">
		<cfif ListLen(variables.wheels.class.simpleSorting.scope)>
			<cfloop list="#variables.wheels.class.simpleSorting.scope#" index="loc.scope">
				<cfif Len(loc.where) gt 0>
					<cfset loc.where = loc.where & " AND ">
				</cfif>
				<cfif StructKeyExists(this, loc.scope) and Len(this[loc.scope])>
					<cfset loc.where = loc.where & "#loc.scope#='#this[loc.scope]#'">
				<cfelse>
					<cfset loc.where = loc.where & "#loc.scope# IS NULL">
				</cfif>
			</cfloop>
		</cfif>
		<cfset loc.result = Val(this.maximum(property=variables.wheels.class.simpleSorting.sortColumn, where=loc.where, reload=true))>
		<cfreturn loc.result>
	</cffunction>
	

	<cffunction name="$simpleSortingCheckSortOrderBeforeUpdate" returntype="boolean" mixin="model" output="false">
		<cfset var nextAvailableSortOrder = 0>
		<cfset variables.previousSortOrder = variables.$persistedProperties[variables.wheels.class.simpleSorting.sortColumn]>
		<cfif StructKeyExists(this,variables.wheels.class.simpleSorting.sortColumn) and hasChanged(variables.wheels.class.simpleSorting.sortColumn)>
			<cfset nextAvailableSortOrder = $simpleSortingGetMaxSortOrder() + 1>
			<cfif this[variables.wheels.class.simpleSorting.sortColumn] eq 0 or this[variables.wheels.class.simpleSorting.sortColumn] gt nextAvailableSortOrder>
				<cfset this[variables.wheels.class.simpleSorting.sortColumn] = nextAvailableSortOrder>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="$simpleSortingUpdateTableAfterSave" returntype="void" mixin="model" output="false">
		<cfset var loc = {}>
		<cfif variables.previousSortOrder neq this[variables.wheels.class.simpleSorting.sortColumn]>
			<cfquery name="loc.simpleSortingUpdateTableAfterSave" attributecollection="#this.$simpleSortingGetConnection()#">
			UPDATE	#tableName()#
			<cfif variables.previousSortOrder gt this[variables.wheels.class.simpleSorting.sortColumn]>
			SET		#variables.wheels.class.simpleSorting.sortColumn# = #variables.wheels.class.simpleSorting.sortColumn# + 1
			WHERE	#variables.wheels.class.simpleSorting.sortColumn# >= <cfqueryparam cfsqltype="#variables.wheels.class.properties[variables.wheels.class.simpleSorting.sortColumn].type#" value="#this[variables.wheels.class.simpleSorting.sortColumn]#"> 
			AND		#variables.wheels.class.simpleSorting.sortColumn# < <cfqueryparam cfsqltype="#variables.wheels.class.properties[variables.wheels.class.simpleSorting.sortColumn].type#" value="#variables.previousSortOrder#"> 
			<cfelse>
			SET		#variables.wheels.class.simpleSorting.sortColumn# = #variables.wheels.class.simpleSorting.sortColumn# - 1
			WHERE	#variables.wheels.class.simpleSorting.sortColumn# <= <cfqueryparam cfsqltype="#variables.wheels.class.properties[variables.wheels.class.simpleSorting.sortColumn].type#" value="#this[variables.wheels.class.simpleSorting.sortColumn]#"> 
			AND		#variables.wheels.class.simpleSorting.sortColumn# > <cfqueryparam cfsqltype="#variables.wheels.class.properties[variables.wheels.class.simpleSorting.sortColumn].type#" value="#variables.previousSortOrder#"> 
			</cfif>
			AND		#primaryKey()# <> <cfqueryparam cfsqltype="#variables.wheels.class.properties[primaryKey()].type#" value="#this[primaryKey()]#">
			<cfloop list="#variables.wheels.class.simpleSorting.scope#" index="loc.scope">
			<cfif StructKeyExists(this, loc.scope) and Len(this[loc.scope])>
			AND 	#loc.scope# = <cfqueryparam cfsqltype="#variables.wheels.class.properties[loc.scope].type#" value="#this[loc.scope]#"> 
			<cfelse>
			AND 	#loc.scope# IS NULL
			</cfif>
			</cfloop>
			</cfquery>
		</cfif>
	</cffunction>
	
	
	<cffunction name="$simpleSortingUpdateTableAfterDelete" returntype="void" mixin="model" output="false">
		<cfset var loc = {}>
		<cfquery name="loc.simpleSortingUpdateTableAfterDelete" attributecollection="#this.$simpleSortingGetConnection()#">
		UPDATE	#tableName()#
		SET		#variables.wheels.class.simpleSorting.sortColumn# = #variables.wheels.class.simpleSorting.sortColumn# - 1
		WHERE	#variables.wheels.class.simpleSorting.sortColumn# > <cfqueryparam cfsqltype="#variables.wheels.class.properties[variables.wheels.class.simpleSorting.sortColumn].type#" value="#this[variables.wheels.class.simpleSorting.sortColumn]#"> 
		<cfloop list="#variables.wheels.class.simpleSorting.scope#" index="loc.scope">
		<cfif StructKeyExists(this, loc.scope) and Len(this[loc.scope])>
		AND 	#loc.scope# = <cfqueryparam cfsqltype="#variables.wheels.class.properties[loc.scope].type#" value="#this[loc.scope]#"> 
		<cfelse>
		AND 	#loc.scope# IS NULL
		</cfif>
		</cfloop>
		</cfquery>
	</cffunction>
	
	
	<cffunction name="$simpleSortingGetConnection" returntype="struct" mixin="model" output="false">
		<cfset var connection = Duplicate(variables.wheels.class.connection)>
		<cfif not Len(connection.username)>
			<cfset StructDelete(connection, "username")>
		</cfif>
		<cfif not Len(connection.password)>
			<cfset StructDelete(connection, "password")>
		</cfif>
		<cfreturn connection>
	</cffunction>


</cfcomponent>

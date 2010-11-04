<h1>Simple Sorting 1.1</h1>
<h3>A plugin for <a href="http://cfwheels.org" target="_blank">Coldfusion on Wheels</a> by <a href="http://cfwheels.org/user/profile/24" target="_blank">Andy Bellenie</a></h3>
<p>This plugin provides methods for sorting any model by an integer field. </p>
<h2>Usage</h2>
<p>Add simpleSorting([sortColumn,scope]) to the init of your model to enable the plugin. </p>
<ul><li>sortColumm (string, default 'sortOrder') - the column used for sorting (integer)</li>
	<li>scope (string, default '') - Limits all functions to the scope of the provided column(s) (see 'Scoping' below)</li>
</ul>

<pre>
&lt;cffunction name=&quot;init&quot;&gt;
	&lt;cfset simpleSorting(sortColumn=&quot;mySortColumn&quot;,scope=&quot;myScopeField1,myScopeField2&quot;)&gt;
&lt;/cffunction&gt;
</pre>
<h3>Inserting a new model</h3>
<p>If there is no sort position specified (or a sort position of zero) then the model will be added at the bottom of the sort table during inserts. If you wish to insert at a specific location, set the sort position into the model before calling create() or save(), e.g.</p>
<pre>
&lt;cfset myModel = model(&quot;foo&quot;).create(title=&quot;bar&quot;)&gt;               &lt;!--- inserts at the bottom ---&gt;
&lt;cfset myModel = model(&quot;foo&quot;).create(title=&quot;bar&quot;, sortOrder=0)&gt;  &lt;!--- inserts at the bottom ---&gt;
&lt;cfset myModel = model(&quot;foo&quot;).create(title=&quot;bar&quot;, sortOrder=1)&gt;  &lt;!--- inserts at the top ---&gt;
&lt;cfset myModel = model(&quot;foo&quot;).create(title=&quot;bar&quot;, sortOrder=3)&gt;  &lt;!--- inserts at position three ---&gt;
</pre>
<h3>Moving a model</h3>
<p>To move a model simply set a new sorting position and  call  update() or save(). If you specify a value of zero, it will move the model to the bottom of the table, e.g.</p>
<pre>
&lt;cfset myModel.update()&gt;             &lt;!--- no move ---&gt;
&lt;cfset myModel.update(sortOrder=0)&gt;  &lt;!--- moves to the bottom ---&gt;
&lt;cfset myModel.update(sortOrder=3)&gt;  &lt;!--- moves to position 3 ---&gt;
&lt;cfset myModel.update(sortOrder=1)&gt;  &lt;!--- moves to the top ---&gt;
</pre>
<h3>Scoping</h3>
<p>By adding one or more columns to the scope argument, you can have multiple 
	independant sorts within a single table, e.g. - a comments table:</p>
<table width="*">
<tr>
	<th>id</th>
	<th>postId</th>
	<th>sortOrder</th>
	<th>text</th>
</tr>
<tr>
	<td>1</td>
	<td>1</td>
	<td>1</td>
	<td>This is the FIRST comment for the FIRST post</td>
</tr>
<tr>
	<td>1</td>
	<td>1</td>
	<td>2</td>
	<td>This is the SECOND comment for the FIRST post</td>
</tr>
<tr>
	<td>1</td>
	<td>1</td>
	<td>3</td>
	<td>This is the THIRD comment for the FIRST post</td>
</tr>
<tr>
	<td>1</td>
	<td>2</td>
	<td>1</td>
	<td>This is the FIRST comment for the SECOND post</td>
</tr>
<tr>
	<td>1</td>
	<td>2</td>
	<td>2</td>
	<td>This is the SECOND comment for the SECOND post</td>
</tr>
<tr>
	<td>1</td>
	<td>2</td>
	<td>3</td>
	<td>This is the THIRD comment for the SECOND post</td>
</tr>
</table>

<p>For this example, you would add the scope argument to the initial plugin call, i.e.</p>
<pre>
&lt;cfset simpleSorting(scope=&quot;postId&quot;&gt;
</pre>
<p>This effectively adds a &quot;where postId = #this.postId#&quot; to all sorting functions.</p>
<h2>Support</h2>
<p>I try to keep my plugins free from bugs and up to date with Wheels releases, but if you encounter a problem please log an issue using the tracker on github, where you can also browse my other plugins.<br />
<a href="https://github.com/andybellenie" target="_blank">https://github.com/andybellenie</a></p>

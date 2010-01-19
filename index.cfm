<h1>Simple Sorting  0.1 ALPHA </h1>
<h3>By Andy Bellenie</h3>
<p>This plugin provides methods for sorting any model by an integer field. </p>
<h2>Usage</h2>
<p>Add  simpleSorting([sortColumn,scope]) to the init of your model to enable the plugin. </p>
<ul><li>sortColumm (string, default 'sortOrder') - the column used for sorting (integer)</li>
	<li>scope (string, default '') - Limits all functions to the scope of the provided column(s)</li>
</ul>

<h3>Inserting a new model</h3>
<p>If there is no sort position specified then models will be added at the bottom of the sort table during inserts. If you wish to insert at a specific location, set the sort position into the model before calling create(). So create() will insert at the bottom, and create([sortColumn]=1) will insert at the top.</p>
<h3>Moving a model</h3>
<p>To move a model, simply set a new sorting position and run call an update(), e.g mymodel.update([sortColumn]=2)</p>
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

<h2>Support</h2>
<p>If you  encounter any problems when using this plugin, please submit an issue on github:<br />
<a href="http://github.com/andybellenie/CFWheels-Clone-Model/issues" target="_blank">http://github.com/andybellenie/CFWheels-Simple-Sorting/issues</a></p>

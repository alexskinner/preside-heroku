component extends="preside.system.Bootstrap" {

	function parsepgDS(DSSTRING){
	  var ds={};
	  ds.connectionString = ReReplaceNoCase( arguments.DSSTRING, "^postgres://", "postgresql://" );
	  ds.username          = ReReplaceNoCase( ds.connectionString, "^postgresql://(.*?):(.*?)@.*$", "\1"  );
	  ds.password          = ReReplaceNoCase( ds.connectionString, "^postgresql://(.*?):(.*?)@.*$", "\2"  );
	  ds.connectionString  = ReReplaceNoCase( ds.connectionString, "^postgresql://(.*?)@", "postgresql://" );
	  ds.class='org.postgresql.Driver'

	  if (ds.connectionString contains "amazonaws.com"){
	  	ds.SSL='?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory';
	  }else{
		ds.SSL='';
	  }
	  return ds;
	}

	dsConnection = parsePGDS(server.system.environment.database_url);

	this.datasources["preside"] = {
	  class: dsConnection.class
	, connectionString: 'jdbc:#dsConnection.connectionString##dsConnection.SSL#'
	, username: dsConnection.username
	, password: dsConnection.password
	};

	setupApplication( id = "heroku");

}
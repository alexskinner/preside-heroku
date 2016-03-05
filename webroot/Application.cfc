component extends="preside.system.Bootstrap" {

	if (not isDefined("server.system.environment.database_url") or isEmpty(server.system.environment.database_url)){
		echo ("The database_url environment variable is required, only Postgres is supported unless this build pack is modified");
		abort;
	}
	if (not isDefined("server.system.environment.S3_BUCKET") or isEmpty(server.system.environment.S3_BUCKET)){
		echo ("The S3_BUCKET environment variable is required for website uploads");
		abort;
	}

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
	, connectionLimit:20
	};

	setupApplication( id = "heroku", appMapping = "/localapp");
}
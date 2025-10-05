public class BoxAuthController {
    public String body{get; set;}
    public SuperItemList[] dataList {get; set;}

    public PageReference authenticate(){
        return new PageReference('https://account.box.com/api/oauth2/authorize/?client_id=wec8ofwsz3rmzeqleqjyof4fqrvwl15z&response_type=code');
    }

    public void getAccessToken() {
        String authCode = ApexPages.currentPage().getParameters().get('code');
        //step 1 instantiate http class
        Http http = new Http();
        HttpRequest req =  new HttpRequest();
        req.setEndPoint('https://api.box.com/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Accept','Application/json');
        req.setBody('grant_type=authorization_code&code='+ authCode+'&client_id=wec8ofwsz3rmzeqleqjyof4fqrvwl15z&client_secret=wbm9DFeY4MZuNdbeGt43XScBf60kaSLH');
        HttpResponse res = http.send(req);
        fromJSON jres = (fromJSON)JSON.deserialize(res.getBody(),fromJSON.class);
        body = getFolders(jres.access_token);
        dataList = new SuperItemList[]{};

        FolderContent folder = (FolderContent)JSON.deserialize(body, FolderContent.class);
        for(cls_entries ce : folder.entries){
            dataList.add(new SuperItemList(ce.id, ce.type, ce.name));
        }
        System.debug(dataList.size());
        System.debug(dataList);
    }

    public String getFolders(String accessToken) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint('https://api.box.com/2.0/folders/288904345492/items');
        req.setMethod('GET');
        req.setHeader('Accept','Application/json');
        req.setHeader('Authorization','Bearer '+accessToken);
        HttpResponse res = http.send(req);
        return res.getBody();
    }

    public class fromJSON{
        public String access_token;	//1U418hA9Z7aKNd5xr77eCXYE7IprVut2
        public Integer expires_in;	//4180
        public cls_restricted_to[] restricted_to;
        public String refresh_token;	//HQjIlOdBeWaEXaAmjEwSCudBFPpGfgQON6n2OCMp5xQFCuVJ7KHhqRtskzJCeFNp
        public String token_type;	//bearer
    }
    public class cls_restricted_to{}

    public class FolderContent{
        public Integer total_count;	//2
        public cls_entries[] entries;
        public Integer offset;	//0
        public Integer limit_x;	//100
        public cls_order[] order;
    }
    class cls_entries {
        public String type;	//file
        public String id;	//1671425707091
        public cls_file_version file_version;
        public String sequence_id;	//0
        public String etag;	//0
        public String sha1;	//bae71fdc7e1af8170e42a6129f10de8b236cc62a
        public String name;	//Fichas comunicacion .pdf
    }
    class cls_file_version {
        public String type;	//file_version
        public String id;	//1839003071891
        public String sha1;	//bae71fdc7e1af8170e42a6129f10de8b236cc62a
    }
    class cls_order {
        public String by_x;	//type
        public String direction;	//ASC
    }

    public class SuperItemList{
        public String id_x {get;set;}
        public String type_x{get;set;}
        public String name_x{get;set;}

        public SuperItemList(String id_x, String type_x, String name_x){
            this.id_x = id_x;
            this.type_x = type_x;
            this.name_x = name_x;
        }
    }

    public class parseFolderContent{
        public Integer total_count;	//2
        public cls_entries[] entries;
        public Integer offset;	//0
        public Integer limit;	//100
        public cls_order[] order;
    }
	class cls_entries {
		public String type;	//file
		public String id;	//1671425707091
		public cls_file_version file_version;
		public String sequence_id;	//0
		public String etag;	//0
		public String sha1;	//bae71fdc7e1af8170e42a6129f10de8b236cc62a
		public String name;	//Fichas comunicacion .pdf
	}
	class cls_file_version {
		public String type;	//file_version
		public String id;	//1839003071891
		public String sha1;	//bae71fdc7e1af8170e42a6129f10de8b236cc62a
	}
	class cls_order {
		public String by;	//type
		public String direction;	//ASC
	}
	public static parseFolderContent parse(String json){
		return (parseFolderContent) System.JSON.deserialize(json, parseFolderContent.class);
	}
     
}
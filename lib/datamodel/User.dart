class AppUser {
   String username;
   String uid;
   double avg_speed;
   double max_speed;
   int top_rating;
   double total_runtime;
   double total_tracklength;
   int coursecount;


   AppUser(){}
   AppUser.fromJson(Map <String,dynamic> json){
     this.username = json['username'];
     this.uid = json['uid'];
     this.avg_speed = json['avg_speed'] as double;
     this.max_speed = json['max_speed'] as double;
     this.top_rating = json['top_rating'] as int;
     this.total_runtime = json['total_runtime'] as double;
     this.total_tracklength = json['total_tracklength'] as double;
     this.coursecount = json['coursecount'] as int;
    }
    Map<String,dynamic> toJson(){
     return {'username':username,'uid':uid,'avg_speed':avg_speed,'max_speed':max_speed,
       'top_rating':top_rating,'total_runtime':total_runtime,'total_tracklength':total_tracklength,
       'coursecount':coursecount};
    }

   String formattedRuntime(){
     double totsecs = total_runtime/1000;
     String ret ="";
     if (totsecs>3600) {
       int hours = totsecs/3600 as int;
       ret+= hours.toString()+":";
       totsecs-=hours*3600;
       int mins = totsecs/60 as int;
       if (mins<10){ret+="0";}
       ret+=mins.toString()+":";
       totsecs-=60*mins;
       int seconds = totsecs as int;
       if (seconds>10){ret+="0";}
       ret+=seconds.toString()+" h";
     } else {
       int mins = totsecs/60 as int;
       ret+=mins.toString() +":";
       totsecs-=60*mins;
       int seconds = totsecs as int;
       if (seconds>10){ret+="0";}
       ret+=seconds.toString()+" min";
     }
     return ret;}

   String formattedTrackLength() =>total_tracklength.toStringAsFixed(3)+" km";
   String formattedMaxSpeed() =>max_speed.toStringAsFixed(3)+ " km/h";
   String formattedAvgSpeed()=>avg_speed.toStringAsFixed(3)+ " km/h";
}
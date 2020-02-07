 BEGIN {

  RS = "+";
  FS = "\n";

  }

 {
  
  if(NF == 5){
  
    if(length($4) > 30) {
 
      print $4"\tSeq Length="length($4)"\n";

    }

  }

  else if(NF == 3){

   if(length($2) > 30){

    print $2"\tSeq Length="length($2)"\n";

    }

   }
   
 }

END {

  print "------------------";

}

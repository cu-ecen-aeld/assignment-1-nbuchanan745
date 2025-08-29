#include "syslog.h"
#include "stdio.h"
#include "stdlib.h"



int main (int argc, char** argv){

if(argc != 3){
syslog(LOG_ERR, "Wrong usage");
return 1;
}



char* filepath = argv[1];
char* text = argv[2];
int textlength = 0;
while(text[textlength] != '\0'){
textlength++;
}

FILE* fil = fopen(filepath, "w");





if(fil == NULL){
syslog(LOG_ERR, "Bad User or Bad System");
fclose(fil);
return 1;
}

syslog(LOG_DEBUG, "Writing %s to %s", text, filepath);


int writelen = fwrite(text, 1, textlength, fil);
if(writelen!= textlength){
syslog(LOG_ERR, "Bad User or Bad System");
fclose(fil);
return 1;
}

fclose(fil);
return 0;
}

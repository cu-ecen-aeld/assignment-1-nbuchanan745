#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <syslog.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <signal.h>

#define PORT 9000
#define WFI "/var/tmp/aesdsocketdata"

int sfd;
int cfd;
int dfid;


volatile sig_atomic_t cs = 0;



void closeall(){
syslog(LOG_INFO, "Caught signal, exiting");

unlink(WFI);
close(sfd);
close(cfd);
close(dfid);
exit(0);
}


static void signal_handler(int signum){
if(signum == SIGINT || signum == SIGTERM){
cs = 1;
closeall();
}
}

int dflag = 0;
int main(int argc, char * argv[]){

if(argc >1){
if(argv[1][0] == '-' && argv[1][1] == 'd'){
dflag = 1;
}
}



struct sigaction sa;
sa.sa_handler = &signal_handler;
sigemptyset(&sa.sa_mask);
sa.sa_flags = 0;
sigaction(SIGINT, &sa, NULL);
sigaction(SIGTERM, &sa,NULL);



struct sockaddr_in server_addr, client_addr;


memset(&server_addr, 0, sizeof(server_addr));
server_addr.sin_family = AF_INET;
server_addr.sin_addr.s_addr = INADDR_ANY;
server_addr.sin_port = htons(PORT);




socklen_t calen = sizeof(client_addr);
char buff[1024];
int op = 1;

memset(buff,0,sizeof(buff));

openlog("aesdsocket", LOG_PID | LOG_CONS, LOG_USER);

sfd = socket(AF_INET, SOCK_STREAM,0);
if(sfd < 0){
syslog(LOG_ERR, "Failed socket creation");
closelog();
return -1;
}

if(setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &op, sizeof(op)) < 0){
syslog(LOG_ERR, "Failed socket creation step 2");
close(sfd);
closelog();
return -1;
}
if(bind(sfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0){
syslog(LOG_ERR, "Failed socket bind on port 9000");
close(sfd);
closelog();
return -1;
}

if(dflag == 1){
//run as daemon
daemon(0,0);



}


if(listen(sfd,2) < 0){
syslog(LOG_ERR, "Failed socket listen");
close(sfd);
closelog();
return -1;
}

syslog(LOG_INFO, "SOCKET STARTED ");



while(1){
if(cs == 1){
closeall();
}

cfd = accept(sfd, (struct sockaddr *)&cfd, &calen);
if(cfd < 0){
syslog(LOG_ERR, "Failed socket accept");
close(sfd);
closelog();
return -1;

}



char cip[INET_ADDRSTRLEN];
inet_ntop(AF_INET, &client_addr.sin_addr, cip, INET_ADDRSTRLEN);
syslog(LOG_INFO, "connected to %s " , cip);

 dfid = open(WFI, O_RDWR | O_CREAT | O_APPEND, 0666);
if(dfid < 0){
syslog(LOG_ERR, "Failed file open");
close(sfd);
close(dfid);
closelog();
return -1;
}

char nullterm[1] = {0};
ssize_t reced = 0;
while((reced = recv(cfd,buff, 1024,0)) > 0){
if(cs == 1){
closeall();
}

//printf("Recieved %s \n", buff);

int ret = write(dfid, buff, reced);
//printf("Ret  %d  \n",ret);

if(memchr(buff, '\n', reced) != NULL){
break;
}
memset(buff,0,sizeof(buff));

}



/////handle packet 
char sbuf[1024];

int rt;
lseek(dfid, 0, SEEK_SET);
rt = read(dfid,sbuf,1024);
printf("Num sought  %d  \n",rt);

 lseek(dfid, 0, SEEK_SET);

ssize_t red = 0;
//printf("About to Send \n");

while((red = read(dfid,sbuf,1024)) > 0){
//printf("Staging send of %s  \n",sbuf);
if(cs == 1){
closeall();
}
size_t sc = 0;
while(sc < red){
sc += send(cfd, sbuf+ sc, red-sc,0);
//printf("Sending %s \n", sbuf);

if(cs == 1){
closeall();
}

}

}




close(dfid);

close(cfd);
syslog(LOG_INFO,"Closed connection from %s", cip);
}//end of infinite server looop



close(sfd);
return 0;
}


 

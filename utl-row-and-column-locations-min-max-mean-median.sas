Row-and-column-locations-min-max-mean-median                                                       
                                                                                                   
The elegance of a matrix language                                                                  
                                                                                                   
inspired by                                                                                        
https://communities.sas.com/t5/New-SAS-User/Find-a-Value-in-Dataset/m-p/606423                     
                                                                                                   
*_                   _                                                                             
(_)_ __  _ __  _   _| |_                                                                           
| | '_ \| '_ \| | | | __|                                                                          
| | | | | |_) | |_| | |_                                                                           
|_|_| |_| .__/ \__,_|\__|                                                                          
        |_|                                                                                        
;                                                                                                  
                                                                                                   
options validvarname=upcase;                                                                       
libname sd1 "d:/sd1";                                                                              
data sd1.have;                                                                                     
 input v1-v10;                                                                                     
cards4;                                                                                            
349 990 805 391 193 39 870 890 467 349                                                             
951 273 781 17 965 265 761 528 244 990                                                             
173 561 335 999 25 275 651 511 349 805                                                             
80 588 797 133 768 162 105 444 197 391                                                             
819 724 191 831 444 337 93 948 864 193                                                             
897 675 715 983 863 910 652 914 754 39                                                             
56 384 306 364 512 714 747 312 939 870                                                             
606 272 907 602 44 116 793 155 53 890                                                              
118 172 680 649 676 769 487 435 333 467                                                            
734 328 981 338 549 642 149 64 575 555                                                             
;;;;                                                                                               
run;quit;                                                                                          
                                                                                                   
                                                                                                   
10x10 dataset                                                                                      
                                                                                                   
Since e have an even number of values 10x10=100                                                    
The median is the average of two values                                                            
                                                                                                   
SD1.HAVE total obs=10                                                                              
                                                                                                   
Obs   V1     V2     V3     V4     V5     V6     V7     V8     V9    V10                            
                                                                                                   
  1  349    990    805    391    193     39    870    890    467    349                            
                                                                                                   
                         (2,4)                     One of two                                      
                          MIN                        MEDIAN                                        
  2  951    273    781     17    965    265    761    528    244    990                            
                                                                                                   
                                                                                                   
                         (2,4)                                                                     
                          MAX                                                                      
  3  173    561    335    999     25    275    651    511    349    805                            
                                                                                                   
  4   80    588    797    133    768    162    105    444    197    391                            
  5  819    724    191    831    444    337     93    948    864    193                            
  6  897    675    715    983    863    910    652    914    754     39                            
                                                                                                   
                             MEDIAN(closest)                                                       
                               528+520/2                                                           
                                 520                                                               
                             Mean(closest)                                                         
                                 517                                                               
                                                                                                   
  7   56    384    306    364    512    714    747    312    939    870                            
  8  606    272    907    602     44    116    793    155     53    890                            
  9  118    172    680    649    676    769    487    435    333    467                            
 10  734    328    981    338    549    642    149     64    575    555                            
                                                                                                   
                                                                                                   
*            _               _                                                                     
  ___  _   _| |_ _ __  _   _| |_                                                                   
 / _ \| | | | __| '_ \| | | | __|                                                                  
| (_) | |_| | |_| |_) | |_| | |_                                                                   
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                  
                |_|                                                                                
;                                                                                                  
                                                                                                   
                                                                                                   
Up to 40 obs WORK.WANT total obs=5                                                                 
                                                                                                   
Obs    STATISTI    VALUE     ROW    COLUMN                                                         
                                                                                                   
 1      MIN        17         2       4                                                            
 2      MAX        999        3       4                                                            
 3      MEDIAN     520        7       5                                                            
 4      MEDIAN     520        2       8                                                            
 5      MEAN       516.56     7       5                                                            
                                                                                                   
*                                                                                                  
 _ __  _ __ ___   ___ ___  ___ ___                                                                 
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                                
| |_) | | | (_) | (_|  __/\__ \__ \                                                                
| .__/|_|  \___/ \___\___||___/___/                                                                
|_|                                                                                                
;                                                                                                  
                                                                                                   
%utl_submit_r64('                                                                                  
library(haven);                                                                                    
library(SASxport);                                                                                 
have<-as.matrix(read_sas("d:/sd1/have.sas7bdat"));                                                 
max<-max(have);                                                                                    
min<-min(have);                                                                                    
med<-median(have);                                                                                 
avg<-mean(have);                                                                                   
locmax = which(have == max(have),arr.ind=TRUE);                                                    
locmin = which(have == min(have),arr.ind=TRUE);                                                    
locmed = which(abs(have - med)==min(abs(have - med)),arr.ind=TRUE);                                
locavg = which(abs(have - avg)==min(abs(have - avg)),arr.ind=TRUE);                                
minrow=cbind("MIN",min,locmin);                                                                    
maxrow=cbind("MAX",max,locmax);                                                                    
avgrow=cbind("MEAN",avg,locavg);                                                                   
medrow=cbind("MEDIAN",med,locmed);                                                                 
want<-as.data.frame(rbind(minrow,maxrow,medrow,avgrow));                                           
want[] <- lapply(want, function(x) if(is.factor(x)) as.character(x) else x);                       
colnames(want)<-c("STATISTIC","VALUE","ROW","COLUMN");                                             
want;                                                                                              
write.xport(want,file="d:/xpt/wantx.xpt");                                                         
');                                                                                                
                                                                                                   
libname xpt xport "d:/xpt/wantx.xpt";                                                              
data want;                                                                                         
  set xpt.want;                                                                                    
run;quit;                                                                                          
libname xpt clear;                                                                                 
                                                                                                   
                                                                                                   

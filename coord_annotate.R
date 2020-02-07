#loading in packages to perform annotation
library(ape)
library(dplyr)
library(stringr)

##reading in annotation and chromosome data from the working directory

Annotation_Data <- ape::read.gff("~/gtf/hg19_annotations.gtf") #loading in annotation data in R
coord_chromosome_Data <- read.delim("~/annotate/coordinates_to_annotate.txt",sep = "\t",header = FALSE,stringsAsFactors = FALSE) #creating data frames on coordinates and chromosome data
names(coord_chromosome_Data) <- c("seqid","coordinates") #assigning names for annotation data

#analyzing the annotation and chromosome annotation data

names(Annotation_Data)
head(Annotation_Data)
head(coord_chromosome_Data)
names(coord_chromosome_Data)

###########################################################################################
#### retrieve annotate details of the chromosome and coordinates from annotation data #####
# The function retrieves annotation details from the annotations data for a given chromosome
# and coordinate details.Furtheralongwith parsing annotation details,attributes like gene
# details and exon details are extracted and tidied ###
###########################################################################################

Retrieve_Annotation_Data <- function(Annotation_D,Coord_Chromosome_D){

  Annotated_Chr_Data <- Annotation_D %>% filter(start %in% Coord_Chromosome_D$coordinates & seqid %in% Coord_Chromosome_D$seqid | end %in% Coord_Chromosome_D$seqid ) %>% distinct() #filtering out the chromosomes
  # from the annotation data with similiar chromosome details AND coordinate details present either in start or end.
  Annotated_df <- Annotated_Chr_Data %>% mutate(Gene_Data = str_extract(attributes,"gene_id\\s\\\"[A-Z]+[0-9]+"),
                                            Gene_Name = gsub("gene_id\\s\\\"","",Gene_Data),
                                            transcript_Data = str_extract(attributes,"transcript_id\\s\\\"[A-Z]+_[0-9]+"),
                                            transcript_det = gsub("transcript_id\\s\\\"","",transcript_Data),
                                            exon_number_data = str_extract(attributes,"exon_number\\s\\\"[0-9]+"),
                                            exon_number_det = gsub("exon_number\\s\\\"","",exon_number_data)) %>% select(seqid,source,type,start,end,strand,Gene_Name,transcript_det,exon_number_det)
  #using string extract to extract the relevant details for the chromosome and coordinates
  return(Annotated_df)

}

Annotated_Df <- Retrieve_Annotation_Data(Annotation_D = Annotation_Data, Coord_Chromosome_D = coord_chromosome_Data) #loading into annotation and chromosome data into the function

#checking and confirming if the retrieved annotation data is present in the data consisting of chromosomes and its coordinates
coord_chromosome_Data %>% filter(seqid == Annotated_Df$seqid[1] & coordinates == Annotated_Df$start[1] | coordinates == Annotated_Df$end[1] )
#checking for any missing values of seqid and eliminating them
Annotated_Df %>% filter(is.na(seqid) | is.na(start) | is.na(end))
#there are no missing values in the seqid, start and end data of the chromosome and its coordinates
summary(Annotated_Df)

## This summarises the annotated data and there are no missing values in seqid,
#start,end,source,type,strand and attributes confirming that annotation data was 
#properly parsed with informations.Further,Attributes can be tidied to parse more detailed 
#information about the chromosome and coordinates.


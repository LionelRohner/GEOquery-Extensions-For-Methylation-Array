# GEOquery-Extensions-For-Methylation-Array
Some function that makes it to donwload methylation data from GEO

The functions so far:

1. getGEOSampleSheet <- function(GSE_Nr, concise = T, onlyMeth = T)
              1.1. Downloads a GEO object containing all the study information
              1.2. Selects columns of interest (e.g. title, geo_accession, platform_id, sample type, organism,..) [conise = T]
              1.3. Select only sample sheets linked to methylation array [only Meth = T]
              1.4. Removes all downloaded files (?)
              
2. filterGEO_samplesheet <- function(sampleSheet, filter = "liver")
              2.1. Searches for keywords in the sample sheet.
              2.2. Only liver keywords are implemented [filter = "liver"]
              
3. downloadGSM_Samples <- function(sampleSheet, GSE_Nr, unzip)
               3.1. Downloads all samples from a (filtered) sample sheet.
               3.2. Creates subfolder : ./DownloadSamples/{GSE_Nr.}/{GSM_Nr.}
               3.3. Unzips all the files and removes compressed data


### It has not been throughly tested!

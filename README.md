# GEOquery-Extensions-For-Methylation-Array
Some function that makes it to donwload methylation data from GEO

Add some Info:




1. getGEOSampleSheet <- function(GSE_Nr, concise = T, onlyMeth = T)
              1. Downloads a GEO object containing all the study information
              2. Selects columns of interest (e.g. title, geo_accession, platform_id, sample type, organism,..) [conise = T]
              3. Select only sample sheets linked to methylation array [only Meth = T]
              4. Removes all downloaded files (?)
              
Markup :  2. filterGEO_samplesheet <- function(sampleSheet, filter = "liver")
              1. Searches for keywords in the sample sheet.
              2. Only liver keywords are implemented [filter = "liver"]
              
Markup :  3. downloadGSM_Samples <- function(sampleSheet, GSE_Nr, unzip)
               1. Downloads all samples from a (filtered) sample sheet.
               2. Creates subfolder : ./DownloadSamples/{GSE_Nr.}/{GSM_Nr.}
               3. Unzips all the files and removes compressed data


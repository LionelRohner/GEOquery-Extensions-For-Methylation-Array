# GEOquery-Extensions-For-Methylation-Array
Some function that makes it to donwload methylation data from GEO

The functions so far:

1. getGEOSampleSheet <- function(GSE_Nr, concise = T, onlyMeth = T)
  i. Downloads a GEO object containing all the study information
  ii. Selects columns of interest (e.g. title, geo_accession, platform_id, sample type, organism,..) [conise = T]
  iii. Select only sample sheets linked to methylation array [only Meth = T]
  iv. Removes all downloaded files (?)
              
2. filterGEO_samplesheet <- function(sampleSheet, filter = "liver")
  i. Searches for keywords in the sample sheet.
  ii. Only liver keywords are implemented [filter = "liver"]
              
3. downloadGSM_Samples <- function(sampleSheet, GSE_Nr, unzip)
  i. Downloads all samples from a (filtered) sample sheet.
  ii. Creates subfolder : ./DownloadSamples/{GSE_Nr.}/{GSM_Nr.}
  iii. Unzips all the files and removes compressed data


### It has not been throughly tested!

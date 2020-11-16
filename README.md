# GEOquery-Extensions-For-Methylation-Array
Some function that makes it to donwload methylation data from GEO

The functions so far:

* getGEOSampleSheet <- function(GSE_Nr, concise = T, onlyMeth = T) \n
  * Downloads a GEO object containing all the study information
  * Selects columns of interest (e.g. title, geo_accession, platform_id, sample type, organism,..) [conise = T]
  * Select only sample sheets linked to methylation array [only Meth = T]
  * Removes all downloaded files (?)
              
* filterGEO_samplesheet <- function(sampleSheet, filter = "liver")
  * Searches for keywords in the sample sheet.
  * Only liver keywords are implemented [filter = "liver"]
              
* downloadGSM_Samples <- function(sampleSheet, GSE_Nr, unzip)
  * Downloads all samples from a (filtered) sample sheet.
  * Creates subfolder : ./DownloadSamples/{GSE_Nr.}/{GSM_Nr.}
  * Unzips all the files and removes compressed data


### It has not been throughly tested!

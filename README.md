# GEOquery-Extensions-For-Methylation-Array
Some function that makes it to donwload methylation data from GEO

Add some Info:

getGEOSampleSheet <- function(GSE_Nr, concise = T, onlyMeth = T)
Downloads a GEO object containing all the study information
Selects columns of interest (e.g. title, geo_accession, platform_id, sample type, organism,..) [conise = T]
Select only sample sheets linked to methylation array [only Meth = T]
Removes all downloaded files (?)

```math
SE = \frac{\sigma}{\sqrt{n}}
```

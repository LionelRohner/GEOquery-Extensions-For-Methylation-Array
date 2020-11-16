# Get selection of sample sheet columns from GEO object -------------------

# helper function <- grep search for column names
getColsGEO <- function(gse){
  return(grep("^title$|^geo_accession$|^platform_id$|^type$|^organism_ch1$|^characteristics_ch1$|^characteristics_ch1.1$|^characteristics_ch1.2$|^characteristics_ch1.3$|^source_name_ch1$|^supplementary_file$",colnames(pData(gse))))
}


# get sample sheet from a GEO object --------------------------------------

# Puts together a sample sheet from a GEO object. Each subfile of the GEO, which
# are usually split according to platforms, is accessed and merged to one file.
# Arguments: 
# concise: uses getColsGEO to trim down the columns for better overview
# onlyMeth: only 450K and EPIC arrays are considered in the sample sheet

# requires : GEOquery and plyr

getGEOSampleSheet <- function(GSE_Nr, concise = T, onlyMeth = T){
  
  # puts together a samplesheet of methylation array samples 
  
  gse <- getGEO(GSE_Nr, GSEMatrix = TRUE,destdir = "./GSE_temp")
  
  # put together the sample sheets
  sample_sheet <- c()
  
  subfiles <- length(gse)
  
  cat("subfiles ", subfiles, "\n")
  
  if (subfiles == 1){
    if (concise == T){
      
      sheet <- pData(gse[[1]])[,getColsGEO(gse[[1]])]
      sample_sheet <- sheet
      
    } else {
      
      sheet <- pData(gse[[1]])[,]
      sample_sheet <- sheet
    }
    
  } else if (subfiles > 1) {
    
    if (concise == T){
      for (i in 1:subfiles){
        
        sheet <- pData(gse[[i]])[,getColsGEO(gse[[i]])]
        sample_sheet <- rbind.fill(sample_sheet,sheet)
      }
    } else {
      for (i in 1:subfiles){
        
        sheet <- pData(gse[[i]])[,]
        sample_sheet <- rbind.fill(sample_sheet,sheet)
      }
    }
  }
  
  cat("\n")
  
  if (onlyMeth == T){
    
    cat("Searching for methylation data... \n")
    # check platforms
    # 450K array = GPL13534;
    # EPIC = GPL21145;
    # Human methylation850 Beadchip = GPL23976
    
    Array_450K <- grep("GPL13534",sample_sheet$platform_id)
    Array_EPIC <- grep("GPL21145|GPL23976",sample_sheet$platform_id)
    methArray <- c(Array_EPIC,Array_450K)
    
    if (length(Array_450K > 0)){
      print("450K data found!")
    }
    
    if (length(Array_EPIC) > 0){
      print("EPIC data found!")
    }
    
    # if no methylation data is found
    if (length(methArray) == 0){
      cat("No Methylation Data Found...")
      
      cat("\n")
      cat("Removing Temp Files... \n")
      # remove temporary files
      remove.files <- list.files("./GSE_temp/", pattern="[.]{1}gz|soft$")
      setwd("./GSE_temp/")
      do.call(file.remove,list(remove.files))
      setwd("../")
      return(NULL)
      
    }
    cat("\n")
    cat("Removing Temp Files... \n")
    
    # remove temporary files
    remove.files <- list.files("./GSE_temp/", pattern="[.]{1}gz|soft$")
    setwd("./GSE_temp/")
    do.call(file.remove,list(remove.files))
    setwd("../")
    
    return(sample_sheet)
    
  } else {
    
    cat("\n")
    cat("Removing Temp Files... \n")
    
    # remove temporary files
    remove.files <- list.files("./GSE_temp/", pattern="[.]{1}gz|soft$")
    setwd("./GSE_temp/")
    do.call(file.remove,list(remove.files))
    setwd("../")
    
    # return unfiltered sample sheet
    return(sample_sheet)
  }
}


# download GSM Samples ----------------------------------------------------

# downloads all samples associated to a (filtered) sample sheet. Downloaded
# files are stored in "./SampleDownloads/{GSE_Number}/{GSM_Number}/".
# unzip [boolean]: if yes .gz files are unzipped and deleted

# requires : GEOquery

downloadGSM_Samples <- function(sampleSheet, GSE_Nr, unzip = F){
  
  # test for already existing GSE number
  test <- dir.exists(paste(as.character(getwd()),"SampleDownloads",GSE_Nr,sep = "/"))
  
  if (test == T){
    append <- readline(prompt=cat("Samples from GSE ",GSE_Nr, " have already been download. \n",
                                  "Do you want to append more samples? \n",
                                  "[Press y to append, other keys to exit] \n", sep = ""))
    
    if (append != "y"){
      return("Exiting...")
    }                    
  }
  
  
  # INIT
  fileNames <- sampleSheet$geo_accession
  
  # create download folders
  newDirectory <- "SampleDownloads"
  newSubDirectory <- as.character(GSE_Nr)
  path <- getwd()
  
  # donwload folder
  ifelse(!dir.exists(file.path(path, newDirectory)), dir.create(file.path(path, newDirectory)), FALSE)
  setwd("./SampleDownloads/")
  
  # subfolder (GSE number)
  path <- getwd() 
  newSubDirectory <- as.character(GSE_Nr)
  ifelse(!dir.exists(file.path(path, newSubDirectory)), dir.create(file.path(path, newSubDirectory)), FALSE)
  setwd(paste("./",GSE_Nr, sep = ""))
  
  # download samples
  cat("Downloading in progress... \n\n")
  
  
  # zip files
  if (unzip == T){
    
    for (i in fileNames){
      cat("Downloading ", i, "\n")
      getGEOSuppFiles(i)
      
      # fetch files
      print(getwd())
      path2file <- paste(as.character(getwd()),"/",i, sep = "")
      zipFiles <- list.files(path2file, pattern = "[.]gz$")
      
      for (zips in zipFiles){
        cat("Unzipping", zips , "\n")
        gunzip(paste(path2file,zips,sep="/"))
      }
      cat("\n")
    }
  } else {
    for (i in fileNames){
      cat("Downloading ", i, "\n")
      getGEOSuppFiles(i)
    }
  }
  # end 
  cat("File are saved in: ", as.character(getwd()))
  
  # restore wd path
  setwd("../../")
  
}


# filterGEO_samplesheet ---------------------------------------------------

# searches for tissue type specific keywords. Only liver cells are implemented

filterGEO_samplesheet <- function(sampleSheet, filter = "liver"){
  
  if (filter == "liver"){
    searchQuery <- c("hepatocyte", "hepat", "liver", "stellate", "ito[[:punct:]]cells",
                     "oval[[:punct:]]cells", "Kupffer", "pit[[:punct:]]cells", "LSEC",
                     "Liver[[:punct:]]sinusoidal_endothelial[[:punct:]]cell", "hepatic[[:punct:]]sinusoidal",
                     "sinusoidal", "cholangiocyte", "hepatic","hepatic[[:punct:]]duct",
                     "liver[[:punct:]]resident", "stellate", "hepatic[[:punct:]]progenitors",
                     "heptatic[[:punct:]]immune")
    
  } else {
    print("undefined filter...")
    return(sampleSheet)
  }
  
  # create a regex compatible search pattern
  searchQuery <- paste(searchQuery, collapse = "|")
  
  # check title and characteristics_ch1 as both can have the name in it
  idx <- grep(searchQuery,sampleSheet$title, ignore.case = T)
  idx2 <- grep(searchQuery,sampleSheet$characteristics_ch1, ignore.case = T)
  idx3 <- grep(searchQuery,sampleSheet$source_name_ch1, ignore.case = T)
  
  idx <- unique(c(idx,idx2,idx3))
  
  sampleSheet_filtered <- sampleSheet[idx,]
  
  return(sampleSheet_filtered)
}

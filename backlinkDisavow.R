###### OBJECTIVE
###### Design an algorithm that select domain names to disavow
###### Informational read: http://blog.majesticseo.com/training/unnatural-links-investigations/


###### ALLOW BELOW R SCRIPT TO BE EXECUTABE
#!/usr/bin/Rscript


###### IMPORT PREREQUISITE PACKAGES
library('rjson')


###### TODAY'S DATE
date = Sys.Date()


###### IMPORT SETTINGS
json_settings_path = './settings.json'
settings <- fromJSON(paste(readLines(json_settings_path), collapse=""))


###### SET WORKING DIRECTORY
getwd()
setwd("~/Desktop/backlink_project/backlink_cleaner")


###### LOAD DATA
file_name <- list.files(path = "./data/majestic_spreadsheet_data") 
spamdata <- read.csv(paste('./data/majestic_spreadsheet_data', file_name, sep='/'))


###### LOAD BLACK-LISTED DOMAIN NAMES
blacklisted <- settings[['blacklisted_domains']]


###### LOAD WHITELISTED (POSITIVE) KEYWORDS ALLOWED IN DOMAIN NAMES
pKeywords <- settings[['whitelisted_domain_keywords']]

###### LOAD BLACKLISTED (NEGATIVE) KEYWORDS NOT ALLOWED IN DOMAIN NAMES
nKeywords <- settings[['blacklisted_domain_keywords']]

###### LOAD (BENIGN) DIRECTORIES USED BY BRIGHT LOCAL
dirs_submitted = FALSE
if (settings[["directories_submitted"]] == TRUE) {
  file_name <- list.files(path = "./data/directories_submitted/") 
  dirs_submitted <- read.table(paste("./data/directories_submitted", file_name, sep="/"))
  dirs_submitted <- as.list(dirs_submitted)
  dirs_submitted <- as.character(unlist(dirs_submitted))
}


###### SELECTING SITES (ROWS) WITH THE GREATEST CHANCES OF CONTAINING SPAMMY LINKS 
#### Criteria:
### 1. Sites with backlinks greater 15 are candidates for spam.
spamConditional1 <- spamdata$BackLinks >= settings[["backlinks_threshold"]]
disavowListCand1 <- spamdata[spamConditional1, ]

### 2. Sites that are hosted in foreign countries are candidates for spam.
allowedCountryCodes <- c(settings[["allowed_country_codes"]], '', ' ')   # the last two slots are necessary to account for occasional missing data
spamConditional2 <- !(spamdata$CountryCode %in% allowedCountryCodes) 
disavowListCand2 <- spamdata[spamConditional2, ]
head(disavowListCand2, 1)

### 3. Sites with negative keywords in their domain names added to disavow candidate list.
spamdata$Domain <- as.character(spamdata$Domain)
n <- nrow(spamdata)
negMarkerPresence <- rep(NA, n)
for (i in 1:n)
{
  domainName <- spamdata$Domain[i]
  while (is.na(negMarkerPresence[i]))
  {
    for (j in 1:length(nKeywords))
    {
      if (grepl(nKeywords[j], domainName)) { negMarkerPresence[i] <- 1 }
      else { negMarkerPresence[i] <- 0 }
    }
  }
}

spamConditional3 <- negMarkerPresence == 1
disavowListCand3 <- spamdata[spamConditional3, ]


###### BINDING ALL DISAVOW CANDIDATES & ORDERING BY TRUSTFLOW
disavowListCand <- rbind(disavowListCand1, disavowListCand2, disavowListCand3)
disavowListCand <- unique(disavowListCand)
disavowListCand <- disavowListCand[order(-disavowListCand$BackLinks, disavowListCand$TrustFlow), ]


###### CHECKING IF ANY DOMAIN NAME IN THE DISAVOW CANDIDATE LIST ARE ONES SUBMITTED BY YOUR OWN DIRECTORY SUBMISSION; 
if (dirs_submitted != FALSE) { 
  
  submitted_dirs_spammy = intersect(disavowListCand$Domain, dirs_submitted)

  conflicting_dirs_report_header = c("You indicated submissions of your website's link to the below directories. However, the program deems the backlinks coming from these directories are spammy and hence have included these directories in the final disavow list. If you do not wish to disavow these directories, then you can remove them from the disavow_list.txt file in the 'output' folder before submitting it to Google's Disavow Tool.\n")

  write(append(conflicting_dirs_report_header, submitted_dirs_spammy), file=paste('./output/list_of_conflicting_directories_', as.character(date), '.txt', sep=''))  
}


###### ADDING THE BLACKLISTED SITES TO THE TEST DISAVOW 
#### Below line tells which of the blacklisted domain names were in disavow candidates list.
intersect(disavowListCand$Domain, blacklisted)

#### Appending the blacklisted domains to disavow candidates list
disavowFinal <- as.character(disavowListCand$Domain)
disavowFinal <- append(disavowFinal, blacklisted)
disavowFinal <- unique(disavowFinal)


###### TAKING OUT DOMAIN NAMES WITH POSITIVE KEYWORDS FROM DISAVOW LIST
n <- length(disavowFinal)
conditional <- rep(NA, n)
for (i in 1:n)
{
  domainName <- disavowFinal[i]
  while (is.na(conditional[i]))
  {
    for (j in 1:length(pKeywords))
    {
      if (grepl(pKeywords[j], domainName)) { conditional[i] <- FALSE }
    }
    if (is.na(conditional[i])) { conditional[i] <- TRUE }
  }
}
disavowFinal <- disavowFinal[conditional]


###### OPTIONAL ACTIVATION
###### TAKE OUT DOMAIN NAMES FROM FINAL DISAVOW LIST IF THEY WERE WORK OF YOUR OWN DIRECTORY SUBMISSIONS
# overlap <- intersect(disavowFinal, dirs_submitted)
# disavowFinal <- disavowFinal[!(disavowFinal %in% overlap)]


###### OPTIONAL ACTIVATION (for manual users using RStudio)
###### FINAL REVIEW BEFORE THE DISAVOW LIST EXPORT
# disavowFinal
## look up a possibly good domain site via the following command
# disavowListCand[disavowListCand$Domain == "POSSIBLY_GOOD_SITE_DOMAIN_NAME.com", ]


###### EXPORTING THE DISAVOW LIST
for (i in 1:length(disavowFinal)) 
{
  disavowFinal[i] <- paste("domain:", disavowFinal[i])
}

write(disavowFinal, file=paste('./output/', gsub('[.]', '_', settings[["site"]]), '_disavowFinal_', date, '.txt', sep=""))



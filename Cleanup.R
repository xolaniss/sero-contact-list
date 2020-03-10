#Preliminary
setwd("/Users/xolanisibande/SERO-Contact-list")
rm(list=ls())
library(quantmod)
library(xts)
library(zoo)
library(dplyr)
library(tidyr)
library(readxl)
library(httr)
library(XML)
library(rvest)
library(stringr)
library(rebus)
library(filesstrings)
library(purrr)
library(lubridate)
library(textclean)


#Importing

contacts <- data.frame(read_excel("/Users/xolanisibande/SERO-Contact-list/SERO_Contacts_List.xlsx"), stringsAsFactors = F)

#Cleaning

  #Checking basics
str(contacts)
summary(contacts)
head(contacts, 10)

  #Drop NAs and not useful columns
contacts <-contacts %>% filter(!is.na(contacts[,1]))
contacts <- contacts[,-ncol(contacts)]
contacts <- contacts[,-ncol(contacts)]


  #setting names
names(contacts) <-  c("Organisation Type", "Institution", "Recipient", "Designation", "Postal Address", "Physical Address", "Phone", "Fax", "Email")

  #Cleaning Emails"
contacts[, "Email"] <- contacts[,"Email"] %>%  str_remove_all("Email: ") %>% str_remove_all("Phone: ") %>% str_remove_all("Phone:") %>% str_remove_all(":")
contacts[, "Email"]

#Cleaning Phones"
contacts[, "Phone"] <- contacts[,"Phone"] %>%  str_remove_all("Tel: ") %>% str_remove_all("Tel:")
contacts[, "Phone"]
head(contacts, 10)


 #Cleaning Postal Address

contacts[, "Postal Address"] <-  add_comma_space(contacts[, "Postal Address"])
contacts[, "Postal Address"] <- str_replace_all(contacts[, "Postal Address"], ",", "\n")
contacts[, "Postal Address"] <- str_replace(contacts[, "Postal Address"], " Jjohannesburg", "Johannesburg")

  #Cleaning Institution
contacts[, "Institution"] <- str_replace_all(contacts[, "Institution"], ":", "")

#Combining for template
#str_c(contacts[, "Designation"], " : ", contacts[, "Institution"], " \n ", "ATTENTION", " : ", contacts[, "Recipient"], " \n ", contacts[, "Postal Address"])

#Exporting to excel

write.csv(contacts, "Sero_contacts_clean.csv", row.names = F, na = "")




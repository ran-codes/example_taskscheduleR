data_updater_function = function(){
  ## Set up
  setwd("C:/Users/ranli/Desktop/Git local/example_taskscheduleR/Data")
  rm(list = ls())
  library(data.table)
  library(tidyverse)
  
  ## Clean data
  covid_cases_url ="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
  cleaned_data = fread(covid_cases_url) %>% 
    as_tibble() %>% 
    select(fips = FIPS, name = Admin2, contains("/")) %>% 
    pivot_longer(cols = -c(fips, name), 
                 names_to = 'date', 
                 values_to = "cumulative_covid_cases")

  ## Save data
  fwrite(cleaned_data, "../Clean/cleaned_data.csv")
  save(cleaned_data, file = "../Clean/cleaned_data.R" ) 
  
  ## Create Log (Only Once Manually)
  new_log = tibble(time =as.character(Sys.time()),action = "Started Log" )
  fwrite(new_log, "../Clean/update_log.csv")
  
  
  ## Update log 
  old_log = fread("../Clean/update_log.csv") %>% as_tibble() 
  new_entry = tibble(time =as.character(Sys.time()),action = "Automatic update" )
  list(old_log, new_entry) %>% 
    bind_rows() %>% 
    fwrite("../Clean/update_log.csv")
  
  ## Push to Git Repo
  source("git_code.R", local = T)
  git2r::config(user.name = "rl627",user.email = "rl627@drexel.edu")
  git2r::config()
  gitstatus()
  gitadd()
  gitcommit()
  gitpush()
}

data_updater_function()
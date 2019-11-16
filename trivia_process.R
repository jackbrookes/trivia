library(tidyverse)
library(readxl)

path <- "Trivia-Printable.xlsx"

trivia <- read_excel(path, sheet = "Trivia") %>% 
  pivot_longer(everything(), names_to = c(".value", "set"), names_sep = "_") %>% 
  select(-set) %>% 
  mutate(Question = ifelse(str_ends(Question, fixed("?")), Question, paste0(Question, "?")))

millionaire_easy <- read_excel(path, sheet = "Millionaire - Easy Q") %>% 
  pivot_longer(everything(), names_to = c(".value", "set"), names_sep = "_") %>% 
  select(-set) %>% 
  mutate(Category = "Millionaire - Easy")

millionaire_hard <- read_excel(path, sheet = "Millionaire - Hard Q") %>% 
  pivot_longer(everything(), names_to = c(".value", "set"), names_sep = "_") %>% 
  select(-set) %>% 
  mutate(Category = "Millionaire - Hard")

smarter_than <- read_excel(path, sheet = "Smarter Than a 5th Grader") %>% 
  pivot_longer(everything(), names_to = c(".value", "set"), names_sep = "_") %>% 
  select(-set) %>% 
  mutate(Category = "Smarter Than a 5th Grader")

trivia_cat <- read_excel(path, sheet = "Question Needs Category Removed")


# Join, clean up ----------------------------------------------------------

all_questions <- bind_rows(
  trivia,
  millionaire_easy,
  millionaire_hard,
  smarter_than,
  trivia_cat
) %>% 
  filter(!str_starts(Question, "Which of the")) %>% 
  mutate(Answer = str_replace(Answer, " [*]CORRECT[*]", ""),
         Question = iconv(Question, "latin1", "ASCII", sub = ""),
         Answer = iconv(Answer, "latin1", "ASCII", sub = ""))

all_questions %>%
  split(.$Category) %>% 
  map(~select(., -Category)) %>% 
  jsonlite::toJSON() %>% 
  write("trivia.json")

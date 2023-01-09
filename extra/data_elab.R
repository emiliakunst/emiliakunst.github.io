best_selling_artists = read.csv('./data/best_selling_artists.csv')
View(best_selling_artists)

### Are there missing data?
library(Amelia)
missmap(best_selling_artists, main = 'Missings', col = c('Yellow', 'Black'), legend = FALSE)
## No missing data can be found

### Checking variable data types
class(best_selling_artists$Artist)
class(best_selling_artists$Country)
class(best_selling_artists$period_active)
class(best_selling_artists$Year)
class(best_selling_artists$Genre)
class(best_selling_artists$TCU)
class(best_selling_artists$Sales)
## Currently, all variables are stored as character. We might need to change some into numerics, e.g. Sales, but will do so at a later stage.
## Furthermore, many variables are stored in actual strings, but for analysic purposes I will recode some variables.

## Splitting periods active into two variables (start of career vs. end resp. present)
## Yes, I am aware that this way shown down here might be a bit complicated and there will be more efficient ways but it is running, so I will stick with it for now.
best_selling_artists$period_active = gsub('present', '2022', best_selling_artists$period_active)

library(dplyr)
library(tidyr)
best_selling_artists = separate(best_selling_artists, period_active, c('part_1', 'part_2', 'part_3'), sep = ',', fill = 'right', remove = FALSE)
best_selling_artists$part_1 = gsub(' ', '', best_selling_artists$part_1)
best_selling_artists$part_2 = gsub(' ', '', best_selling_artists$part_2)
best_selling_artists$part_3 = gsub(' ', '', best_selling_artists$part_3)

## split into genres and make them lower case
best_selling_artists = separate(best_selling_artists, Genre, c('genre_1', 'genre_2', 'genre_3', 'genre_4', 'genre_5'), sep = '/', fill = 'right', remove = FALSE)
best_selling_artists$genre_1 = tolower(best_selling_artists$genre_1)
best_selling_artists$genre_2 = tolower(best_selling_artists$genre_2)
best_selling_artists$genre_3 = tolower(best_selling_artists$genre_3)
best_selling_artists$genre_4 = tolower(best_selling_artists$genre_4)
best_selling_artists$genre_5 = tolower(best_selling_artists$genre_5)
best_selling_artists = select(best_selling_artists, -c('Genre'))

library(stringr)
best_selling_artists$start_of_career =  0
best_selling_artists$end_of_career = 0
for (i in 1:length(best_selling_artists$part_2)){
  if (is.na(best_selling_artists$part_2[i])){
    best_selling_artists$end_of_career[i] = str_sub(best_selling_artists$part_1[i],6,9)
    best_selling_artists$start_of_career[i] = str_sub(best_selling_artists$part_1[i],1,4)
  } else if (!is.na(best_selling_artists$part_3[i])){
    best_selling_artists$start_of_career[i] = str_sub(best_selling_artists$part_1[i],1,4)
    best_selling_artists$end_of_career[i] = str_sub(best_selling_artists$part_3[i],6,9)
  } else {
    best_selling_artists$start_of_career[i] = str_sub(best_selling_artists$part_1[i],1,4)
    best_selling_artists$end_of_career[i] = str_sub(best_selling_artists$part_2[i],6,9)
  }}  

best_selling_artists$start_of_career = as.numeric(best_selling_artists$start_of_career)
best_selling_artists$end_of_career = as.numeric(best_selling_artists$end_of_career)

## Career duration
best_selling_artists$duration_of_career = best_selling_artists$end_of_career - best_selling_artists$start_of_career

## Reworking Sales numbers as some artists have two numbers listed in the same column and it is unclear where the second number comes from.
## I will drop the second number although other ways are also possible, e.g. calculating the mean value etc, but as I don't know the data quality, I will chose this route.
best_selling_artists$Sales[best_selling_artists$Artist == 'Christina Aguilera'] = 100
best_selling_artists$Sales = gsub('million.*', '', best_selling_artists$Sales)
best_selling_artists$TCU = gsub('million.*', '', best_selling_artists$TCU)

best_selling_artists$Sales = as.numeric(best_selling_artists$Sales)
best_selling_artists$TCU = as.numeric(best_selling_artists$TCU)



### Dropping unnecessary variables
library(dplyr)
best_selling_artists = select(best_selling_artists, -c('period_active'))
best_selling_artists = select(best_selling_artists, -c('part_1', 'part_2', 'part_3'))

### Adding variables I deem important
## Band vs Solo Artist (concatenation of artists and their status regarding band vs solo artist was done in Excel)
best_selling_artists$Band_Solo = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'The Beatles'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Elvis Presley'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Michael Jackson'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Elton John'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Queen'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Madonna'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Led Zeppelin'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Rihanna'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Pink Floyd'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Eminem'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Mariah Carey'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Taylor Swift'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Beyoncé'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Whitney Houston'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Eagles'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Celine Dion'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'AC/DC'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'The Rolling Stones'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Drake'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Garth Brooks'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Kanye West'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Billy Joel'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Justin Bieber'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Ed Sheeran'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Bruno Mars'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Bruce Springsteen'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'U2'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Aerosmith'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Phil Collins'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Barbra Streisand'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'ABBA'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Frank Sinatra'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Katy Perry'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Chris Brown'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Jay-Z'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Metallica'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Lady Gaga'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Lil Wayne'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Maroon 5'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Adele'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Red Hot Chili Peppers'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Fleetwood Mac'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Bon Jovi'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Rod Stewart'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Bee Gees'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Nicki Minaj'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Coldplay'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Linkin Park'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'George Strait'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Pink'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Britney Spears'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == "B'z"] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Shania Twain'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == "Guns N' Roses"] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Backstreet Boys'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Eric Clapton'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Neil Diamond'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Prince'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Journey'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Paul McCartney'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Janet Jackson'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Kenny Rogers'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Santana'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Simon & Garfunkel'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'George Michael'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Julio Iglesias'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Dire Straits'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'The Doors'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Foreigner'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Chicago'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Bob Dylan'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'The Carpenters'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Meat Loaf'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Earth, Wind & Fire'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Cher'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Def Leppard'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Genesis'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'David Bowie'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Stevie Wonder'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'James Taylor'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Tina Turner'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Olivia Newton-John'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Linda Ronstadt'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'The Beach Boys'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Donna Summer'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Alicia Keys'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Christina Aguilera'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Lionel Richie'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Johnny Cash'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Justin Timberlake'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Ariana Grande'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'R.E.M.'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Post Malone'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Flo Rida'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Usher'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Shakira'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Tim McGraw'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'The Black Eyed Peas'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Van Halen'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Ayumi Hamasaki'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Tom Petty'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Johnny Hallyday'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'The Weeknd'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Imagine Dragons'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Luke Bryan'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Tupac Shakur'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Alabama'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'R. Kelly'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Nirvana'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Robbie Williams'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Bob Seger'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Kenny G'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Green Day'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Enya'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Bryan Adams'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Bob Marley'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'The Police'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Gloria Estefan'] = 1
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Barry Manilow'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Kiss'] = 0
best_selling_artists$Band_Solo[best_selling_artists$Artist == 'Aretha Franklin'] = 1
best_selling_artists$Band_Solo = as.factor(best_selling_artists$Band_Solo)

## Identified Gender (for bands = majority of band members, if on par = front leaders identified gender)
best_selling_artists$Gender = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'The Beatles'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Elvis Presley'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Michael Jackson'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Elton John'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Queen'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Madonna'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Led Zeppelin'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Rihanna'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Pink Floyd'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Eminem'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Mariah Carey'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Taylor Swift'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Beyoncé'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Whitney Houston'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Eagles'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Celine Dion'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'AC/DC'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'The Rolling Stones'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Drake'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Garth Brooks'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Kanye West'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Billy Joel'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Justin Bieber'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Ed Sheeran'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Bruno Mars'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Bruce Springsteen'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'U2'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Aerosmith'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Phil Collins'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Barbra Streisand'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'ABBA'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Frank Sinatra'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Katy Perry'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Chris Brown'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Jay-Z'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Metallica'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Lady Gaga'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Lil Wayne'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Maroon 5'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Adele'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Red Hot Chili Peppers'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Fleetwood Mac'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Bon Jovi'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Rod Stewart'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Bee Gees'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Nicki Minaj'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Coldplay'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Linkin Park'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'George Strait'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Pink'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Britney Spears'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == "B'z"] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Shania Twain'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == "Guns N' Roses"] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Backstreet Boys'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Eric Clapton'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Neil Diamond'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Prince'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Journey'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Paul McCartney'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Janet Jackson'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Kenny Rogers'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Santana'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Simon & Garfunkel'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'George Michael'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Julio Iglesias'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Dire Straits'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'The Doors'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Foreigner'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Chicago'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Bob Dylan'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'The Carpenters'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Meat Loaf'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Earth, Wind & Fire'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Cher'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Def Leppard'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Genesis'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'David Bowie'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Stevie Wonder'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'James Taylor'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Tina Turner'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Olivia Newton-John'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Linda Ronstadt'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'The Beach Boys'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Donna Summer'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Alicia Keys'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Christina Aguilera'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Lionel Richie'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Johnny Cash'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Justin Timberlake'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Ariana Grande'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'R.E.M.'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Post Malone'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Flo Rida'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Usher'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Shakira'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Tim McGraw'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'The Black Eyed Peas'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Van Halen'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Ayumi Hamasaki'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Tom Petty'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Johnny Hallyday'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'The Weeknd'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Imagine Dragons'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Luke Bryan'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Tupac Shakur'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Alabama'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'R. Kelly'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Nirvana'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Robbie Williams'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Bob Seger'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Kenny G'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Green Day'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Enya'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Bryan Adams'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Bob Marley'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'The Police'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Gloria Estefan'] = 1
best_selling_artists$Gender[best_selling_artists$Artist == 'Barry Manilow'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Kiss'] = 0
best_selling_artists$Gender[best_selling_artists$Artist == 'Aretha Franklin'] = 1
best_selling_artists$Gender = as.factor(best_selling_artists$Gender)


### Visualizing data and analyzing
# Range of Sales
library(ggplot2)
library(ggthemes)
range_of_sales = ggplot(best_selling_artists, aes(Sales)) + geom_histogram(binwidth = 15, color = 'blue', fill = 'white') + xlab('Sales per Artist')
print(range_of_sales)
## There are only a few artists/ bands with very high sales, namely: The Beatles, Elvis Presley and Michael Jackson.
## It might be sensible to leave these ones out when doing any kind of statistical analysis.

gender_distribution = ggplot(best_selling_artists, aes(Gender)) + geom_bar(color = 'blue', fill = 'white') + xlab('Gender of Artists') + scale_x_discrete(labels = c('male', 'female')) + geom_text(stat = "count", aes(label = after_stat(count)), vjust = -1)
print(gender_distribution)
## 3/4 of best selling artists/ bands are male/ male dominated (bands).

band_vs_solo_artist_distribution = ggplot(best_selling_artists, aes(Band_Solo)) + geom_bar(color = 'blue', fill = 'white') + xlab('Band vs Solo Artist') + scale_x_discrete(labels = c('Band', 'Solo Artist')) + geom_text(stat = "count", aes(label = after_stat(count)), vjust = -1)
print(band_vs_solo_artist_distribution)
## The majority of best selling artists consists of bands (79 vs. 42)

country_distribution = ggplot(best_selling_artists, aes(Country)) + geom_bar(color = 'blue', fill = 'white') + xlab('Country of Artists') + scale_x_discrete(labels = c('Australia', 'Sweden', 'Trinidad and Tobago', 'United Kingdom', 'United States', 'Barbados', 'Canada', 'Colombia', 'France', 'Ireland', 'Jamaica', 'Japan', 'Spain')) + geom_text(stat = "count", aes(label = after_stat(count)), vjust = -1) + theme (axis.text.x = element_text(angle = 90))
print(country_distribution)
## It might come as no surprise that the US as well as the UK are dominating here. 
## While Canada still accounts for 6 artists/ bands, all other countries listed here have usually one or two acts within this list.
## The list is overall very dominated by US/Canada and Europe.

# Sales vs Gender
sales_vs_gender = ggplot(best_selling_artists, aes(Sales)) + geom_histogram(color = 'white', aes(fill = factor(Gender))) + xlab('Sales') + ylab('Count') + scale_fill_hue(labels = c('Male', 'Female'))
print(sales_vs_gender)
## Top selling artists were men or male bands.

# Sales vs Band/ Solo
sales_vs_solo_artistry = ggplot(best_selling_artists, aes(Sales)) + geom_histogram(color = 'white', aes(fill = factor(Band_Solo))) + xlab('Sales') + ylab('Count') + scale_fill_hue(labels = c('Band', 'Solo Artist'))
print(sales_vs_solo_artistry)

# Sales vs Country
sales_vs_country = ggplot(best_selling_artists, aes(x=Sales, y= Country)) + geom_point(size = 4, aes(color = factor(Country))) + xlab('Sales') + ylab('Country')+ scale_color_hue(labels = c('Australia', 'Sweden', 'Trinidad and Tobago', 'United Kingdom', 'United States', 'Barbados', 'Canada', 'Colombia', 'France', 'Ireland', 'Jamaica', 'Japan', 'Spain'))
print(sales_vs_country)
## Bands/ artists from other countries than US/UK usually did sell less records than US/ UK artists/ bands.
# Mean per country:
mean_of_sales_per_country = aggregate(x = best_selling_artists$Sales, by = list(best_selling_artists$Country), FUN = mean)
print(mean_of_sales_per_country)
## ANOVA for comparison


# Sales vs Duration of career
sales_vs_duration_of_career = ggplot(best_selling_artists, aes(x=Sales, y= duration_of_career)) + geom_point()
print(sales_vs_duration_of_career)
## There seems to be no correlation beteween sales and duration of career.
## Correlation sales and duration of career
cor.test(best_selling_artists$Sales, best_selling_artists$duration_of_career)
## No correlation can be found.

write.csv(best_selling_artists, "./data/best_selling_artists_new.csv", row.names=FALSE)

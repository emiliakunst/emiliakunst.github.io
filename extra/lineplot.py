from typing import DefaultDict
import pandas as pd
from collections import defaultdict
artists = pd.read_csv("./data/best_selling_artists_new.csv")

# print(artists.to_string())

first_year = min(artists.loc[:,"start_of_career"])
last_year = max(artists.loc[:,"end_of_career"])
countries = artists.Country.unique()
# print(first_year, last_year, countries)

lineplot_array = []
for year in range(first_year, last_year+1):
    year_dict = {k:0 for k in countries}
    for index, row in artists.iterrows():
        if row['start_of_career'] <= year <= row['end_of_career']:
            year_dict[row['Country']] += 1
    # print(str(year_dict)+"\n")
    for key in year_dict:
        lineplot_array.append([year, key, year_dict[key]])
    # print(lineplot_array)

lineplot = pd.DataFrame(lineplot_array, columns=['year', 'Country', 'Count'])
print(lineplot.to_string())

lineplot.to_csv("./data/lineplot.csv", index=False)
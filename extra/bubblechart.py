import pandas as pd
artists = pd.read_csv("./data/best_selling_artists_new.csv")

# print(artists.to_string())

# first_year = min(artists.loc[:,"start_of_career"])
# last_year = max(artists.loc[:,"end_of_career"])
# countries = artists.Country.unique()
# print(first_year, last_year, countries)
# print(countries)

bubblechart_array = []
# for year in range(first_year, last_year+1):
#     year_dict = {k:0 for k in countries}
#     for index, row in artists.iterrows():
#         if row['start_of_career'] <= year <= row['end_of_career']:
#             year_dict[row['Country']] += 1
#     # print(str(year_dict)+"\n")
#     for key in year_dict:
#         bubblechart_array.append([year, key, year_dict[key]])
#     # print(bubblechart_array)

#bubblechart = pd.DataFrame(bubblechart_array, columns=['Country', 'TCU', 'Sales', 'Duration', 'Name'])
bubblechart = artists.filter(['Country','TCU','Sales', 'duration_of_career', 'Artist'], axis=1)
# print(bubblechart.to_string())

# bubblechart.to_csv("./data/bubblechart.csv", index=False)

# print("min: "+str(min(bubblechart.loc[:,"Sales"])))
# print("max: "+str(max(bubblechart.loc[:,"Sales"])))
print("sum: "+str(sum(bubblechart.loc[:,"TCU"])))
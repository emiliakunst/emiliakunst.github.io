import pandas as pd

artists = pd.read_csv("./data/best_selling_artists_new.csv")

# print(artists.to_string())

tcus = artists[['Country', 'TCU']]

print(tcus.to_string())

print("\n\n\n")

worldmap = tcus.groupby(by='Country').sum()

print(worldmap.to_string())

worldmap.to_csv("./data/worldmap.csv")


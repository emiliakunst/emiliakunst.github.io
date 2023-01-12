import pandas as pd
import numpy as np
artists = pd.read_csv("./data/best_selling_artists_new.csv")

print(artists.to_string())

wordcloud_list = ""

for index, row in artists.iterrows():
    wordcloud_list += '{word: "'+row['Artist']+'", size: "'+str(round(row['TCU']/2, 0))+'"}, '


# wordcloud = pd.DataFrame(wordcloud_array, columns=["word", "size"])



print(wordcloud_list)

# print(wordcloud.to_string())

# wordcloud.to_csv("./data/wordcloud.csv", index=False)
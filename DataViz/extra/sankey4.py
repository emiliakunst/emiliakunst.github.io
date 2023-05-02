import pandas as pd
import numpy as np
main = pd.read_csv("./data/allsub.csv")

rock = ['progressive rock', 'grunge', 'pop rock', 'art rock', 'glam rock', 'psychedelic rock', 'blues rock', 'folk rock', 'hard rock', 'surf rock', 'soft rock', 'alternative rock', 'funk rock', 'rap rock', 'rock and roll', 'punk rock']
pop = ['country pop', 'j-pop', 'teen pop', 'dance pop', 'latin pop', 'folk pop', 'pop punk','adult contemporary', 'pop rock', 'electropop', 'dance-pop']
rnbsoul = ['soul', 'gospel', 'neo soul', 'r&b']
blues = ['blues rock', ]
folk = ['folk rock', 'folk pop', 'celtic']
metal = ['heavy metal', 'glam metal', 'thrash metal', 'nu metal']
electronic = ['disco', 'electropop', 'dance-pop', 'electronica', 'hip house', 'edm', 'new-age']
jazz = ['swing', 'smooth jazz']
funk = ['funk rock']
hiphop = ['rap rock']
punk = ['pop punk', 'punk rock']
country = ['country pop']

for i in rock:
    main = main.replace(i, "rock")
for i in pop:
    main = main.replace(i, "pop")
for i in rnbsoul:
    main = main.replace(i, "r&b and soul")
for i in blues:
    main = main.replace(i, "blues")
for i in folk:
    main = main.replace(i, "folk")
for i in metal:
    main = main.replace(i, "metal")
for i in electronic:
    main = main.replace(i, "electronic")
for i in jazz:
    main = main.replace(i, "jazz")
for i in funk:
    main = main.replace(i, "funk")
for i in hiphop:
    main = main.replace(i, "hip-hop")
for i in punk:
    main = main.replace(i, "punk")
for i in country:
    main = main.replace(i, "country")

print(main)

main.to_csv("./data/allmain.csv", index=False)
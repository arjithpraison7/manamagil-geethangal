import json
import re

# Load the songs.json file
with open('songs.json', 'r', encoding='utf-8') as f:
    songs = json.load(f)

# Normalize titles and count songs
title_pattern = re.compile(r"பாடல்\s*-?\s*(\d+)")
for idx, song in enumerate(songs, 1):
    # Try to extract the number from the title
    match = title_pattern.search(song.get('title', ''))
    if match:
        number = match.group(1)
    else:
        number = str(idx)
    song['title'] = f"பாடல் {number}"

# Print the total number of songs
print(f"Total songs: {len(songs)}")

# Save to a new file
with open('songs_cleaned.json', 'w', encoding='utf-8') as f:
    json.dump(songs, f, ensure_ascii=False, indent=2)

print('Normalized titles and saved to songs_cleaned.json')

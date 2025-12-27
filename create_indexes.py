import json

# Create Sunday School index
with open('assets/sunday_school_songs_cleaned.json', 'r', encoding='utf-8') as f:
    songs = json.load(f)

index_lines = []
for i, song in enumerate(songs, 1):
    first_line = song['lyrics'].split('\n')[0].strip()
    index_lines.append(f"{first_line},{i}")

with open('assets/sunday_school_index.csv', 'w', encoding='utf-8') as f:
    f.write('\n'.join(index_lines))

print(f"Created Sunday School index with {len(index_lines)} entries")

# Verify Aruthal Geethangal
with open('assets/aruthal_geethangal.json', 'r', encoding='utf-8') as f:
    songs = json.load(f)

print(f"\nAruthal Geethangal has {len(songs)} songs")
for i, song in enumerate(songs[:5], 1):
    print(f"  Song {i}: {song['title']}")

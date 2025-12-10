

# New approach: split on 'பாடல்' and reconstruct songs
import json

with open('aruthal_geethangal.txt', 'r', encoding='utf-8') as f:
    content = f.read()

parts = content.split('பாடல்')
songs = []
for part in parts:
    part = part.strip()
    if not part:
        continue
    # The first line is the title (may include number, dashes, etc.)
    lines = part.splitlines()
    title = 'பாடல்' + lines[0].strip()
    lyrics = '\n'.join(lines[1:]).strip()
    songs.append({'title': title, 'lyrics': lyrics})

with open('aruthal_geethangal.json', 'w', encoding='utf-8') as f:
    json.dump(songs, f, ensure_ascii=False, indent=2)

print(f"Extracted {len(songs)} songs to aruthal_geethangal.json")

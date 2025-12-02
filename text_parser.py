from docx import Document
import json
import re

def parse_songs_from_docx(docx_path):
    doc = Document(docx_path)
    text = "\n".join([para.text for para in doc.paragraphs])
    # Split by "பாடல் <number>"
    # song_splits = re.split(r'(பாடல்\s*\d+)', text)
    song_splits = re.split(r'(பாடல்\s*-?\s*\d+)', text)
    songs = []
    for i in range(1, len(song_splits), 2):
        title = song_splits[i].strip()
        lyrics = song_splits[i+1].strip()
        songs.append({'title': title, 'lyrics': lyrics})
    return songs

if __name__ == "__main__":
    songs = parse_songs_from_docx("MANAMAKIZHI KEETHANGAL.docx")
    with open("songs.json", "w", encoding="utf-8") as f:
        json.dump(songs, f, ensure_ascii=False, indent=2)
    print("Exported to songs.json")
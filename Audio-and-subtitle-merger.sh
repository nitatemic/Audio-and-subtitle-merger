#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_directory>"
  exit 1
fi

# Input directory
input_directory="$1"

# Ensure that the input directory exists
if [ ! -d "$input_directory" ]; then
  echo "Input directory '$input_directory' does not exist."
  exit 1
fi

# Iterate through the files in the input directory
for audio_file in "$input_directory"/*.mp3; do
  if [ -e "$audio_file" ]; then
    # Get the base name of the audio file (without the extension)
    base_name=$(basename "$audio_file" .mp3)

    # Check if the corresponding .srt file exists
    srt_file="$input_directory/$base_name.srt"
    if [ -e "$srt_file" ]; then
      # Convert the audio file to .flac with subtitles
      if ffmpeg -i "$audio_file" -vf "subtitles=$srt_file" -c:a flac "$input_directory/$base_name.flac" 2>/dev/null; then
        echo "Conversion of $audio_file completed."
      else
        echo "Error during conversion of $audio_file."
      fi
    else
      echo "No corresponding .srt file found for $audio_file."
    fi
  fi
done

echo "All conversions are completed."

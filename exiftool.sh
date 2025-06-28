Source: https://www.reddit.com/r/datacurator/comments/wik3al/is_there_a_programmethod_to_change_photo_files/
exiftool -m -P -overwrite_original_in_place '-DateTimeOriginal=2025:06:15 06:00:00' *.jpg
exiftool -m -overwrite_original_in_place '-FileCreateDate<ExifIFD:DateTimeOriginal' '-FileModifyDate<ExifIFD:DateTimeOriginal' *.jpg

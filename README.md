
# Pitch Please SF

This is a collection of automated scripts for use by the acappella group Pitch Please SF.

## Installation

```bash
git clone git@github.com:wenley/PitchPleaseSF.git
cd PitchPleaseSF
gem install bundler
bundle
rake
```

## How to use

This repository supports the following main actions:
1. Generating a set of files for ear training.
2. Generating learning tracks from a full score
3. Generating a PDF for a full score

#### Ear Training
```
rake make_interval_test
```

This will automatically generate three files in the `output/ear_training` directory:
1. `intervals.mscz`, a Musescore file with 10 randomly chosen intervals
2. `ear_training.mp3`, audio version of those intervals
3. `answer.txt`, the "answer key" for those intervals

#### Learning Tracks

```
rake make_learning_tracks['path/to/musescore/file.mscz']
```

This will automatically generate 1 MP3 file per part.

The output location is based on the name of the input Musescore file. e.g. If the input Musescore file is named 'some/path/Moon_River.mscz', then the output directory for the MP3s will be `output/Moon_River/`.

#### Making PDFs
```
rake make_pdf['path/to/musescore/file.mscz']
```

This will automatically generate a PDF for the Musescore file.

Like with the learning tracks, the output location is based on the name of the input Musescore file. e.g. If the input Musescore file is named 'some/path/Moon_River.mscz', then the output directory for the MP3s will be `output/Moon_River/`.


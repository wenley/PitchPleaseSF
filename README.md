
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

This repository supports one main action: Generating a set of files for ear training.

```
rake make_interval_test
```

This will automatically generate three files:
1. `intervals.mscz`, a Musescore file with 10 randomly chosen intervals
2. `ear_training.mp3`, audio version of those intervals
3. `answer.txt`, the "answer key" for those intervals


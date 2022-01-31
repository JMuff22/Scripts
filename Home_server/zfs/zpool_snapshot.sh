#!/bin/bash
for i in 3 4; do
  echo "Rotating weekly snapshots"
  zfs destroy -r naspool${i}@week4
  zfs rename -r naspool${i}@week3 @week4
  zfs rename -r naspool${i}@week2 @week3
  zfs rename -r naspool${i}@week1 @week2
  zfs snapshot -r naspool${i}@week1
done
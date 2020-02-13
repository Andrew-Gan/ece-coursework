OUTPUT=${OUTFILE}.out
echo $OUTPUT
OUT_ERR=${OUTFILE}.err
echo $OUT_ERR
./cmd1 < $INFILE | ./cmd3 > $OUTPUT 2> $OUT_ERR

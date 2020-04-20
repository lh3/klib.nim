import klib

var
  argv = getArgv()
  f = xopen[GzFile](argv[0])
  r: FastxRecord
while f.readFastx(r):
  echo "name: ", r.name
  echo "comment: ", r.comment
  echo "seq: ", r.seq
  echo "qual: ", r.qual
echo r.status
f.close()

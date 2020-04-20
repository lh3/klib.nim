import klib
import tables
import strutils

var argv = getArgv()
if argv.len < 2:
  echo "Usage: bedcov <loaded.bed> <streamed.bed>"
  quit()

var
  f1 = xopen[GzFile](argv[0])
  bed = initTable[string, seq[Interval[int]]]()
  line: string
  lineno: int = 0
while f1.readLine(line):
  var t = line.split('\t')
  if not bed.hasKey(t[0]): bed[t[0]] = @[]
  bed[t[0]].add((parseInt(t[1]), parseInt(t[2]), lineno, 0))
  lineno += 1
for ctg in bed.keys():
  bed[ctg].index()
f1.close()

var f2 = xopen[GzFile](argv[1])
while f2.readLine(line):
  var t = line.split('\t')
  if not bed.hasKey(t[0]):
    echo t[0], '\t', t[1], '\t', t[2], "\t0\t0"
  else:
    var a = bed[t[0]].addr
    let st0 = parseInt(t[1])
    let en0 = parseInt(t[2])
    var cov_st, cov_en, cov, cnt: int
    for x in a[].overlap(st0, en0):
      cnt += 1
      let st1 = if x.st > st0: x.st else: st0
      let en1 = if x.en < en0: x.en else: en0
      if st1 > cov_en:
        cov += cov_en - cov_st
        (cov_st, cov_en) = (st1, en1)
      else:
        cov_en = if cov_en > en1: cov_en else: en1
    cov += cov_en - cov_st
    echo [t[0], t[1], t[2], $cnt, $cov].join("\t")
f2.close()

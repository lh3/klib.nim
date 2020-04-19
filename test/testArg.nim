import klib

var argv = getArgv()
for opt, arg in getopt(argv, "x:y", @["foo=", "bar"]):
  echo "opt: \"", opt, "\"; arg: \"", arg, "\""

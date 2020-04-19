import klib

var argv = getArgv()
echo "Options:"
for opt, arg in getopt(argv, "x:y", @["foo=", "bar"]):
  echo "  opt: \"", opt, "\"; arg: \"", arg, "\""

echo "Arguments:"
for x in argv:
  echo "  ", x

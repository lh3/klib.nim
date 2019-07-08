import os

proc kGetArgv*(): seq[string] =
  for i in 1 .. paramCount():
    result.add(paramStr(i))

iterator kGetopt*(argv: var seq[string], ostr: string, longopts: seq[string] = @[]): (string, string) =
  var
    pos = 0
    cur = 0
  while cur < argv.len:
    var
      lopt = "" # long option
      opt = '?' # short option
      arg = ""  # option argument
    while cur < argv.len: # look for an option
      if argv[cur][0] == '-' and argv[cur].len > 1: # an option or "--"
        if argv[cur].len == 2 and argv[cur][1] == '-': # "--"
          cur = argv.len
        break
      else: cur += 1
    if cur == argv.len: break
    let a = argv[cur]
    if a[0..1] == "--": # long option
      pos = -1
      var
        pos_eq = find(a, '=')
        o = a[2 ..< a.len]
        c = 0
        k = -1
        tmp = ""
      if pos_eq > 0:
        o = a[2 ..< pos_eq]
        arg = a[pos_eq+1 ..< a.len]
      for i, x in longopts: # look for matching long options
        var y = x
        if y[^1] == '=': y = y[0 ..< y.len-1]
        if o.len <= y.len and o == y[0 ..< o.len]: # prefix match
          k = i; c += 1; tmp = y
          if o == y: # exact option match
            c = 1
            break
      if c == 1: # find a unique match
        lopt = tmp
        if pos_eq < 0 and longopts[k][^1] == '=' and cur + 1 < argv.len:
          arg = argv[cur + 1]
          argv.delete(cur + 1)
    else: # short option
      if pos == 0: pos = 1
      opt = a[pos]
      pos += 1
      var k = find(ostr, opt)
      if k < 0: opt = '?'
      elif k + 1 < ostr.len and ostr[k + 1] == ':': # requiring an argument
        if pos >= a.len:
          if cur + 1 < argv.len:
            arg = argv[cur + 1]
            argv.delete(cur + 1)
        else:
          arg = a[pos ..< a.len]
        pos = -1
    if pos < 0 or pos >= argv[cur].len:
      argv.delete(cur)
      pos = 0
    if lopt != "": yield ("--" & lopt, arg)
    else: yield ("-" & opt, arg)

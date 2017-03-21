module Getopts

export getopts

"""
```
function skipcwhile(instr, startidx=1, mchars=" \\t")
```
Consume and skip characters **WHILE** they match characters specified in
mchars. Return index of first character following consumed characters
in string.
"""
function skipcwhile(instr, startidx=1, mchars=" \t")
  idx = startidx
  while !done(instr, idx) && instr[idx] in mchars
    idx = next(instr, idx)[2]
  end
  idx
end

"""
```
function getcuntil(instr, startidx=1, mchars=" \\t")
```
Consume and return characters in input string **UNTIL** a character
specified in mchars (match characters) occurs. Also return index
of first character following consumed characters in string.
"""
function getcuntil(instr, startidx=1, mchars=" \t")
  idx = startidx
  outstr = ""
  while !done(instr, idx) && !(instr[idx] in mchars)
    outstr = string(outstr, instr[idx])
    idx = next(instr, idx)[2]
  end
  outstr, idx
end

"""
```
function getcuntilunless(instr, startidx=1, mchars=" \\t", uchars="-")
```
Consume and return characters in input string **UNTIL** a character
specified in mchars (match characters) occurs, **UNLESS** the input string
starts with a character specified in uchars. Also return index
of first character following consumed characters in string.
"""
function getcuntilunless(instr, startidx=1, mchars=" \t", uchars="-")
  outstr, idx = done(instr, startidx) || 
                (instr[startidx] in uchars) ? ("", startidx) : 
                                              getcuntil(instr, startidx, " \t")
end

function getopts(instr::AbstractString)
  opts = Dict{AbstractString,Array{AbstractString,1}}()
  argv = Array{AbstractString,1}()
  idx = start(instr)
  while !done(instr, idx)
    while true
      idx = skipcwhile(instr, idx, " \t")
      arg, idx = getcuntilunless(instr, idx, " \t", "-")
      arg != "" && push!(argv, arg)
      (arg == "" || done(instr, idx)) && break
    end
    if !done(instr, idx)
      key, idx = getcuntil(instr, idx, " \t")
      !(key in keys(opts)) && (opts[key] = Array{AbstractString,1}())
      idx = skipcwhile(instr, idx, " \t")
      val, idx = getcuntilunless(instr, idx, " \t", "-")
      push!(opts[key], val)
    end
  end
  opts, argv
end

function getopts{S<:AbstractString}(inarray::AbstractArray{S,1})
  getopts(foldl(string,map(x->string(" ",x),inarray)))
end

end

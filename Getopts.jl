module Getopts

export getopts

function skipcwhile(instr, startidx=1, mchars=" \t")
  idx = startidx
  while !done(instr, idx) && instr[idx] in mchars
    idx = next(instr, idx)[2]
  end
  idx
end

function getcuntil(instr, startidx=1, mchars=" \t")
  idx = startidx
  outstr = ""
  while !done(instr, idx) && !(instr[idx] in mchars)
    outstr = string(outstr, instr[idx])
    idx = next(instr, idx)[2]
  end
  outstr, idx
end

function getopts(instr::AbstractString)
  opts = Dict{AbstractString,Array{AbstractString,1}}()
  argv = Array{AbstractString,1}()
  idx = start(instr)
  while !done(instr, idx)
    while true
      idx = skipcwhile(instr, idx, " \t")
      arg, idx = done(instr, idx) || instr[idx] == '-' ? ("", idx) : 
                                                         getcuntil(instr, idx, " \t")
      arg != "" && push!(argv, arg)
      (arg == "" || done(instr, idx)) && break
    end
    if !done(instr, idx)
      key, idx = getcuntil(instr, idx, " \t")
      !(key in keys(opts)) && (opts[key] = Array{AbstractString,1}())
      idx = skipcwhile(instr, idx, " \t")
      val, idx = done(instr, idx) || instr[idx] == '-' ? ("", idx) : 
                                                         getcuntil(instr, idx, " \t")
      push!(opts[key], val)
    end
  end
  opts, argv
end

function getopts{S<:AbstractString}(inarray::AbstractArray{S,1})
  getopts(foldl(string,map(x->string(" ",x),inarray)))
end

end

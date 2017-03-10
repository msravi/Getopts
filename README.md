# Getopts
## Command line options argument parser in Julia

The getopts() function accepts a string or a list of strings to be parsed for options/arguments and outputs a dictionary
of key/value pairs where the keys are option names and the value of each key is an associated list of option arguments.

If the input is a list(vector) of strings, the strings are concatenated with whitespace delimiters and parsed as a single string. 
Thus, the ARGS parameter containing command line arguments can be passed directly into getopts(). Orphaned arguments 
(arguments without an associated option) are also returned as an additional list.

An option name begins with a '-', and may or may not have an argument associated with it. Multiple arguments may
also be associated with a single option by repeating the option name.
```
-date 20170101 -skip -date 2017-01-02
```
In the opt/arg list above, a single option (-date) has two arguments (20170101 and 2017-01-02) associated with it.
The -skip option does not have an argument. Options with no arguments are returned as part of the options-arguments 
dictionary, with an empty string as the argument.

An argument only associates with an immediate preceding option name. Arguments that are not immediately preceded
by an option name are orphaned arguments. Orphaned arguments are returned as a separate list in addition to the 
options-arguments dictionary. 
```
-date 20170101 -skip -date 2017-01-02 orphan1 -date 20170103 orphan2 orphan3
```
Whitespaces are used as delimiters and redundant whitespaces have no effect.

###Usage:

```
julia> using Getopts

julia> opts, argv=getopts("myprog -date 20170201 sym1  sym2   -date 2017-03-03 sym3 --blah bah -π 3.14  -μ   -car")

julia> opts
Dict{AbstractString,Array{AbstractString,1}} with 5 entries:
  "--blah" => AbstractString["bah"]
  "-car"   => AbstractString[""]
  "-date"  => AbstractString["20170201","2017-03-03"]
  "-π"     => AbstractString["3.14"]
  "-μ"     => AbstractString[""]

julia> argv
4-element Array{AbstractString,1}:
 "myprog"
 "sym1"
 "sym2"
 "sym3"
 ```

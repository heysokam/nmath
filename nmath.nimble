#:_____________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:_____________________________________________________
import std/[ os,strformat ]

#___________________
# Package
packageName   = "nmath"
version       = "0.1.0"
author        = "sOkam"
description   = "n*math | Nim Math Tools"
license       = "MIT"

#___________________
# Folders
srcDir           = "src"
binDir           = "bin"
let testsDir     = "tests"
let examplesDir  = "examples"
let docDir       = "doc"

#___________________
# Build requirements
requires "nim >= 2.0.0"                           ## Latest stable version
requires "https://github.com/heysokam/nstd#head"  ## Nim stdlib extension
requires "vmath"                                  ## For vector math


#________________________________________
# Helpers
#___________________
let nimcr = &"nim c -r --outdir:{binDir}"
  ## Compile and run, outputting to binDir
proc runFile (file, dir :string) :void=  exec &"{nimcr} {dir/file}"
  ## Runs file from the given dir, using the nimcr command
proc runTest (file :string) :void=  file.runFile(testsDir)
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder
proc runExample (file :string) :void=  file.runFile(examplesDir)
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder

#_________________________________________________
# Tasks: Internal
#___________________
task push, "Internal: Pushes the git repository, and orders to create a new git tag for the package, using the latest version.":
  ## Does nothing when local and remote versions are the same.
  requires "https://github.com/beef331/graffiti.git"
  exec "git push"  # Requires local auth
  exec "graffiti ./{packageName}.nimble"


(declare-project
  :name "cells"
  :description "A cellular automaton"
  :dependencies ["https://github.com/janet-lang/argparse"])

(declare-executable
 :name "cells"
 :entry "main.janet")

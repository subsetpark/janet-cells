(import ca)
(import elementary)

(import argparse)

(def argparse-params
  ["A cellular automaton generator."
   "kind" {:kind :option
           :help "Kind of cellular automaton"
           :default "elem"}
   "state" {:kind :option
            :help "State type"
            :default "random"}
   "gens" {:kind :option
           :help "Number of generations to run"
           :default "100"}
   "rule" {:kind :option
           :help "Rule number"}
   "size" {:kind :option
           :help "State size"}])

(defn main [_filename & args]
    (let [args (argparse/argparse ;argparse-params)
          size (parse (args "size"))
          gens (parse (args "gens"))
          rule (parse (args "rule"))
          state (args "state")]
         (case (args "kind")
               "elem" (let [rules (elementary/make-rules rule)
                            state (elementary/make-state size state)]
                           (elementary/run state rules gens)))))

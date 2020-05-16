(defn make-system [number rules &opt halt]
   "Create a new tag system."
   (default halt "H")
   (let [ch-halt (halt 0)
         make-ch (fn [[k v]] [(k 0) v])
         args (pairs rules)
         ch-rules (struct (-> (map make-ch args) (flatten) (splice)))]
    {:number number
     :halt ch-halt
     :alphabet (-> ch-rules (keys) (array/push ch-halt))
     :rules ch-rules}))

(defn system-drop [buf {:number number}]
    "Drop the first `drop number` of a input."
    (buffer/slice buf number))

(defn system-produce [buf {:rules rules}]
    "Get the next component of a input."
    (-> buf (0) (rules)))

(defn step [buf sys]
    "Produce the next generation of an input."
    (let [production (system-produce buf sys)
          dropped (system-drop buf sys)]
        (buffer/push-string dropped production)))

(defn handle [in sys]
    "Given an input string, run it through a tag system until it satisfies a halting condition."
    (let [halt (sys :halt)
          number (sys :number)]
        (cond (or (< (length in) number) (= (in 0) halt)) in
              (-> in (step sys) (handle sys)))))

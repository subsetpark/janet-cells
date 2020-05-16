(import ca)

(def- *space-size* 3)
(def- *rule-bits* (math/exp2 *space-size*))
(def- *all-cases*
    (freeze (map
             |(ca/bin-digits $ *space-size*)
             (reverse (range 0 *rule-bits*)))))

(defn- mod-get [ds i] (ds (mod i (length ds))))

(defn- get-neighborhood [state i]
    (let [start (- i 1)
          end (+ i 1)
          neighborhood (if (or (< start 0) (>= end (length state)))
                        (map |(mod-get state $) [start i end])
                        (array/slice state start (+ end 1)))]
         (freeze neighborhood)))

(defn- advance
   "Update a state by one generation."
    [state rules]
    (let [frozen (freeze state)]
         (for i 0 (length state)
             (let [production (-> frozen (get-neighborhood i) (rules))]
                  (set (state i) production))))
    state)

(defn- print-state [state]
    (each cell state
          (case cell
                0 (prin " ")
                1 (prin "█")))
    (print ""))

(defn make-state
    "Construct a new mutable automaton state."
    [size &opt state-type]
    (default state-type "single")
    (let [state (array/new-filled size 0)
          rng (math/rng (os/time))]
         (case state-type
          "random" (for i 0 (length state)
                       (set (state i) (math/rng-int rng 2)))
          "single" (let [midpoint (-> state (length) (brshift 1))]
                        (set (state midpoint) 1)))
     state))

(defn make-rules
    "Construct rules based on a Wolfram number."
    [rule-number]
    (let [expansion (ca/bin-digits rule-number *rule-bits*)]
         (zipcoll *all-cases* expansion)))

(defn run [state rules duration]
    (for _ 0 duration
        (print-state state)
        (advance state rules)))

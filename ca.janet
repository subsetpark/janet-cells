(defn bin-digits [n bits]
    "Provide a tuple containing the binary expansion of `n`, padded to `bits` with 0s."
    (var n n)
    (let [digits (array/new-filled bits 0)]
         (for i 1 (+ 1 bits)
              (let [j (- bits i)]
                   (if (even? n)
                       (put digits j 0)
                       (put digits j 1))
                   (set n (brshift n 1))))
     (freeze digits)))

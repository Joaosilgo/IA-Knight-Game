
#|
-----------------------------------------------Algoritmos------------------------------------------------------------
|# 




(defun no-existep (no lista)
  (eval (cons 'or(mapcar #'(lambda(x) (and(equal (no-estado-tabuleiro no) (no-estado-tabuleiro x))(>= (no-profundidade no)(no-profundidade x))))lista))))





#|
  ________________BFS_________________
|# 


(defun abertos-bfs (abertos sucessores)
  "Devolve a lista de abertos do BFS"
  (append abertos sucessores))



;;Teste:(bfs (no-teste) 'no-solucaop 'sucessores (operadores))
(defun bfs (no funcao-objetivo sucessores operadores  &optional (abertos (list no)) (fechados nil))
   
  (cond 
   ((null abertos) nil)
   ((equal T (funcall funcao-objetivo no 'bfs)) (list no (+(length abertos)(length fechados)) (length fechados)  ) )
   ((equal (no-existep no fechados) T) (bfs (car abertos) funcao-objetivo sucessores operadores (abertos-bfs (cdr abertos) (funcall sucessores no operadores 'bfs nil)) fechados))
   (t (bfs (car abertos) funcao-objetivo sucessores operadores (abertos-bfs (cdr abertos) (funcall sucessores no operadores 'bfs nil)) (cons no fechados)))
   )
  )








#|
  ________________DFS_________________
|# 

(defun abertos-dfs (abertos sucessores)
"Devolve a lista de abertos do dfs"
  (append sucessores abertos))

;;(dfs (no-teste) 10)
(defun dfs (no profundidade &optional (abertos (list no)) (fechados nil))
   "Se profundidade do Nó chegar á profundidade fornecida, retorna-se o estado actual do nó independente do objetivo" 
  (cond 
   ((= (no-profundidade no) profundidade) (list no (+(length abertos)(length fechados)) (length fechados)  ))
   ((no-solucaop no 'dfs) (list no (+(length abertos)(length fechados)) (length fechados)  ))
   ((null abertos) nil)
   (t (dfs (car abertos) profundidade (abertos-dfs (cdr abertos)
                                               (apply #'append 
                                                      (mapcar  #'(lambda (suc) (if (or (null abertos) (no-existep suc fechados)) '() (list suc))) 
                                                               (sucessores (car abertos) (operadores) 'dfs 'h profundidade))))  (cons  (car abertos) fechados)))
   )
  )



;Teste(dfs-v2 (no-teste) 'no-solucaop 'sucessores (operadores) 33)
(defun dfs-v2 (no f-solucao f-sucessores ops prof)
  (let ((abertos (list no))
        (fechados '()))
    (labels ((algoritmo (a f)
               (let* ((cabeca (car a))
                      (sucessores (funcall f-sucessores cabeca ops 'dfs 'h prof))
                      (solucao (remove nil(mapcar #'(lambda(x) (cond ((funcall f-solucao x 'dfs) x )(T NIL)))sucessores))))
                 (cond ((not(null solucao))   solucao )
                       ((= (no-profundidade cabeca) prof)NIL)
                       (T (algoritmo (abertos-dfs (cdr a)(suce-existe(suce-existe sucessores a)f))(cons cabeca f)))))))
      (algoritmo abertos fechados))))

(defun suce-existe (suce lista)
  (let ((cabeca (car suce)))
  (cond ((null suce) nil)
        ((null (no-existep cabeca lista))(cons cabeca (suce-existe (cdr suce) lista)))
        (T (suce-existe (cdr suce) lista)))))









#|
  ________________A*_________________
|# 




(defun abertos-a-star (abertos sucessores)
"Devolve a lista de abertos ordenada"
  (quicksort (append sucessores abertos)))


(defun quicksort (no)
  "Algoritmo quicksort de ordenação usado para ordenar a lista de abertos no algoritmo A*"
  (cond 
   ((null no) nil)
   (t (let*((x     (car no))
            (resto (cdr no))
            (f     (lambda (a) (< (no-h a) (no-h x)))))
        (append (quicksort (remove-if-not f resto))
                (list x)
                (quicksort (remove-if f resto)))))))

(defun ordenar-nos (lista)
  "Ordena o so consoante o custo para ser usado na lista de abertos ordenada no algoritmo A* "
  (sort (copy-seq lista) #'< :key #'no-custo)
  )






;(A* (no-teste) 'h)
(defun A*(no heuristica &optional (abertos (list no)) (fechados nil))
  (cond 
   ((no-solucaop no 'a-star) (list no (+(length abertos)(length fechados)) (length fechados)  ))
   ((null abertos) nil)
   (t (A* (car abertos) heuristica (abertos-a-star (cdr abertos) 
                                                   (apply #'append 
                                                          (mapcar  #'(lambda (suc) (if (or (null abertos) (no-existep suc fechados)) '() (list suc))) 
                                                                   (sucessores (car abertos) (operadores) 'a-star heuristica )))) (cons  (car abertos) fechados)))
   )
  )




;(a-star_v2 (no-teste) 'no-solucaop 'sucessores (operadores) 'h)
(defun a-star_v2 (no funcao-objetivo sucessores operadores  heuristica &optional (abertos (list no)) (fechados nil))
 (cond    
   ((null abertos) nil)
   ((equal T (funcall funcao-objetivo no 'a-star)) (list no (+(length abertos)(length fechados)) (length fechados)  ))
   ((equal (no-existep no fechados) T)(a-star_v2 (car abertos) funcao-objetivo sucessores operadores   heuristica (cdr abertos) fechados))
   (t (a-star_v2 (car abertos) funcao-objetivo sucessores operadores heuristica  (abertos-a-star (cdr abertos) (funcall sucessores no operadores 'a-star heuristica )) (cons no fechados)))
   )
)









#|
  ________________SMA*_________________
|# 
;;(set-max-nos 4)
(let ((memoria))
"CLOSER para definir memoria"
(defun set-max-nos  (max)
  (setf memoria max)
)

(defun SMA-STAR (abertos sucessores)
" SMA* devolve a lista de abertos com os novos sucessores ordenados pelo custo exatamente como o A* "
"Remove o numero de nos do fim da lista que sejam igual ou superior á memoria definida"
  (let ((open (sort (append sucessores (cdr abertos)) #'< :key #'no-custo)))
    (cond
      ((>= (length open) memoria) (SMA-STAR-REMOVE open (- (length open) memoria))) 
      (T open)
    )
  )
)

(defun SMA-STAR-REMOVE (lista n &optional (tamanho (length lista)))
"Retorna a lista com os elemntos removidos no fim da lista"
  (cond
    ((null lista) nil)
    ((= n tamanho) nil)
    (T (cons (car lista) (SMA-STAR-REMOVE (cdr lista) n (1- tamanho))))
  )
)
)








;Teste:(set-max-nos 4) (SMA* (NO-TESTE) 'H)
(defun SMA*(no heuristica &optional (abertos (list no)) (fechados nil))
  (cond 
   ((no-solucaop no 'a-star) (list no (+(length abertos)(length fechados)) (length fechados)  ))
   ((null abertos) nil)
   (t (SMA* (car abertos) heuristica (SMA-STAR (cdr abertos) 
                                                   (apply #'append 
                                                          (mapcar  #'(lambda (suc) (if (or (null abertos) (no-existep suc fechados)) '() (list suc))) 
                                                                   (sucessores (car abertos) (operadores) 'a-star heuristica )))) (cons  (car abertos) fechados)))
   )
  )




#|
  ________________IDA* INCOMPLETE_________________
|# 



(defun IDA*(no heuristica &optional (abertos (list no)) (fechados nil))
  (cond 
   ((no-solucaop no 'a-star) (list no (+(length abertos)(length fechados)) (length fechados)  ))
   ((null abertos) nil)
   (t (IDA* (car abertos) heuristica (get-limiar-nodes (cdr abertos) 
                                                   (apply #'append 
                                                          (mapcar  #'(lambda (suc) (if (or (null abertos) (no-existep suc fechados)) '() (list suc))) 
                                                                 (get-new-limiar  (sucessores (car abertos) (operadores) 'a-star heuristica ))))) (cons  (car abertos) fechados)))
   )
  )


(defun get-lowest-f(abertos)
  "Retorna o no de uma lista com o valor f mais baixo"
  (cond
   ((= (length abertos) 1) (car abertos))
   (T (let ((node (get-lowest-f(cdr abertos))))
        (if (< (no-custo (car abertos)) (no-custo node))
            (car abertos) node)))  
   )
  )


;TESTE: (get-limiar-nodes  (list (no-teste)) (get-new-limiar (sucessores (no-teste) (operadores) 'a-star 'h) ))
(defun get-limiar-nodes(abertos limiar)
"Recebe uma lista e um dado limiar e retorna uma lista de nos cujo valor F seja <= a esse limiar"
"f'(n)<=L"
  (remove nil (mapcar #'(lambda(node) (if (<= (no-custo node) limiar) node NIL)) abertos)) 
)

(defun get-new-limiar(list)
"Retorna o valo f mais baixo de uma lista de nos"
  (no-custo (get-lowest-f list))
)




;Iteractive Deepening A* - IDA*:
;- A* com limiares definidos;
;- Primeiro limiar é f'(n0);
;- Só se exploram nós com f'(n)<=L;
;- Caso não haja solução, o limiar passa a ser o min(F(n)) em que F(n) são os nós visitados não expandidos;


















(defun print-list (elements)
  (progn
    (cond
     ((null elements) '()) ;; Base case: There are no elements that have yet to be printed. Don't do anything and return a null list.
     (t(format nil   "~%          ~a~%"(car elements))
       (print-list (cdr elements))))))




;;----------------------------------------------- PERFORMANCE e Medições -----------------------------------------------


(defun escrever-no (no &optional (g t))
"Permite escrever um no, por defeito no ecra."
  (format g "~A" no))

(defun solution-length (node)
  "Devolve o comprimento de uma  solucao"
  (length (car node)))

(defun number-generated-nodes(node)
  "Retorna o numero de nos gerados em procura"
  (second node))

(defun number-of-points(node)
"Retorna o numero de nos gerados em procura"
  (no-pontos(first node)))


(defun polinomial (B L valor-T)
  "B + B^2 + ... + B^L=T"
  (cond
   ((= 1 L) (- B valor-T))
   (T       (+ (expt B L) (polinomial B (- L 1) valor-T))))
  )

(defun branching-factor (list &optional (valor-L (solution-length list)) (valor-T (number-generated-nodes list)) (erro 0.1) (bmin 1) (bmax 10e11))
  "Devolve o factor de ramificacao, executando o metodo da bisseccao"
  (let ((bmedio (/ (+ bmin bmax) 2)))
    (cond 
     ((< (- bmax bmin) erro) (/ (+ bmax bmin) 2))
     ((< (polinomial bmedio valor-L valor-T) 0) (branching-factor list valor-L valor-T erro bmedio bmax))
     (t  (branching-factor list valor-L valor-T erro bmin bmedio)))))




(defun timings (function)
  (let ((real-base (get-internal-real-time))
        (run-base (get-internal-run-time)))
    (funcall function)
    (values (/ (- (get-internal-real-time) real-base) internal-time-units-per-second)
            (/ (- (get-internal-run-time) run-base) internal-time-units-per-second))))



(defmacro timing (&body forms)
  (let ((real1 (gensym))
        (real2 (gensym))
        (run1 (gensym))
        (run2 (gensym))
        (result (gensym)))
    `(let* ((,real1 (get-internal-real-time))
            (,run1 (get-internal-run-time))
            (,result (progn ,@forms))
            (,run2 (get-internal-run-time))
            (,real2 (get-internal-real-time)))
       (format *debug-io* "~%~%~%~%~%~%~%~%           Computation took:~%")
       (format *debug-io* "          ~f seconds of real time~%"
               (/ (- ,real2 ,real1) internal-time-units-per-second))
       (format t "          ~f seconds of run time~%"
               (/ (- ,run2 ,run1) internal-time-units-per-second))
       ,result)))













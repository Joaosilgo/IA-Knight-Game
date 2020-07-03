
;;;; Projeto Knights Game
;;;; Disciplina de IA - 2019 / 2020
;;;; Professor: Joaquim Filipe e Eng. Filipe Mariano 
;;;; Autor: João Gomes André Gastão




 

(defun tabuleiro-teste ()
"Tabuleiro de teste sem nenhuma jogada realizada"
(definir-objetivo 'F)
(definir-heuristica 'base)
  '(
    (94 25 54 89 21 08 36 14 41 96) 
    (78 47 56 23 05 49 13 12 26 60) 
    (00 27 17 83 34 93 74 52 45 80) 
    (69 09 77 95 55 39 91 73 57 30) 
    (24 15 22 86 01 11 68 79 76 72) 
    (81 48 32 02 64 16 50 37 29 71) 
    (99 51 06 18 53 28 07 63 10 88) 
    (59 42 46 85 90 75 87 43 20 31) 
    (03 61 58 44 65 82 19 04 35 62) 
    (33 70 84 40 66 38 92 67 98 97)
    )
)







#|
---------------------------------------------------------- SELETORES  ------------------------------------------------------------------
|# 


;;Teste:  (linha 0 (tabuleiro-teste))
;;Resultado: (94 25 54 89 21 8 36 14 41 96)
(defun linha (linha tabuleiro)
  "retorna a linha de um tabuleiro"
  (cond  
   ((eq (numberp linha) Nil)           Nil )
   ((null tabuleiro)                   Nil )
   ((< linha 0)                        Nil )
   ((> linha 9)                        Nil )        
   (t(nth linha tabuleiro))
   )
  )



;;Teste: (celula 0 1 (tabuleiro-teste))
;;Resultado: 25
(defun celula (linha coluna tabuleiro)
  "retorna a celula de um tabuleiro"
  (cond  
   ((eq (numberp linha ) Nil) Nil )
   ((eq (numberp coluna) Nil) Nil )
   ((null tabuleiro)          Nil )
   ((< coluna 0)              Nil )
   ((> coluna 9)              Nil )        
   (t (nth coluna (linha linha tabuleiro)))
   )
  )



;;teste: (substituir-posicao 0 (linha 0 (tabuleiro-teste)) T)
;;Resultado: (T 25 54 89 21 8 36 14 41 96)
(defun substituir-posicao (c linha &optional (valor NIL))
"Retorna um linha com o index substituido"
  (cond
   ((or(> c (- (length linha) 1)) (< c 0)) Nil)
   ((= c 0) (cons valor (cdr linha)))
   (t       (cons (car linha) (substituir-posicao (- c 1) (cdr linha) valor)))
   )
  )


;;Teste:(substituir 0 0 (tabuleiro-teste) T)
;((T 25 54 89 21 08 36 14 41 96) 
;(78 47 56 23 05 49 13 12 26 60) 
;(00 27 17 83 34 93 74 52 45 80) 
;(69 09 77 95 55 39 91 73 57 30) 
;(24 15 22 86 01 11 68 79 76 72) 
;(81 48 32 02 64 16 50 37 29 71) 
;(99 51 06 18 53 28 07 63 10 88) 
;(59 42 46 85 90 75 87 43 20 31) 
;(03 61 58 44 65 82 19 04 35 62) 
;(33 70 84 40 66 38 92 67 98 97))
(defun substituir ( l c tabuleiro &optional (valor NIL))
  "Retorna um linha com o index substituido"
  (cond
   ((or (eq l Nil)  (eq c Nil)) tabuleiro )
   ((= l 0)(cons (substituir-posicao c (linha l tabuleiro) valor) (cdr tabuleiro)))
   (t      (cons (car tabuleiro) (substituir (- l 1) c (cdr tabuleiro) valor )))
   )
  )



;;Teste: (posicao-cavalo (tabuleiro-teste))
;;Resultado: NIL
(defun posicao-cavalo (tabuleiro &optional (line 0) )
 "Retorna a posicção (x y) de onde se localiza o cavalo"
  (cond    
   ((null tabuleiro) Nil)
   ((equal (find T (car tabuleiro)) T) (list line (position T (car tabuleiro))))
   (t (posicao-cavalo (cdr tabuleiro) (+ line 1)) ))
  )


#|
---------------------------------------------------------- OPERADORES  ------------------------------------------------------------------
|# 

#|                                                          MOVIMENTOS
- (8 movimentos)
(x, y) => (l , c) => moves ( cima/baixo , direita/esquerda)
operador-1 (2  -1)
operador-2 (2   1)
operador-3 (1   2)
operador-4 (-1  2)
operador-5 (-2  1)
operador-6 (-2 -1)
operador-7 (-1 -2)
operador-8 (1  -2)
|# 



;;Teste: (operadores)
;;Resultado:(OPERADOR-1 OPERADOR-2 OPERADOR-3 OPERADOR-4 OPERADOR-5 OPERADOR-6 OPERADOR-7 OPERADOR-8)
(defun operadores ()
  "Cria uma lista com todos os operadores do Jogo do Cavalo (Knight´s Tour)."
  (list 'operador-1 
        'operador-2 
        'operador-3 
        'operador-4 
        'operador-5 
        'operador-6 
        'operador-7 
        'operador-8)
  )

;TODO´s:
;1 - Verificar se o movimento é válido;
;2 - Verificar se o cavalo está nalguma casa do tabuleiro, caso contrário deverá posicionar o cavalo numa casa da 1ª linha;
;3 - Após o movimento do cavalo, deverá aplicar a regra do número simétrico ou a regra do número duplo.



 #|OPERADOR-1|#
;;Teste: (operador-1 (tabuleiro-teste))
;;Resultado: NIL
(defun operador-1 (tabuleiro)
  "Operador-1 (+2 +1)"
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro) NIL) NIL)
   (T (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro))  
             (posicaoCavaloFinal (list (+(car(posicao-cavalo tabuleiro)) 2) (+(second(posicao-cavalo tabuleiro))1) ))
             (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
        (cond   
         ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                                 (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                                 (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                                 (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                                 (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 

                           (cond 
                            ((eq isDuplo T)
                             (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                      (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                  (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)T))

                            (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                            (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                        (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)T))))))))))



 #|OPERADOR-2|#
;;Teste: (operador-2 (tabuleiro-teste))
;;Resultado: NIL
(defun operador-2 (tabuleiro)
  "Operador-2 (+1 +2)"
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro) NIL) NIL)
   (T (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro))  
             (posicaoCavaloFinal (list (+(car(posicao-cavalo tabuleiro)) 1) (+(second(posicao-cavalo tabuleiro))2) ))
             (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))      
        (cond   
         ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                                 (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                                 (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                                 (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                                 (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 

                           (cond 
                            ((eq isDuplo T)
                             (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                      (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                  (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)T))

                            (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                            (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                        (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)T))))))))))


 
 #|OPERADOR-3|#
;;Teste: (operador-3 (tabuleiro-teste))
;;Resultado: NIL
(defun operador-3 (tabuleiro)
  "operador-3 (1   2)"
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro))  
           (posicaoCavaloFinal (list (-(car(posicao-cavalo tabuleiro)) 1) (+(second(posicao-cavalo tabuleiro))2) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 
         
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)T))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)T))))))))))



 #|OPERADOR-4|#
;;Teste: (operador-4 (tabuleiro-teste))
;;Resultado: NIL
(defun operador-4 (tabuleiro)
  "operador-4 (-1  2)"
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro))  
           (posicaoCavaloFinal (list (-(car(posicao-cavalo tabuleiro)) 2) (+(second(posicao-cavalo tabuleiro))1) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 
         
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)T))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)T))))))))))



 #|OPERADOR-5|#
;;Teste: (operador-5 (tabuleiro-teste))
;;Resultado: NIL
(defun operador-5 (tabuleiro)
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro))  
           (posicaoCavaloFinal (list (-(car(posicao-cavalo tabuleiro)) 2) (-(second(posicao-cavalo tabuleiro))1) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)T))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)T))))))))))



 #|OPERADOR-6|#
;;Teste: (operador-6 (tabuleiro-teste))
;;Resultado: NIL
(defun operador-6 (tabuleiro)
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro))  
           (posicaoCavaloFinal (list (-(car(posicao-cavalo tabuleiro)) 1) (-(second(posicao-cavalo tabuleiro))2) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 
         
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)T))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)T))))))))))



 #|OPERADOR-7|#
;;Teste: (operador-7 (tabuleiro-teste))
;;Resultado: NIL
(defun operador-7 (tabuleiro)
  "Se for Nil não á cavalo no tabuleiro" 
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro)) 
           (posicaoCavaloFinal (list (+(car(posicao-cavalo tabuleiro)) 1) (-(second(posicao-cavalo tabuleiro))2) )) 
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 

                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)T))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)T))))))))))



 #|OPERADOR-8|#
;;Teste: (operador-8 (tabuleiro-teste))
;;Resultado: NIL
(defun operador-8 (tabuleiro)
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro))  
           (posicaoCavaloFinal (list (+(car(posicao-cavalo tabuleiro)) 2) (-(second(posicao-cavalo tabuleiro))1) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 

         
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)T))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)T))))))))))






 #|OPERADOR-CAVALO|#
;;Teste: (operador-inicial-cavalo (tabuleiro-teste) 0)
;;Resultado: 
;((T 25 54 89 21 08 36 14 41 96) 
;(78 47 56 23 05 49 13 12 26 60) 
;(00 27 17 83 34 93 74 52 45 80) 
;(69 09 77 95 55 39 91 73 57 30) 
;(24 15 22 86 01 11 68 79 76 72) 
;(81 48 32 02 64 16 50 37 29 71) 
;(99 51 06 18 53 28 07 63 10 88) 
;(59 42 46 85 90 75 87 43 20 31) 
;(03 61 58 44 65 82 19 04 35 62) 
;(33 70 84 40 66 38 92 67 98 97))
(defun operador-inicial-cavalo (tabuleiro indice)
  "Operador para colocar o cavalo em Jogo que recebe um tabuleiro e uma coluna, valida a posicao do cavalo e impõe as regras"
  (let* (  (posicao-cavalo (list 0 indice ))
           (isvalido       (validar-movimento (first posicao-cavalo)(second posicao-cavalo) tabuleiro))
           (isNil          (celula (first posicao-cavalo)(second posicao-cavalo) tabuleiro)))
       
    (cond   
     (   (And (eq isvalido Nil)    (eq isNil Nil ))Nil)  
     (T  (let* ((simetrico         (regra-simetrico (celula (first posicao-cavalo)(second posicao-cavalo) tabuleiro) ))
                (posicao-simetrico (posicao-valor tabuleiro simetrico ))
                (isDuplo           (regra-duplo     (celula (first posicao-cavalo)(second posicao-cavalo) tabuleiro) ))
                (maxDuplo          (Duplo-Maximo    (Duplos-Disponiveis  tabuleiro ))) 
                (posicao-duplo     (posicao-valor tabuleiro maxDuplo ))) 
           (cond 
            ((equal isDuplo T)

             (substituir  (first posicao-cavalo ) (second posicao-cavalo )                          
                          (substituir (first posicao-duplo) (second posicao-duplo)
                                      (substituir (first posicao-simetrico) (second posicao-simetrico) tabuleiro NIL)NIL)T))


            (T (substituir  (first posicao-cavalo ) (second posicao-cavalo )                                                                                  
                            (substituir (first posicao-simetrico) (second posicao-simetrico) tabuleiro NIL)T))))))))
            
         
    


(defun nova-sucessao-cavalo (no valor-casa)
"função que realiza que cria um no-inicial   "
  (cria-no 
   (operador-inicial-cavalo (no-estado-tabuleiro no) (second( posicao-valor (no-estado-tabuleiro no) valor-casa)) )
   (posicao-valor (no-estado-tabuleiro no) valor-casa)
   (+ (no-pontos no) valor-casa   )
   0
   no
   (no-H no)
   )
)

;(sucessao-cavalo no (casas-primeira-fila (linha 0 (tabuleiro-teste))))
(defun sucessao-cavalo (no  lista-casas-disponiveis)
"Cria o conjunto de Sucessões iniciais no tabuleiro sem cavalo"
  (cond 
   ((null lista-casas-disponiveis) nil ) 
   (t (cons (nova-sucessao-cavalo no (first lista-casas-disponiveis )) (sucessao-cavalo no (cdr lista-casas-disponiveis)))))
)



#|
---------------------------------------------------------- VALIDAÇÕES E REGRAS  ------------------------------------------------------------------
|# 



;;Teste: (validar-movimento 0 10 (tabuleiro-teste))
;;Resultado: NIL
(defun validar-movimento(l c tabuleiro)
  "Função para validar o movimento que retorna T ou NIL caso possa ou não se movimentar"
  (cond 
   ( (eq l Nil)                         Nil)
   ( (eq c Nil)                         Nil)
   ( (null tabuleiro)                   Nil)
   ( (or (> l 9) (< l 0))               Nil)
   ( (or (> c 9) (< c 0))               Nil)
   ( (equal (celula l c tabuleiro) Nil) Nil)
   (t T)
   )
  )



;;Teste: (regra-simetrico 98)
;;Resultado: 89
(defun regra-simetrico (numero)
  "Retorna o numero simetrico do argumento recebido"
  (cond
   (  (eq (numberp numero) Nil) Nil )
   (T (+ (*(mod numero 10 ) 10)(multiple-value-bind (q) (floor numero 10) q) )))
  )


  
;;Teste: (regra-duplo 99)
;;Resultado: T
(defun regra-duplo (numero)
  "Retorna T se for simetrico senão NIL"
  (cond
   ( (not (numberp numero) ) Nil )
   ( (= numero 0) Nil)
   ( (And (= (multiple-value-bind (q) (floor numero 10) q)  (mod numero 10 ) ) (numberp numero)) T)
   (T Nil)
   )
  )



;;Teste: (Duplo-Maximo (Duplos-Disponiveis ( tabuleiro-teste )))
;;Resultado: 99
(defun Duplo-Maximo (lista) 
  (maximum lista))



;;Teste: (Duplos-Disponiveis ( tabuleiro-teste ))
;;Resultado: (99 88 77 66 55 44 33 22 11)
(defun Duplos-Disponiveis ( tabuleiro )
  "Retorna a lista de Duplos Disponiveis Ordenada"
  (sort (duplos(alisa tabuleiro))  #'>))



;;Teste: (duplos(alisa ( tabuleiro-teste ))) 
;;Resultado: (77 55 22 11 99 88 44 33 66)
(defun duplos (tabuleiro)
  "recebe uma lista e retorna outra lista com numeros Duplos disponiveis desorganizados "
  (cond 
   ((null tabuleiro) '())
   ((equal (regra-duplo (car tabuleiro))  T) (cons (car tabuleiro) (duplos (cdr tabuleiro)  )))
   (T (duplos (cdr tabuleiro) )))
  )



;; Teste ( posicao-valor ( tabuleiro-Teste) 99  )
;;Resultado: (6 0)
(defun posicao-valor ( tabuleiro valor &optional (line 0) )
""
  (cond 
   ((eq (numberp valor) Nil) Nil )
   ((eq valor Nil) Nil)
   ((null tabuleiro) NIL)
   ((equal (find valor (car tabuleiro)) valor ) (list line (position valor (car tabuleiro))))
   (t (posicao-valor   (cdr tabuleiro) valor (+ line 1) ) ))
  )



;;Teste: (numero-jogadas-disponiveis (sucessores (no-teste) (operadores) 'bfs 'Nil) )
;;Resultado:10
(defun numero-jogadas-disponiveis(sucessao) 
  "Conta o numéro de jogadas a partir do nº de sucessões que existe"
  (cond
   ((null sucessao) 0)
   ((equal sucessao  Nil ) 0 )
   ((equal (car sucessao)  Nil ) 0 )
   (t  ( + 1 ( numero-jogadas-disponiveis (cdr sucessao) )))
   )
  )


;;Teste: (casas-primeira-fila (linha 0 (tabuleiro-teste)))
;;Resultado:(94 25 54 89 21 8 36 14 41 96)
(defun casas-primeira-fila(linha)
  "Devolve uma lista de casas disponiveis na primeira fila"
  (cond
   ((null linha)  Nil)
   ((equal linha  Nil)  Nil )
   ((equal linha  T  )  Nil )
   ((equal (car linha)  Nil ) (casas-primeira-fila (cdr linha)))
   (t      (cons  (car linha) (casas-primeira-fila (cdr linha))))
   )
  )



#|
---------------------------------------------------------- FUNÇÕES AUXILIARES  ------------------------------------------------------------------
|# 

;;TESTE:
(defun maximum (list)
  (cond
   ((null list) NIL)
   ((equal list  Nil ) NIL )    
   (t   (reduce #'max list)))
  )

;TESTE: (junta '(NIL 25 54 89 21 8 36 14 41 96) '(78 47 56 23 5 NIL 13 12 26 60) )
(defun junta (lista1 lista2)
  (cond 
   ((= (length lista1)0) lista2)
   (T(cons (car lista1) (junta (cdr lista1)lista2))))
  )

(defun alisa (lista)
  (cond 
   ((= (length lista)0) nil)
   ((listp (car lista)) (junta(alisa(car lista))(alisa(cdr lista))))
   (T (cons (car lista)(alisa (cdr lista))))
   )
  )



#|
----------------------------------------------------REPRESENTAÇÃO DE ESTADOS-------------------------------------------------------
|# 



;Teste: (pprint(no-teste))
;Resultado:
;(((94 25 54 89 210 8 36 14 41 96)
;  (78 47 56 23 05 49 13 12 26 60)
;  (00 27 17 83 34 93 74 52 45 80)
;  (69 09 77 95 55 39 91 73 57 30)
;  (24 15 22 86 01 11 68 79 76 72)
;  (81 48 32 02 64 16 50 37 29 71)
;  (99 51 06 18 53 28 07 63 10 88)
;  (59 42 46 85 90 75 87 43 20 31)
;  (03 61 58 44 65 82 19 04 35 62)
;  (33 70 84 40 66 38 92 67 98 97))
; (0 0)
; 0
; 0
; NIL
; 40.40404)
(defun no-teste ()
"Define um no teste do problema do cavalo em que linha=0, posicao=0, profundidade=0 e pai=NIL"
 (list (tabuleiro-teste) '(0 0) 0 0 nil (float (/ (objetivo) (m1 (tabuleiro-teste)))))
)


;;Teste: (pprint(cria-no (tabuleiro-teste) '(0 0) 0 0 nil (float (/ (objetivo) (m1 (tabuleiro-teste))))))
;Resultado:
;(((94 25 54 89 210 8 36 14 41 96)
;  (78 47 56 23 05 49 13 12 26 60)
;  (00 27 17 83 34 93 74 52 45 80)
;  (69 09 77 95 55 39 91 73 57 30)
;  (24 15 22 86 01 11 68 79 76 72)
;  (81 48 32 02 64 16 50 37 29 71)
;  (99 51 06 18 53 28 07 63 10 88)
;  (59 42 46 85 90 75 87 43 20 31)
;  (03 61 58 44 65 82 19 04 35 62)
;  (33 70 84 40 66 38 92 67 98 97))
; (0 0)
; 0
; 0
; NIL
; 40.40404)
(defun cria-no (tabuleiro  posicao pontos profundidade pai &optional (h 0))                           
  "Cria um nó : (Tabuleiro|Posição|Pontos|Profundidade|Pai|Heuristica)"
  (list tabuleiro posicao pontos profundidade pai h))



;;Teste: (no-estado-tabuleiro(no-teste))
;Resultado:
;(((94 25 54 89 210 8 36 14 41 96)
;  (78 47 56 23 05 49 13 12 26 60)
;  (00 27 17 83 34 93 74 52 45 80)
;  (69 09 77 95 55 39 91 73 57 30)
;  (24 15 22 86 01 11 68 79 76 72)
;  (81 48 32 02 64 16 50 37 29 71)
;  (99 51 06 18 53 28 07 63 10 88)
;  (59 42 46 85 90 75 87 43 20 31)
;  (03 61 58 44 65 82 19 04 35 62)
;  (33 70 84 40 66 38 92 67 98 97))
(defun no-estado-tabuleiro (no)
  (first no))



;;Teste: (no-Posicao(no-teste))
;Resultado: (0 0)
(defun no-Posicao (no)
  (second no))



;;Teste: (no-pontos(no-teste))
;Resultado: 0
(defun no-pontos (no)
  (third no))



;;Teste: (no-profundidade(no-teste))
;Resultado: 0
(defun no-profundidade (no)
  (fourth no))



;;Teste: (no-pai(no-teste))
;Resultado: NIL
(defun no-pai (no)
  (fifth no))



;;Teste: (no-H(no-teste))
;Resultado: 40.40404
(defun no-H (no)
  (sixth no))



;;Teste: (no-custo(no-teste))
;Resultado: 40.40404
(defun no-custo (no)
  "f(n)=g(n)+h(n) "
  (+(no-profundidade no)(no-H no)))


;(defun no-custo (no)
; (+ (+ 100 (no-pontos no) ) (no-H no)))



   
;; teste: (novo-sucessor (no-teste) 'operador-1)
(defun novo-sucessor (no op &optional (heuristica 0))
  " Cria um novo sucessor a partir do no que recebe e a operação"     
  (let ((estado (funcall op (no-estado-tabuleiro no))))
    (cond 
     ((null estado)nil)
     ((eq (posicao-cavalo (no-estado-tabuleiro no)) Nil)      (nova-sucessao-cavalo no (casas-primeira-fila (linha 0 (no-estado-tabuleiro no))))) 
     (T(cond   ((equal op 'operador-1) 
                (cria-no (operador-1 (no-estado-tabuleiro no))(posicao-cavalo (no-estado-tabuleiro no)) (incrementar-valor no 'operador-1)(+ (no-profundidade no) 1) no heuristica))
               ((equal op 'operador-2) 
                (cria-no (operador-2 (no-estado-tabuleiro no))(posicao-cavalo (no-estado-tabuleiro no)) (incrementar-valor no 'operador-2)(+ (no-profundidade no) 1) no heuristica))
               ((equal op 'operador-3) 
                (cria-no (operador-3 (no-estado-tabuleiro no))(posicao-cavalo (no-estado-tabuleiro no)) (incrementar-valor no 'operador-3)(+ (no-profundidade no) 1) no heuristica))
               ((equal op 'operador-4) 
                (cria-no (operador-4 (no-estado-tabuleiro no))(posicao-cavalo (no-estado-tabuleiro no)) (incrementar-valor no 'operador-4)(+ (no-profundidade no) 1) no heuristica))
               ((equal op 'operador-5) 
                (cria-no (operador-5 (no-estado-tabuleiro no))(posicao-cavalo (no-estado-tabuleiro no)) (incrementar-valor no 'operador-5)(+ (no-profundidade no) 1) no heuristica))
               ((equal op 'operador-6) 
                (cria-no (operador-6 (no-estado-tabuleiro no))(posicao-cavalo (no-estado-tabuleiro no)) (incrementar-valor no 'operador-6)(+ (no-profundidade no) 1) no heuristica))
               ((equal op 'operador-7) 
                (cria-no (operador-7 (no-estado-tabuleiro no))(posicao-cavalo (no-estado-tabuleiro no)) (incrementar-valor no 'operador-7)(+ (no-profundidade no) 1) no heuristica))
               ((equal op 'operador-8) 
                (cria-no (operador-8 (no-estado-tabuleiro no))(posicao-cavalo (no-estado-tabuleiro no)) (incrementar-valor no 'operador-8)(+ (no-profundidade no) 1) no heuristica))
               (t Nil))
       ))))

(defun incrementar-valor(no op)
  "Incrementa os pontos  do no a partir do valor da casa consoante a operação fornecida"
  (cond   ((equal op 'operador-1)  (+ (celula (+(first  (posicao-cavalo (no-estado-tabuleiro no)))2) 
                                              (+(second (posicao-cavalo (no-estado-tabuleiro no)))1) (no-estado-tabuleiro no))  
                                      (no-pontos no))) 
          ((equal op 'operador-2)  (+ (celula (+(first  (posicao-cavalo (no-estado-tabuleiro no)))1) 
                                              (+(second (posicao-cavalo (no-estado-tabuleiro no)))2) (no-estado-tabuleiro no)) 
                                      (no-pontos no))) 
          ((equal op 'operador-3)  (+ (celula (-(first  (posicao-cavalo (no-estado-tabuleiro no)))1) 
                                              (+(second (posicao-cavalo (no-estado-tabuleiro no)))2) (no-estado-tabuleiro no)) 
                                      (no-pontos no))) 
          ((equal op 'operador-4)  (+ (celula (-(first  (posicao-cavalo (no-estado-tabuleiro no)))2) 
                                              (+(second (posicao-cavalo (no-estado-tabuleiro no)))1) (no-estado-tabuleiro no)) 
                                      (no-pontos no))) 
          ((equal op 'operador-5)  (+ (celula (-(first  (posicao-cavalo (no-estado-tabuleiro no)))2) 
                                              (-(second (posicao-cavalo (no-estado-tabuleiro no)))1) (no-estado-tabuleiro no)) 
                                      (no-pontos no))) 
          ((equal op 'operador-6)  (+ (celula (-(first  (posicao-cavalo (no-estado-tabuleiro no)))1) 
                                              (-(second (posicao-cavalo (no-estado-tabuleiro no)))2) (no-estado-tabuleiro no)) 
                                      (no-pontos no))) 
          ((equal op 'operador-7)  (+ (celula (+(first  (posicao-cavalo (no-estado-tabuleiro no)))1) 
                                              (-(second (posicao-cavalo (no-estado-tabuleiro no)))2) (no-estado-tabuleiro no)) 
                                      (no-pontos no))) 
          ((equal op 'operador-8)  (+ (celula (+(first  (posicao-cavalo (no-estado-tabuleiro no)))2) 
                                              (-(second (posicao-cavalo (no-estado-tabuleiro no)))1) (no-estado-tabuleiro no)) 
                                      (no-pontos no)))
          (t Nil))
  )




;;Teste;  (sucessores (no-teste) (operadores) 'bfs 'no-heuristica)"
(defun sucessores (no ops algoritmo f-heuristica &optional (prof nil))
  (cond 
    ((eq (posicao-cavalo (no-estado-tabuleiro no)) Nil) (sucessao-cavalo no (casas-primeira-fila (linha 0 (no-estado-tabuleiro no)))))
   ((not(eq (no-estado-tabuleiro no) nil )) 
    (cond ((equal algoritmo 'dfs    )  (remove nil(mapcar #'(lambda(op) (novo-sucessor no op )) ops)) )
          ((equal algoritmo 'bfs    )  (remove nil(mapcar #'(lambda(op) (novo-sucessor no op )) ops)) )
          ((equal algoritmo 'a-star )  (remove nil(mapcar #'(lambda(op) (novo-sucessor no op (funcall f-heuristica no ) )) ops)))
          ((equal algoritmo 'ida    )  (remove nil(mapcar #'(lambda(op) (novo-sucessor no op (funcall f-heuristica no ) )) ops)))
          (T Nil)))

   (t Nil)))



#|
----------------------------------------------------HEURISTICA-------------------------------------------------------
|# 



#|
HEURISTICA BASE
|# 
;h(x) = o(x)/m(x)

;m(x) é a média por casa dos pontos que constam no tabuleiro x
;o(x) é o número de pontos que faltam para atingir o valor definido como objetivo.



;;Teste: (definir-heuristica 'base)
;Resultado: 'BASE
(LET ((heuristica))
  (defun definir-heuristica(x) (setf heuristica-def x))
  (defun heuristica-usada()
    (cond
     ((equal heuristica-def  'base ) 'h   )
     ((equal heuristica-def  'implementada ) 'h1   )
     (t  nil)
     )))



;Teste : (sum-Points-Tabuleiro (alisa (tabuleiro-teste)))
;Resultado: 4950
(defun sum-Points-Tabuleiro ( tabuleiro )
  "Soma o Total de Pontos que eexiste no momento no tabuleiro"
  (cond 
   ((null tabuleiro) 0)
   ((or (equal (car tabuleiro) Nil) (equal (car tabuleiro) T) ) (sum-Points-Tabuleiro (cdr tabuleiro)) )
   (t (+(car tabuleiro) (sum-Points-Tabuleiro (cdr tabuleiro)))))
  )



;Teste : (sum-CasasDisponiveis-Tabuleiro (alisa (tabuleiro-teste)))
;Resultado: 100
(defun sum-CasasDisponiveis-Tabuleiro ( tabuleiro )
  "Soma o total de casas disponiveis no tauleiro"
  (cond 
   ((null tabuleiro) 0)
   ( (or (equal (car tabuleiro) Nil) (equal (car tabuleiro) T)) (sum-CasasDisponiveis-Tabuleiro (cdr tabuleiro)) )
   (t ( + 1  (sum-CasasDisponiveis-Tabuleiro (cdr tabuleiro)))))
  )



;Teste : (m (tabuleiro-teste))
;Resultado: 49.5
(defun m (tabuleiro)
  (cond
   ((or (=(sum-CasasDisponiveis-Tabuleiro (alisa tabuleiro)) 0) (=(sum-Points-Tabuleiro (alisa tabuleiro)) 0) ) 0)
   (t (float (/(sum-Points-Tabuleiro (alisa tabuleiro))  (sum-CasasDisponiveis-Tabuleiro (alisa tabuleiro))))))
  )



;Teste : (o (no-teste) )
;Resultado: 2000
(defun o(no)
  (- (objetivo) (no-pontos no )))



;Teste : (h (no-teste) )
;Resultado: 40.40404
(defun h (no)
  (cond 
   ((or (=(o no)0) (=(m (no-estado-tabuleiro no))0) ) 0)
   (t (float (/ (o  no) (m (no-estado-tabuleiro no) )))))
  )


#|
HEURISTICA IMPLEMENTADA
|# 



;Teste : (sum-CasasDisponiveis-Tabuleiro-not-duplos (alisa (tabuleiro-teste)))
;Resultado: 91
(defun sum-CasasDisponiveis-Tabuleiro-not-duplos ( tabuleiro )
  (cond 
   ((null tabuleiro) 0)
   ( (or (equal (car tabuleiro) Nil) (equal (car tabuleiro) T)  (equal (regra-duplo(car tabuleiro)) T)) (sum-CasasDisponiveis-Tabuleiro-not-duplos (cdr tabuleiro)) )
   (t ( + 1  (sum-CasasDisponiveis-Tabuleiro-not-duplos (cdr tabuleiro)))))
  )



;Teste : (sum-Points-Tabuleiro-not-duplos (alisa (tabuleiro-teste)))
;Resultado: 4455
(defun sum-Points-Tabuleiro-not-duplos ( tabuleiro )
  (cond 
   ((null tabuleiro) 0)
   ((or (equal (car tabuleiro) Nil) (equal (car tabuleiro) T) (equal (regra-duplo(car tabuleiro)) T )) (sum-Points-Tabuleiro-not-duplos (cdr tabuleiro)) )
   (t (+(car tabuleiro) (sum-Points-Tabuleiro-not-duplos (cdr tabuleiro)))))
  )



;Teste : (m1 (tabuleiro-teste))
;Resultado: 44.55
(defun m1 (tabuleiro)
  (cond
   ((or (=(sum-CasasDisponiveis-Tabuleiro (alisa tabuleiro)) 0) (=(sum-Points-Tabuleiro-not-duplos (alisa tabuleiro)) 0) ) 0)
   (t (float (/(sum-Points-Tabuleiro-not-duplos (alisa tabuleiro))  (sum-CasasDisponiveis-Tabuleiro(alisa tabuleiro))))))
  )



;Teste : (h1 (no-teste))
;Resultado: 44.89338
(defun h1 (no)
  (cond 
   ((or (=(o no)0) (=(m1 (no-estado-tabuleiro no))0) ) 0)
   (t (float (/ (o  no) (m1 (no-estado-tabuleiro no) )))))
  )





(defun h2 (no) 
( maximum (remove t (alisa (no-estado-tabuleiro no)) ))
)











#|
----------------------------------------------------Solução-------------------------------------------------------
|# 




;Teste : (definir-objetivo 'F )
;Resultado: F
;Teste : (objetivo)
;Resultado: 2000
(LET ((problema))
  (defun definir-objetivo(x) (setf problema x))
  (defun objetivo()
    (cond
     ((equal problema  'A ) 70   )
     ((equal problema  'B ) 60   )
     ((equal problema  'C ) 270  )
     ((equal problema  'D ) 600  )
     ((equal problema  'E ) 300  )
     ((equal problema  'F ) 2000 )
     (t  nil)
     )))



;Teste : (definir-objetivo 'F ) (no-solucaop (no-teste) 'bfs)
;Resultado: NIL
(defun no-solucaop (no alg)
  "Retorna T/NIL consoante se chegamos ao objetivo ou não houver mais movimentos"
  (let* ((moves (numero-jogadas-disponiveis (sucessores no (operadores) alg (heuristica-usada))))
         (pts   (no-pontos no )))

    (OR (= moves 0) (>= pts (objetivo))))
  )
  


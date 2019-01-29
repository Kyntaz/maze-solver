% Pedro Miguel Guerreiro Quintas, 83546
% Maria Marques da Silva Aveiro, 83937
% Grupo 54

% <Labirintos>

% Representacoes:
% Um labirinto e uma lista de listas de celulas (matriz de celulas).
% Cada celula e uma lista de paredes que representa as paredes que separam essa celula.
% Uma parede pode ser c (cima), b (baixo), e (esquerda), d (direita).
% Um movimento e do tipo (dir, x, y), em que x e y sao coordenadas e dir e uma direcao (c,b,d,e) ou
% i, no caso de esta ser a posicao inicial do labirinto.
% Ao longo do projeto a notacao (X,Y) e usada para posicoes em que X e a linha e Y e a coluna.

% Prototipos dos predicados:
% movs_possiveis/4
% distancia/3
% ordena_poss/4
% resolve1/4
% resolve2/4
% movs_potenciais/3
% dirs_potenciais/3
% paredes/3
% seleciona/3
% remove_direcoes/3
% remove_elemento/3
% inverte/2
% movs_de_pos/3
% movimento_de_pos/3
% remove_visitados/3
% remove_visitado/3
% melhor_mov/4
% particiona/3
% junta_ord/5
% membro/2

% Definicao dos predicados:


% movs_possiveis(Lab, Pos_atual, Movs, Poss) afirma que Poss e uma lista de movimentos possiveis e nao
% existentes na lista de movimentos Movs, dado um labirinto Lab e uma posicao Pos.
movs_possiveis(Lab, (X0,Y0), Movs, Poss) :-
	movs_potenciais(Lab, (X0,Y0), Pot),
	remove_visitados(Pot, Movs, Poss).

% movs_potenciais(Lab, Pos, Pot) afirma que Pot e a lista de todos os movimentos fisicamente
% possiveis de se fazer partindo de Pos, considerando o labirinto Lab.
movs_potenciais(Lab, (X0,Y0), Pot) :-
	dirs_potenciais(Lab, (X0,Y0), Dirs),
	movs_de_pos((X0,Y0), Dirs, Pot).

% dirs_potenciais(Lab, Pos, Dirs) afirma que e possivel avancar em qualquer uma das direcoes de Dirs
% partindo da posicao Pos, considerando o labirinto Lab.
dirs_potenciais(Lab, (X0,Y0), Dirs) :-
	paredes(Lab, (X0,Y0), P),
	remove_direcoes([c,b,e,d], P, Dirs).

% paredes(Lab, Pos, Pars) afirma que Pars e a lista de paredes na posicao Pos do labirinto Lab.
paredes(Lab, (X,Y), Pars) :-
	seleciona(Lab, X, L),
	seleciona(L, Y, Pars).

% seleciona(List, N, El) afirma que El e o eNesimo elemento de List.
seleciona([El|_], 1, El).
seleciona([_|R], N, El) :-
	N1 is N-1,
	seleciona(R, N1, El).
	
% remove_direcoes(Dirs, Pars, Poss) afirma que Poss e a lista de direcoes que resulta de remover
% Pars a Dirs.
remove_direcoes(Dirs, [], Dirs).
remove_direcoes(Dirs, [Par|R], Poss) :-
	remove_elemento(Dirs, Par, Dirs1),
	remove_direcoes(Dirs1, R, Poss).

% remove_elemento(List, El, Rem) afirma que Rem e List retirando El.
remove_elemento(List, El, Rem) :- remove_elemento(List, El, Rem, []).
remove_elemento([], _, Rem, Ac) :- inverte(Ac, Rem).
remove_elemento([El|R], El, Rem, Ac) :-
	remove_elemento(R, El, Rem, Ac).
remove_elemento([C|R], El, Rem, Ac) :-
	\+(C = El),
	remove_elemento(R, El, Rem, [C|Ac]).
	
%inverte(L, I) afirma que I e L invertida.
inverte(L, I) :- inverte(L, I, []).
inverte([], I, I).
inverte([C|R], I, Ac) :- inverte(R, I, [C|Ac]).

% movs_de_pos(Pos, Dirs, Movs) afirma que Movs e a lista de movimentos partindo de Pos, segundo as
% direcoes Dirs.
movs_de_pos(Pos, Dirs, Movs) :- movs_de_pos(Pos, Dirs, Movs, []).
movs_de_pos(_, [], Movs, Ac) :- inverte(Ac, Movs).
movs_de_pos(Pos, [Dir|R], Movs, Ac) :-
	movimento_de_pos(Pos, Dir, M),
	movs_de_pos(Pos, R, Movs, [M|Ac]).

% movimento_de_pos(Pos, Dir, Mov) afirma que Mov e o movimento que parte de Pos na direcao Dir.
movimento_de_pos((X0,Y0), e, (e,X0,Y1)) :- Y1 is Y0-1.
movimento_de_pos((X0,Y0), d, (d,X0,Y1)) :- Y1 is Y0+1.
movimento_de_pos((X0,Y0), c, (c,X1,Y0)) :- X1 is X0-1.
movimento_de_pos((X0,Y0), b, (b,X1,Y0)) :- X1 is X0+1.

% remove_visitados(Movs, Vis, Rem) afirma que Rem e a lista resultante de remover os movimentos
% em Vis de Movs.
remove_visitados(Movs, [], Movs).
remove_visitados(Movs, [V|R], Rem) :-
	remove_visitado(Movs, V, Movs1),
	remove_visitados(Movs1, R, Rem).

% remove_visitado(Movs, V, Rem) afirma que Rem e Movs sem movimentos que resultem na posicao de V.
remove_visitado(Movs, V, Rem) :- remove_visitado(Movs, V, Rem, []).
remove_visitado([], _, Rem, Ac) :- inverte(Ac, Rem).
remove_visitado([(_,X,Y)|R], (D,X,Y), Rem, Ac) :-
	remove_visitado(R, (D,X,Y), Rem, Ac).
remove_visitado([(D0,X0,Y0)|R], (D1,X1,Y1), Rem, Ac) :-
	\+((X0,Y0) = (X1,Y1)),
	remove_visitado(R, (D1,X1,Y1), Rem, [(D0,X0,Y0)|Ac]).

% distancia(Pos1, Pos2, D) afirma que D e a distancia entre Pos1 e Pos2.
distancia((X0,Y0),(X1,Y1), D) :- D is abs(X0-X1) + abs(Y0-Y1).

% melhor_mov(M, P, I, F) afirma que M e o melhor movimento para ir da posicao I para a F.
melhor_mov((_, X0, Y0), (_, X1, Y1), _, F) :- 
	distancia((X0,Y0), F, D0),
	distancia((X1,Y1), F, D1),
	D0 < D1.
melhor_mov((_, X0, Y0), (_, X1, Y1), I, F) :- 
	distancia((X0,Y0), F, D0),
	distancia((X1,Y1), F, D1),
	D0 =:= D1,
	distancia((X0,Y0), I, D2),
	distancia((X1,Y1), I, D3),
	D2 >= D3.

% particiona(List, M1, M2) afirma que M1 e M2 sao 2 metades de List.
particiona(List, M1, M2) :-
	length(List, L),
	C is L // 2,
	particiona(List, M1, M2, C, []).
particiona(M2, M1, M2, 0, Ac) :- inverte(Ac, M1).
particiona([E|R], M1, M2, N, Ac) :-
	N1 is N-1,
	particiona(R, M1, M2, N1, [E|Ac]).

% junta_ord(L1, L2, I, F, Ord) afirma que Ord e resultado de juntar L1 e L2 ordenadamente de acordo
% com os melhores movimentos para chegar de I a F.
junta_ord(L1, L2, I, F, Ord) :- junta_ord(L1, L2, I, F, Ord, []).
junta_ord([], [], _, _, Ord, Ac) :- inverte(Ac, Ord).
junta_ord([E1|R1], [E2|R2], I, F, Ord, Ac) :-
	melhor_mov(E1, E2, I, F),
	junta_ord(R1, [E2|R2], I, F, Ord, [E1|Ac]).
junta_ord([E1|R1], [E2|R2], I, F, Ord, Ac) :-
	\+(melhor_mov(E1, E2, I, F)),
	junta_ord([E1|R1], R2, I, F, Ord, [E2|Ac]).
junta_ord([], [E|R], I, F, Ord, Ac) :-
	junta_ord([], R, I, F, Ord, [E|Ac]).
junta_ord([E|R], [], I, F, Ord, Ac) :-
	junta_ord(R, [], I, F, Ord, [E|Ac]).

% ordena_poss(Poss, Ord, I, F) afirma que Ord e Poss ordenado de acordo com a eficiencia a chegar de
% I a F.
% E utilizado o algoritmo merge sort para ordenar a lista, dado que este e inatamente recursivo, logo
% simples de programar no Prolog.
ordena_poss([], [], _, _).
ordena_poss([X], [X], _, _).
ordena_poss(Poss, Ord, I, F) :-
	length(Poss, Len),
	Len > 1,
	particiona(Poss, M1, M2),
	ordena_poss(M1, Ord1, I, F),
	ordena_poss(M2, Ord2, I, F),
	junta_ord(Ord1, Ord2, I, F, Ord).

% Predicado principal: resolve(Lab, I, F, Sol) afirma que Sol e uma sequencia de movimentos que resolve
% o labirinto Lab, com inicio no ponto I e final no ponto F.

% resolve1 - versao do resolve que admite qualquer solucao que nao envolva passar 2 vezes pela mesma celula
% do labirinto.
resolve1(Lab, (X,Y), F, Sol) :- resolve1(Lab, (X,Y), F, Sol, [(i,X,Y)], (X,Y)).
resolve1(_, _, F, Sol, Ac, F) :- inverte(Ac, Sol).
resolve1(Lab, I, F, Sol, Ac, P) :-
	movs_possiveis(Lab, P, Ac, Movs_pot),
	membro(Movs_pot, (Dir, X, Y)),
	resolve1(Lab, I, F, Sol, [(Dir,X,Y)|Ac], (X,Y)).

% resolve2 - versao do resolve que gera a solucao escolhendo sempre o melhor movimento. O melhor movimento
% tal como no predicado melhor e aquele que alcanca uma posicao mais perto do fim e em caso de empate
% mais longe do inicio.
resolve2(Lab, (X,Y), F, Sol) :- resolve2(Lab, (X,Y), F, Sol, [(i,X,Y)], (X,Y)).
resolve2(_, _, F, Sol, Ac, F) :- inverte(Ac, Sol).
resolve2(Lab, I, F, Sol, Ac, P) :-
	movs_possiveis(Lab, P, Ac, Movs_pot),
	ordena_poss(Movs_pot, Movs_ord, I, F),
	membro(Movs_ord, (Dir, X, Y)),
	resolve2(Lab, I, F, Sol, [(Dir,X,Y)|Ac], (X,Y)).

% membro(List, El) afirma que El pertence a lista List.
membro([El|_], El).
membro([_|R], El) :- membro(R, El).
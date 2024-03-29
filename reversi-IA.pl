/* Base statique reversi */

/*[g,4]*/
/*grilleDepart([[x,o,o,x,o,o,o,o],[x,x,o,x,x,x,x,x],[x,x,x,o,o,x,x,x],[x,x,x,o,o,o,x,x],[x,x,x,o,x,x,o,x],[x,x,x,x,o,o,o,x],[x,x,x,x,x,o,x,x],[x,o,o,o,o,x,x,x]]).*/
grilleDepart([[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,x,o,-,-,-],[-,-,-,o,x,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-]]).
toutesLesCasesDepart([[a,1],[b,1],[c,1],[d,1],[e,1],[f,1],[g,1],[h,1],[a,2],[b,2],[c,2],[d,2],[e,2],[f,2],[g,2],[h,2],[a,3],[b,3],[c,3],[d,3],[e,3],[f,3],[g,3],[h,3],[a,4],[b,4],[c,4],[d,4],[e,4],[f,4],[g,4],[h,4],[a,5],[b,5],[c,5],[d,5],[e,5],[f,5],[g,5],[h,5],[a,6],[b,6],[c,6],[d,6],[e,6],[f,6],[g,6],[h,6],[a,7],[b,7],[c,7],[d,7],[e,7],[f,7],[g,7],[h,7],[a,8],[b,8],[c,8],[d,8],[e,8],[f,8],[g,8],[h,8]]).

pion(x).
pion(o).
campAdv(x,o).
campAdv(o,x).
vide(-).

joueur(x).

succCol(a,b).
succCol(b,c).
succCol(c,d).
succCol(d,e).
succCol(e,f).
succCol(f,g).
succCol(g,h).

succLigne(1,2).
succLigne(2,3).
succLigne(3,4).
succLigne(4,5).
succLigne(5,6).
succLigne(6,7).
succLigne(7,8).

/* Affichage Ligne */

afficheLigne([A,B,C,D,E,F,G,H], N):- write(N), write(" : "), write(A) ,write(" | "),write(B),write(" | "),write(C),
    write(" | "),write(D),write(" | "),write(E),write(" | "),write(F),write(" | "),write(G),write(" | "),write(H).
afficheGrille([L1,L2,L3,L4,L5,L6,L7,L8]):- nl, write("# : a | b | c | d | e | f | g | h"), nl, afficheLigne(L1,1),
    nl, afficheLigne(L2,2), nl, afficheLigne(L3,3), nl, afficheLigne(L4,4), nl, afficheLigne(L5,5), nl,
    afficheLigne(L6,6), nl, afficheLigne(L7,7), nl, afficheLigne(L8,8), nl.

/* saisie coup */

saisieUnCoup(COL,LIG):-
    nl, write("Saisir colonne : "), nl, read(COL),
    nl, write("Saisir ligne : "), nl, read(LIG).

/* fonctions de base */
coordonneesOuListe(C,L,[C,L]).
/*coordonneesOuListe(C,L,[C|L]).*/

/* Recuperation d'une case dans une ligne */
caseDeLigne(a, [Case|_], Case).
caseDeLigne(NCol, [X|Ligne], Case):-
    succCol(NColSuiv,NCol),
    caseDeLigne(NColSuiv,Ligne,Case).

/* Recuperation d'une ligne dans une grille */
ligneDeGrille(1, [Ligne|Grille], Ligne).
ligneDeGrille(NLigne, [X|Grille], Ligne):-
    succLigne(NLigneSuiv,NLigne),
    ligneDeGrille(NLigneSuiv,Grille,Ligne).

/* Recuperation d'une case dans une grille */
caseDeGrille(NCol,NLigne,Grille,Case):-
    ligneDeGrille(NLigne, Grille, Ligne),
    caseDeLigne(NCol, Ligne, Case), !.

/* Liste Cases Jouables */
listeCasesJouables(_,_,[],[]).
listeCasesJouables(Camp,Grille,[Coup|Liste1],[Coup|Liste2]):-
    coupValide(Grille, Coup, Camp),
    listeCasesJouables(Camp, Grille, Liste1, Liste2), !.
listeCasesJouables(Camp,Grille,[Coup|Liste1],Liste2):-
    listeCasesJouables(Camp, Grille, Liste1, Liste2), !.

/* 
 * Verifie que le coup soit valide
 * Le coup est considere valide si la case donnee est vide et si au moins une case à côte est le debut d'un alignement de pions
 * du camp adverse se terminant sur un pion de notre propre camp
 */
coupValide(Grille, Coord, Camp):-
    coordonneesOuListe(NCol, NLigne, Coord), succCol(NCol, NColSuiv), caseDeGrille(NCol, NLigne, Grille, CaseCoup),
    vide(CaseCoup), caseDeGrille(NColSuiv, NLigne, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([NCol,NLigne], [NColSuiv,NLigne], L), verifChangementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NColSuiv, NCol), caseDeGrille(NCol, NLigne, Grille, CaseCoup),
    vide(CaseCoup), caseDeGrille(NColSuiv, NLigne, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([NCol,NLigne], [NColSuiv,NLigne], L), verifChangementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NCol, NColSuiv), succLigne(NLigne, NLigneSuiv),
    caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), caseDeGrille(NColSuiv, NLigneSuiv, Grille, CaseCote),
    campAdv(Camp, CaseCote), getListeDepl([NCol,NLigne], [NColSuiv,NLigneSuiv], L),
    verifChangementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NCol, NColSuiv), succLigne(NLigneSuiv, NLigne),
    caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), caseDeGrille(NColSuiv, NLigneSuiv, Grille, CaseCote),
    campAdv(Camp, CaseCote), getListeDepl([NCol,NLigne], [NColSuiv,NLigneSuiv], L),
    verifChangementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NColSuiv, NCol), succLigne(NLigne, NLigneSuiv),
    caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), caseDeGrille(NColSuiv, NLigneSuiv, Grille, CaseCote),
    campAdv(Camp, CaseCote), getListeDepl([NCol,NLigne], [NColSuiv,NLigneSuiv], L),
    verifChangementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NColSuiv, NCol), succLigne(NLigneSuiv, NLigne),
    caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), caseDeGrille(NColSuiv, NLigneSuiv, Grille, CaseCote),
    campAdv(Camp, CaseCote), getListeDepl([NCol,NLigne], [NColSuiv,NLigneSuiv], L),
    verifChangementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succLigne(NLigne, NLigneSuiv), caseDeGrille(NCol, NLigne, Grille, CaseCoup),
    vide(CaseCoup), caseDeGrille(NCol, NLigneSuiv, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([NCol,NLigne], [NCol,NLigneSuiv], L), verifChangementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succLigne(NLigneSuiv, NLigne), caseDeGrille(NCol, NLigne, Grille, CaseCoup),
    vide(CaseCoup), caseDeGrille(NCol, NLigneSuiv, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([NCol,NLigne], [NCol,NLigneSuiv], L), verifChangementPion(Grille, L, CaseCote).



/* Verifie qu'il y a un changement de camp dans un alignement de pions */
verifChangementPion(Grille, [X|_], Camp):-
    coordonneesOuListe(NCol, NLigne, X),
    caseDeGrille(NCol, NLigne, Grille, Coup),
    campAdv(Camp, Coup).
verifChangementPion(Grille, [X|Ligne], Camp):-
    coordonneesOuListe(NCol, NLigne, X),
    caseDeGrille(NCol, NLigne, Grille, Coup),
    Coup==Camp,
    verifChangementPion(Grille, Ligne, Camp).

/* Change les valeurs des lignes de deplacements donnees pour le camp donne */
changerLigne(GrilleDepart, GrilleDepart, [], Camp).
changerLigne(GrilleDepart, GrilleDepart, [Coord|_], Camp):- 
    coordonneesOuListe(NCol, NLigne, Coord), caseDeGrille(NCol, NLigne, GrilleDepart, Camp).
changerLigne(GrilleDepart, GrilleArrivee, [Coord|ListeDepl], Camp):-
    changerLigne(GrilleDepart, GrilleInter, ListeDepl, Camp),
    coordonneesOuListe(NCol, NLigne, Coord), caseDeGrille(NCol, NLigne, GrilleDepart, CampAdv), campAdv(Camp, CampAdv),
    coupJoueDansGrille(NCol, NLigne, Camp, GrilleInter, GrilleArrivee), !.


/* Recupère la liste des cases suivant la direction donnee par les deux premières coordonnees */
getListeDepl([X,Y1], [X,Y2], L):-
    succLigne(Y1,Y2), getColonneHB([X,Y2], L);
    succLigne(Y2,Y1), getColonneBH([X,Y2], L).
getListeDepl([X1,Y], [X2,Y], L):-
    succCol(X1,X2), getLigneGD([X2,Y], L);
    succCol(X2,X1), getLigneDG([X2,Y], L).
getListeDepl([X1,Y1], [X2,Y2], L):-
    succCol(X1,X2), succLigne(Y1,Y2), getDiagonaleGDHB([X2,Y2], L);
    succCol(X2,X1), succLigne(Y1,Y2), getDiagonaleDGHB([X2,Y2], L);
    succCol(X1,X2), succLigne(Y2,Y1), getDiagonaleGDBH([X2,Y2], L);
    succCol(X2,X1), succLigne(Y2,Y1), getDiagonaleDGBH([X2,Y2], L).

getLigneGD([X,Y], [[X,Y]]):- not(succCol(X,_)).
getLigneGD([X1,Y], [[X1,Y]|L]):- succCol(X1, X2), getLigneGD([X2,Y], L).

getLigneDG([X,Y], [[X,Y]]):- not(succCol(_,X)).
getLigneDG([X1,Y], [[X1,Y]|L]):- succCol(X2, X1), getLigneDG([X2,Y], L).

getColonneHB([X,Y], [[X,Y]]):- not(succLigne(Y,_)).
getColonneHB([X,Y1], [[X,Y1]|L]):- succLigne(Y1, Y2), getColonneHB([X,Y2], L).

getColonneBH([X,Y], [[X,Y]]):- not(succLigne(_,Y)).
getColonneBH([X,Y1], [[X,Y1]|L]):- succLigne(Y2, Y1), getColonneBH([X,Y2], L).

getDiagonaleGDHB([X,Y], [[X,Y]]):- not(succCol(X,_)); not(succLigne(Y,_)).
getDiagonaleGDHB([X1,Y1], [[X1,Y1]|L]):- succLigne(Y1, Y2), succCol(X1, X2), getDiagonaleGDHB([X2,Y2], L).

getDiagonaleGDBH([X,Y], [[X,Y]]):- not(succCol(X,_)); not(succLigne(_,Y)).
getDiagonaleGDBH([X1,Y1], [[X1,Y1]|L]):- succLigne(Y2, Y1), succCol(X1, X2), getDiagonaleGDBH([X2,Y2], L).

getDiagonaleDGHB([X,Y], [[X,Y]]):- not(succCol(_,X)); not(succLigne(Y,_)).
getDiagonaleDGHB([X1,Y1], [[X1,Y1]|L]):- succLigne(Y1, Y2), succCol(X2, X1), getDiagonaleDGHB([X2,Y2], L).

getDiagonaleDGBH([X,Y], [[X,Y]]):- not(succCol(_, X)); not(succLigne(_,Y)).
getDiagonaleDGBH([X1,Y1], [[X1,Y1]|L]):- succLigne(Y2, Y1), succCol(X2, X1), getDiagonaleDGBH([X2,Y2], L).

coupJoueDansLigne(a,VAL,[_|Q],[VAL|Q]).
coupJoueDansLigne(C,VAL,[T|Q],[T|Q2]):- succCol(X,C), coupJoueDansLigne(X,VAL,Q,Q2).

coupJoueDansGrille(C,1,VAL,[T|Q],[X|Q]):- coupJoueDansLigne(C,VAL,T,X).
coupJoueDansGrille(C,L,VAL,[T|Q],[T|Q2]):- succLigne(X,L), coupJoueDansGrille(C,X,VAL,Q,Q2).

joueLeCoup(GrilleDepart, [NCol, NLigne], Camp, GrilleArrivee):-
    coupValide(GrilleDepart, [NCol, NLigne], Camp),
    coupJoueDansGrille(NCol, NLigne, Camp, GrilleDepart, GrilleInter),
    casesAvoisinantes([NCol, NLigne], CasesAvoisinantes),
    joueCoupChangeCase(GrilleInter, GrilleArrivee, CasesAvoisinantes, [NCol, NLigne], Camp), !.

/* Actual function */
joueCoupChangeCase(GrilleDepart, GrilleArrivee, [], Coord, Camp):- GrilleArrivee = GrilleDepart.
joueCoupChangeCase(GrilleDepart, GrilleArrivee, [[NCol, NLigne]|ListCases], Coord, Camp):-
    joueCoupChangeCase(GrilleDepart, GrilleInter, ListCases, Coord, Camp),
    caseDeGrille(NCol, NLigne, GrilleInter, CaseCoup), campAdv(CaseCoup, Camp),
    getListeDepl(Coord, [NCol, NLigne], ListeDepl),
    verifChangementPion(GrilleInter, ListeDepl, CaseCoup),
    changerLigne(GrilleInter, GrilleArrivee, ListeDepl, Camp);

    joueCoupChangeCase(GrilleDepart, GrilleArrivee, ListCases, Coord, Camp),
    caseDeGrille(NCol, NLigne, GrilleArrivee, CaseCoup).

casesAvoisinantes([a,1],[[a,2],[b,2],[b,2]]).
casesAvoisinantes([a,8],[[a,7],[b,7],[b,8]]). 
casesAvoisinantes([h,1],[[g,1],[g,2],[h,2]]).
casesAvoisinantes([h,8],[[g,7],[h,7],[g,8]]).

casesAvoisinantes([a,L],[C1,C2,C3,C4,C5]):- succLigne(L,M), succLigne(K,L), coordonneesOuListe(a,K,C1),
    coordonneesOuListe(b,K,C2), coordonneesOuListe(b,L,C3), coordonneesOuListe(a,M,C4), coordonneesOuListe(b,M,C5).
casesAvoisinantes([h,L],[C1,C2,C3,C4,C5]):- succLigne(L,M), succLigne(K,L), coordonneesOuListe(h,K,C1), 
    coordonneesOuListe(g,K,C2), coordonneesOuListe(g,L,C3), coordonneesOuListe(h,M,C4), coordonneesOuListe(g,M,C5).
casesAvoisinantes([C,1],[C1,C2,C3,C4,C5]):- succCol(C,D), succCol(B,C), coordonneesOuListe(B,1,C1),
    coordonneesOuListe(B,2,C2), coordonneesOuListe(C,2,C3), coordonneesOuListe(D,1,C4), coordonneesOuListe(D,2,C5).
casesAvoisinantes([C,8],[C1,C2,C3,C4,C5]):- succCol(C,D), succCol(B,C), coordonneesOuListe(B,8,C1),
    coordonneesOuListe(B,7,C2), coordonneesOuListe(C,7,C3), coordonneesOuListe(D,7,C4), coordonneesOuListe(D,8,C5).

casesAvoisinantes([C,L],[C1,C2,C3,C4,C5,C6,C7,C8]):- succLigne(L,M), succLigne(K,L), succCol(C,D), succCol(B,C),
    coordonneesOuListe(B,K,C1), coordonneesOuListe(C,K,C2), coordonneesOuListe(D,K,C3), coordonneesOuListe(B,L,C4),
    coordonneesOuListe(D,L,C5), coordonneesOuListe(B,M,C6), coordonneesOuListe(C,M,C7), coordonneesOuListe(D,M,C8).

resteCasesVides([Ligne|Grille]):-
    videDansLigne(Ligne), !;
    resteCasesVides(Grille).
    
videDansLigne([Val|Ligne]):- 
    vide(Val), !;
    not(vide(Val)),
    videDansLigne(Ligne).

/*

Compte Elements

Compte le nombre de valeur T dans la grille [T|Q]

*/
compteElements([],_,0).
compteElements([T|Q],T,N):- compteElements(Q,T,M), N = M+1.
compteElements([T|Q],Z,N):- compteElements(Q,Z,N).
compteElementsGrille([], _, 0).
compteElementsGrille([Ligne|Grille], Val, N):-
    compteElementsGrille(Grille, Val, N1), 
    compteElements(Ligne, Val, N2),
    N is N1+N2, !.


/* Existe dans Liste, verifie si un element existe dans une liste */

existeDansListe(ELEMENT,[]):- fail.
existeDansListe(ELEMENT,[ELEMENT|Q]).
existeDansListe(ELEMENT,[T|Q]):- existeDansListe(ELEMENT,Q).

displayScore(GRILLE):- compteElementsGrille(GRILLE,x,SCOREX), compteElementsGrille(GRILLE,o,SCOREO), nl,
    write("x : "), write(SCOREX), write(" | o : "), write(SCOREO), VIDES is 64-(SCOREO+SCOREX), write(" | - : "),
    write(VIDES).

/* Fin de Partie, CAMP est gagnant */
moteur(GRILLE, CAMP):- not(resteCasesVides(GRILLE)), compteElementsGrille(GRILLE,CAMP,N), N > 32, nl,
    write("Victoire de "), write(CAMP).

/* Fin de Partie, CAMP est perdant */
moteur(GRILLE, CAMP):- not(resteCasesVides(GRILLE)), compteElementsGrille(GRILLE,CAMP,N), N < 32,
    campAdv(CAMP,GAGNANT), nl, write("Victoire de "), write(GAGNANT).

/* Fin de Partie, Egalite */
moteur(GRILLE, CAMP):- not(resteCasesVides(GRILLE)), compteElementsGrille(GRILLE,CAMP,N), N =:= 32, nl,
    write("Dommage, c'est une egalite !").

/* Partie non terminée, CAMP ne peut pas jouer */
moteur(GRILLE, CAMP):- toutesLesCasesDepart(LDEP), listeCasesJouables(CAMP,GRILLE,LDEP,RES), RES = [], nl,
    write("Camp "), write(CAMP), write(" ne pas pas jouer !"), campAdv(CAMP,ADV), moteur(GRILLE,ADV). 

/* Partie non terminee, Joueur IA peut jouer */
moteur(GRILLE, CAMP):- toutesLesCasesDepart(LDEP), listeCasesJouables(CAMP,GRILLE,LDEP,LCASES), not(LCASES = []),
    not(joueur(CAMP)), joueurIA1(GRILLE,CASE), joueLeCoup(GRILLE, CASE, CAMP, ARR), afficheGrille(ARR), displayScore(ARR),
    campAdv(CAMP,ADV), moteur(ARR,ADV). 

/* Partie non terminee, Joueur peut jouer */
moteur(GRILLE, CAMP):- nl, write("Camp "), write(CAMP), write(", a vous de jouer"), toutesLesCasesDepart(LDEP),
    listeCasesJouables(CAMP,GRILLE,LDEP,LCASES), not(LCASES = []), saisieUnCoup(C,L), coordonneesOuListe(C,L,CASE),
    existeDansListe(CASE,LCASES), joueLeCoup(GRILLE, CASE, CAMP, ARR), afficheGrille(ARR), displayScore(ARR),
    campAdv(CAMP,ADV), moteur(ARR,ADV). 

/* Partie non terminee, CAMP peut jouer, Case Invalide */
moteur(GRILLE, CAMP):- nl, write("Case invalide, reessayez !"), moteur(GRILLE,CAMP).

/* Run */
run():-
    grilleDepart(Grille),
    afficheGrille(Grille),
    joueur(Camp),
    moteur(Grille, Camp).

debug([[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,x,x,x,-,-],[-,-,-,o,x,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-]]).
ldep([[e,5], [d,5], [c,5], [b,5], [a,5]]).  



/*
    Joueur intelligent
*/
joueurIA1(Grille, Coup):-
    toutesLesCasesDepart(CasesDepart),
    pion(Camp), not(joueur(Camp)),
    listeCasesJouables(Camp, Grille, CasesDepart, CasesJouables),
    determinerCoupMax(Grille, Camp, CasesJouables, Coup, _).


determinerCoupMax(_,_,[],[],0). 
determinerCoupMax(GRILLE,CAMP,[T|LISTECOUPS],COUP,N):- determinerCoupMax(GRILLE,CAMP,LISTECOUPS,COUP,N), 
    joueLeCoup(GRILLE,T,CAMP,ARR), compteElementsGrille(ARR, CAMP, K), N >= K.
determinerCoupMax(GRILLE,CAMP,[T|LISTECOUPS],T,N):- determinerCoupMax(GRILLE,CAMP,LISTECOUPS,COUP,M), 
    joueLeCoup(GRILLE,T,CAMP,ARR), compteElementsGrille(ARR, CAMP, N), N > M.


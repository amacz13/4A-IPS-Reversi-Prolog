/* Base statique reversi */

grilleDepart([[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,x,o,-,-,-],[-,-,-,o,x,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-]]).
pion(x).
pion(o).
campAdv(x,o).
campAdv(o,x).
vide(-).

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

afficheLigne([A,B,C,D,E,F,G,H]):- write(A),write(" | "),write(B),write(" | "),write(C),write(" | "),
    write(D),write(" | "),write(E),write(" | "),write(F),write(" | "),write(G),write(" | "),write(H).
afficheGrille([L1,L2,L3,L4,L5,L6,L7,L8]):- nl, afficheLigne(L1), nl, afficheLigne(L2), nl, afficheLigne(L3), nl, afficheLigne(L4), nl, afficheLigne(L5), nl, afficheLigne(L6), nl, afficheLigne(L7), nl, afficheLigne(L8), nl.

/* saisie coup */

saisieUnCoup(COL,LIG):- nl, write("Saisir colonne : "), nl, read(COL), nl, write("Saisir ligne : "), nl, read(LIG).

/* fonctions de base */
coordonneesOuListe(C,L,[C,L]).
/*coordonneesOuListe(C,L,[C|L]).*/

/* Récupération d'une case dans une ligne */
caseDeLigne(a, [Case|_], Case).
caseDeLigne(NCol, [X|Ligne], Case):-
    succCol(NColSuiv,NCol),
    caseDeLigne(NColSuiv,Ligne,Case).

/* Récupération d'une ligne dans une grille */
ligneDeGrille(1, [Ligne|Grille], Ligne).
ligneDeGrille(NLigne, [X|Grille], Ligne):-
    succLigne(NLigneSuiv,NLigne),
    ligneDeGrille(NLigneSuiv,Grille,Ligne).

/* Récupération d'une case dans une grille */
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

/* Vérifie que le coup soit valide
 * Le coup est considéré valide si la case donnée est vide et si au moins une case à côté est le début d'un alignement de pions
 * du camp adverse se terminant sur un pion de notre propre camp
 */
coupValide(Grille, Coord, Camp):-
    coordonneesOuListe(NCol, NLigne, Coord), succCol(NCol, NColSuiv), caseDeGrille(NCol, NLigne, Grille, CaseCoup),
    vide(CaseCoup), caseDeGrille(NColSuiv, NLigne, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([NCol,NLigne], [NColSuiv,NLigne], L), changementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NColSuiv, NCol), caseDeGrille(NCol, NLigne, Grille, CaseCoup),
    vide(CaseCoup), caseDeGrille(NColSuiv, NLigne, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([NCol,NLigne], [NColSuiv,NLigne], L), changementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NCol, NColSuiv), succLigne(NLigne, NLigneSuiv),
    caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), caseDeGrille(NColSuiv, NLigneSuiv, Grille, CaseCote),
    campAdv(Camp, CaseCote), getListeDepl([NCol,NLigne], [NColSuiv,NLigneSuiv], L), changementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NCol, NColSuiv), succLigne(NLigneSuiv, NLigne),
    caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), caseDeGrille(NColSuiv, NLigneSuiv, Grille, CaseCote),
    campAdv(Camp, CaseCote), getListeDepl([NCol,NLigne], [NColSuiv,NLigneSuiv], L), changementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NColSuiv, NCol), succLigne(NLigne, NLigneSuiv),
    caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), caseDeGrille(NColSuiv, NLigneSuiv, Grille, CaseCote),
    campAdv(Camp, CaseCote), getListeDepl([NCol,NLigne], [NColSuiv,NLigneSuiv], L), changementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succCol(NColSuiv, NCol), succLigne(NLigneSuiv, NLigne),
    caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), caseDeGrille(NColSuiv, NLigneSuiv, Grille, CaseCote),
    campAdv(Camp, CaseCote), getListeDepl([NCol,NLigne], [NColSuiv,NLigneSuiv], L), changementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succLigne(NLigne, NLigneSuiv), caseDeGrille(NCol, NLigne, Grille, CaseCoup),
    vide(CaseCoup), caseDeGrille(NCol, NLigneSuiv, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([NCol,NLigne], [NCol,NLigneSuiv], L), changementPion(Grille, L, CaseCote);

    coordonneesOuListe(NCol, NLigne, Coord), succLigne(NLigneSuiv, NLigne), caseDeGrille(NCol, NLigne, Grille, CaseCoup),
    vide(CaseCoup), caseDeGrille(NCol, NLigneSuiv, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([NCol,NLigne], [NCol,NLigneSuiv], L), changementPion(Grille, L, CaseCote).

/* Vérifie qu'il y a un changement de camp dans un alignement de pions */
changementPion(Grille, [X|_], Camp):- coordonneesOuListe(NCol, NLigne, X), caseDeGrille(NCol, NLigne, Grille, Coup), campAdv(Camp, Coup).
changementPion(Grille, [X|Ligne], Camp):- coordonneesOuListe(NCol, NLigne, X), caseDeGrille(NCol, NLigne, Grille, Coup), Coup==Camp, changementPion(Grille, Ligne, Camp).

/* Récupère la liste des cases suivant la direction donnée par les deux premières coordonnées */
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
getDiagonaleGDHB([X,Y], [[X,Y]]):- not(succCol(X,_)), not(succLigne(Y,_)).
getDiagonaleGDHB([X1,Y1], [[X1,Y1]|L]):- succLigne(Y1, Y2), succCol(X1, X2), getDiagonaleGDHB([X2,Y2], L).
getDiagonaleGDBH([X,Y], [[X,Y]]):- not(succCol(X,_)), not(succLigne(_,Y)).
getDiagonaleGDBH([X1,Y1], [[X1,Y1]|L]):- succLigne(Y2, Y1), succCol(X1, X2), getDiagonaleGDBH([X2,Y2], L).
getDiagonaleDGHB([X,Y], [[X,Y]]):- not(succCol(_,X)), not(succLigne(Y,_)).
getDiagonaleDGHB([X1,Y1], [[X1,Y1]|L]):- succLigne(Y1, Y2), succCol(X2, X1), getDiagonaleDGHB([X2,Y2], L).
getDiagonaleDGBH([X,Y], [[X,Y]]):- not(succCol(_, X)), not(succLigne(_,Y)).
getDiagonaleDGBH([X1,Y1], [[X1,Y1]|L]):- succLigne(Y2, Y1), succCol(X2, X1), getDiagonaleDGBH([X2,Y2], L).

toutesLesCasesDepart([[a,1],[b,1],[c,1],[d,1],[e,1],[f,1],[g,1],[h,1],[a,2],[b,2],[c,2],[d,2],[e,2],[f,2],[g,2],[h,2],[a,3],[b,3],[c,3],[d,3],[e,3],[f,3],[g,3],[h,3],[a,4],[b,4],[c,4],[d,4],[e,4],[f,4],[g,4],[h,4],[a,5],[b,5],[c,5],[d,5],[e,5],[f,5],[g,5],[h,5],[a,6],[b,6],[c,6],[d,6],[e,6],[f,6],[g,6],[h,6],[a,7],[b,7],[c,7],[d,7],[e,7],[f,7],[g,7],[h,7],[a,8],[b,8],[c,8],[d,8],[e,8],[f,8],[g,8],[h,8]]).
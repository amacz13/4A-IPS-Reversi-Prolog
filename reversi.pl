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
succCol(d,f).
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
    caseDeLigne(NCol, Ligne, Case).

/* Liste Cases Jouables */

listeCasesJouables(GRILLE,[],[]).
listeCasesJouables(CAMP, GRILLE,[T|Q],LISTE):- listeCasesJouables(GRILLE,Q,LISTE), coordonneesOuListe(C,L,T),
    caseDeGrille(C,L,GRILLE,CASE), CASE = -, coupValide(GRILLE,T,CAMP), LISTE = [LISTE|CASE].

/* Vérifie que le coup soit valide
 * Le coup est considéré valide si la case donnée est vide et si au moins une case à côté est le début d'un alignement de pions
 * du camp adverse se terminant sur un pion de notre propre camp
 */
coupValide(Grille, Coord, Camp):-
    coordonneesOuListe(Ncol, NLigne, Coord), caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), succCol(Ncol, NcolSuiv),
    caseDeGrille(Ncol, Nligne, Grille, CaseCote), campAdv(Camp, CaseCote), getListeDepl([Ncol|Nligne], [NcolSuiv|Nligne], L),
    changementPion(L, CaseCote);
    coordonneesOuListe(Ncol, NLigne, Coord), caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), succCol(NcolSuiv, Ncol),
    caseDeGrille(Ncol, Nligne, Grille, CaseCote), campAdv(Camp, CaseCote), getListeDepl([Ncol|Nligne], [NcolSuiv|Nligne], L),
    changementPion(L, CaseCote);
    coordonneesOuListe(Ncol, NLigne, Coord), caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), succCol(Ncol, NcolSuiv),
    succLigne(Nligne, NligneSuiv), caseDeGrille(Ncol, Nligne, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([Ncol|Nligne], [NcolSuiv|NligneSuiv], L), changementPion(L, CaseCote);
    coordonneesOuListe(Ncol, NLigne, Coord), caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), succCol(Ncol, NcolSuiv),
    succLigne(NligneSuiv, Nligne), caseDeGrille(Ncol, Nligne, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([Ncol|Nligne], [NcolSuiv|NligneSuiv], L), changementPion(L, CaseCote);
    coordonneesOuListe(Ncol, NLigne, Coord), caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), succCol(NcolSuiv, Ncol),
    succLigne(Nligne, NligneSuiv), caseDeGrille(Ncol, Nligne, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([Ncol|Nligne], [NcolSuiv|NligneSuiv], L), changementPion(L, CaseCote);
    coordonneesOuListe(Ncol, NLigne, Coord), caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), succCol(NcolSuiv, Ncol),
    succLigne(NligneSuiv, Nligne), caseDeGrille(Ncol, Nligne, Grille, CaseCote), campAdv(Camp, CaseCote),
    getListeDepl([Ncol|Nligne], [NcolSuiv|NligneSuiv], L), changementPion(L, CaseCote);
    coordonneesOuListe(Ncol, NLigne, Coord), caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), succLigne(Nligne, NligneSuiv),
    caseDeGrille(Ncol, Nligne, Grille, CaseCote), campAdv(Camp, CaseCote), getListeDepl([Ncol|Nligne], [Ncol|NligneSuiv], L),
    changementPion(L, CaseCote);
    coordonneesOuListe(Ncol, NLigne, Coord), caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup), succLigne(NligneSuiv, Nligne),
    caseDeGrille(Ncol, Nligne, Grille, CaseCote), campAdv(Camp, CaseCote), getListeDepl([Ncol|Nligne], [Ncol|NligneSuiv], L),
    changementPion(L, CaseCote).

/* Vérifie qu'il y a un changement de camp dans un alignement de pions */
changementPion([X|_], Camp):- campAdv(Camp, X).
changementPion([Camp|Ligne], Camp):- changementPion(Ligne, Camp).

/* Récupère la liste des cases suivant la direction donnée par les deux premières coordonnées */
getListeDepl([X,Y1], [X,Y2], L):-
    Y2>Y1, getColonneHB([X|Y2], L);
    Y2<Y1, getColonneBH([X|Y2], L).
getListeDepl([X1,Y], [X2,Y], L):-
    X2>X1, getLigneGD([X2|Y], L);
    X2<X1, getLigneDG([X2|Y], L).
getListeDepl([X1,Y1], [X2,Y2], L):-
    X2>X1, Y2>Y1, getDiagonaleGDHB([X2|Y2], L);
    X2<X1, Y2>Y1, getDiagonaleDGHB([X2|Y2], L);
    X2>X1, Y2<Y1, getDiagonaleGDBH([X2|Y2], L);
    X2<X1, Y2<Y1, getDiagonaleDGBH([X2|Y2], L).

getLigneGD([X|Y], [[X|Y]]):- not(succCol(X,_)).
getLigneGD([X1|Y], [[X1|Y]|L]):- succCol(X1, X2), getLigneGD([X2|Y], L).
getLigneDG([X|Y], [[X|Y]]):- not(succCol(_,X)).
getLigneDG([X1|Y], [[X1|Y]|L]):- succCol(X2, X1), getLigneGD([X2|Y], L).
getColonneHB([X|Y], [[X|Y]]):- not(succLigne(Y,_)).
getColonneHB([X|Y1], [[X|Y1]|L]):- succLigne(Y1, Y2), getLigneGD([X|Y2], L).
getColonneBH([X|Y], [[X|Y]]):- not(succLigne(_,X)).
getColonneBH([X|Y1], [[X|Y1]|L]):- succLigne(Y2, Y1), getLigneGD([X|Y2], L).
getDiagonaleGDHB([X|Y], [[X|Y]]):- not(succLigne(X,_)), not(succLigne(Y,_)).
getDiagonaleGDHB([X1|Y1], [[X1|Y1]|L]):- succLigne(Y1, Y2), succCol(X1, X2), getLigneGD([X2|Y2], L).
getDiagonaleGDBH([X|Y], [[X|Y]]):- not(succLigne(X,_)), not(succLigne(_,Y)).
getDiagonaleGDBH([X1|Y1], [[X1|Y1]|L]):- succLigne(Y2, Y1), succCol(X1, X2), getLigneGD([X2|Y2], L).
getDiagonaleDGHB([X|Y], [[X|Y]]):- not(succLigne(_,X)), not(succLigne(Y,_)).
getDiagonaleDGHB([X1|Y1], [[X1|Y1]|L]):- succLigne(Y1, Y2), succCol(X2, X1), getLigneGD([X2|Y2], L).
getDiagonaleDGBH([X|Y], [[X|Y]]):- not(succLigne(_, X)), not(succLigne(_,Y)).
getDiagonaleDGBH([X1|Y1], [[X1|Y1]|L]):- succLigne(Y2, Y1), succCol(X2, X1), getLigneGD([X2|Y2], L).